import Foundation
import StoreKit

@MainActor
final class StoreManager: ObservableObject {

    // MARK: - Product IDs

    static let weeklyID = "com.coeurcosmique.premium.weekly"
    static let monthlyID = "com.coeurcosmique.premium.monthly"
    static let yearlyID = "com.coeurcosmique.premium.yearly"

    // Consumables
    static let spheres50ID = "com.coeurcosmique.spheres.50"
    static let unlockOracleID = "com.coeurcosmique.unlock.oracle"
    static let unlockQuantumID = "com.coeurcosmique.unlock.quantum"
    static let unlockRunesID = "com.coeurcosmique.unlock.runes"

    private static let subscriptionIDs: Set<String> = [weeklyID, monthlyID, yearlyID]
    private static let productIDs: Set<String> = [
        weeklyID, monthlyID, yearlyID,
        spheres50ID, unlockOracleID, unlockQuantumID, unlockRunesID
    ]

    // MARK: - Published State

    @Published var products: [Product] = []
    @Published var isPremium: Bool = false
    @Published var purchaseInProgress: Bool = false
    @Published var errorMessage: String?

    /// Called when premium is first activated (purchase or restore). Use to grant bonus spheres.
    var onPremiumActivated: (() -> Void)?

    // MARK: - Private

    private var transactionListener: Task<Void, Never>?

    // MARK: - Init

    init() {
        // Do NOT check entitlements on init.
        // Premium is only activated when the user triggers a purchase or restore.
        // This prevents Apple from auto-detecting a prior subscription on reinstall.
        transactionListener = listenForTransactions()
    }

    deinit {
        transactionListener?.cancel()
    }

    // MARK: - Load Products

    func loadProducts() async {
        do {
            let storeProducts = try await Product.products(for: Self.productIDs)
            products = storeProducts.sorted { a, b in
                a.price < b.price
            }
            errorMessage = nil
        } catch {
            errorMessage = "Impossible de charger les abonnements."
        }
    }

    // MARK: - Purchase

    func purchase(_ product: Product) async {
        purchaseInProgress = true
        defer { purchaseInProgress = false }

        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                await checkEntitlements()
            case .userCancelled:
                break
            case .pending:
                break
            @unknown default:
                break
            }
        } catch {
            errorMessage = "L'achat a échoué. Réessaie."
        }
    }

    // MARK: - Restore

    func restorePurchases() async {
        try? await AppStore.sync()
        await checkEntitlements()
    }

    // MARK: - Entitlements

    func checkEntitlements() async {
        let wasPremium = isPremium
        for await result in Transaction.currentEntitlements {
            if let transaction = try? checkVerified(result) {
                if Self.subscriptionIDs.contains(transaction.productID) {
                    isPremium = true
                    if !wasPremium {
                        onPremiumActivated?()
                    }
                    return
                }
            }
        }
        isPremium = false
    }

    // MARK: - Transaction Listener

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                if let transaction = try? await self?.checkVerified(result) {
                    await transaction.finish()
                    // Only update premium if user already activated it this session
                    // (i.e. they triggered a purchase or restore)
                    if await self?.isPremium == true {
                        await self?.checkEntitlements()
                    }
                }
            }
        }
    }

    // MARK: - Verification

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let value):
            return value
        }
    }

    // MARK: - Helper

    func product(for id: String) -> Product? {
        products.first { $0.id == id }
    }
}

enum StoreError: Error {
    case failedVerification
}
