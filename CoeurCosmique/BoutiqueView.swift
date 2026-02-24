import SwiftUI

// MARK: - Cosmic Sphere Manager

@MainActor
final class CosmicSphereManager: ObservableObject {
    static let shared = CosmicSphereManager()

    private static let sphereKey = "cosmicSpheres_balance"
    static let spheresPerBooster = 10
    static let spheresPerPurchase = 50

    @Published private(set) var balance: Int = 0

    init() {
        balance = UserDefaults.standard.integer(forKey: Self.sphereKey)
    }

    var canOpenBooster: Bool {
        balance >= Self.spheresPerBooster
    }

    func add(_ amount: Int) {
        balance += amount
        save()
    }

    @discardableResult
    func spendForBooster() -> Bool {
        guard canOpenBooster else { return false }
        balance -= Self.spheresPerBooster
        save()
        return true
    }

    private func save() {
        UserDefaults.standard.set(balance, forKey: Self.sphereKey)
    }
}

// MARK: - Boutique View

struct BoutiqueView: View {
    @ObservedObject var viewModel: AppViewModel
    @EnvironmentObject var storeManager: StoreManager
    @EnvironmentObject var collectionManager: CardCollectionManager
    @EnvironmentObject var boosterManager: BoosterManager
    @StateObject private var sphereManager = CosmicSphereManager()
    @State private var showPaywall = false
    @State private var showBoosterOpening = false
    @State private var showSphereBooster = false
    @State private var showSphereConfirm = false
    @State private var purchaseConfirmation: String?
    @State private var showUnlockConfirm: CollectibleDeck?

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Boutique")
                        .font(.cosmicTitle(28))
                        .foregroundStyle(Color.cosmicText)

                    Text("Renforce ta collection cosmique")
                        .font(.cosmicCaption())
                        .foregroundStyle(Color.cosmicTextSecondary)
                }
                .padding(.top, 16)

                // Sphere balance
                sphereBalanceCard

                // Premium Pass
                premiumPassSection

                // Cosmic Spheres purchase
                cosmicSpheresSection

                // Oracle unlock packs
                oracleUnlockSection

                // Sphere booster
                sphereBoosterSection

                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(storeManager: storeManager)
        }
        .fullScreenCover(isPresented: $showBoosterOpening) {
            BoosterOpeningView(
                collectionManager: collectionManager,
                boosterManager: boosterManager,
                onDismiss: { showBoosterOpening = false }
            )
            .environmentObject(storeManager)
        }
        .fullScreenCover(isPresented: $showSphereBooster) {
            BoosterOpeningView(
                collectionManager: collectionManager,
                boosterManager: boosterManager,
                onDismiss: { showSphereBooster = false },
                isSphereBooster: true
            )
            .environmentObject(storeManager)
        }
        .overlay {
            if let msg = purchaseConfirmation {
                confirmationOverlay(msg)
            }
        }
        .alert("Ouvrir un Booster", isPresented: $showSphereConfirm) {
            Button("Annuler", role: .cancel) { }
            Button("Ouvrir (-10 Spheres)") {
                if sphereManager.spendForBooster() {
                    showSphereBooster = true
                }
            }
        } message: {
            Text("Depenser 10 Spheres Cosmiques pour ouvrir un Booster de 5 cartes ?")
        }
        .alert("Débloquer l'Oracle", isPresented: Binding(
            get: { showUnlockConfirm != nil },
            set: { if !$0 { showUnlockConfirm = nil } }
        )) {
            Button("Annuler", role: .cancel) { showUnlockConfirm = nil }
            Button("Acheter 9,99 €") {
                if let deck = showUnlockConfirm {
                    unlockFullDeck(deck)
                }
            }
        } message: {
            if let deck = showUnlockConfirm {
                Text("Obtenir toutes les cartes normales de \(deck.title) ?")
            }
        }
    }

    // MARK: - Sphere Balance

    private var sphereBalanceCard: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.cosmicPurple, .cosmicRose],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)

                Image(systemName: "circle.hexagongrid.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Spheres Cosmiques")
                    .font(.cosmicCaption(12))
                    .foregroundStyle(Color.cosmicTextSecondary)
                    .textCase(.uppercase)
                    .kerning(1.5)

                Text("\(sphereManager.balance)")
                    .font(.cosmicTitle(28))
                    .foregroundStyle(Color.cosmicGold)
            }

            Spacer()

            if sphereManager.canOpenBooster {
                VStack(spacing: 2) {
                    Text("\(sphereManager.balance / CosmicSphereManager.spheresPerBooster)")
                        .font(.cosmicHeadline(18))
                        .foregroundStyle(Color.cosmicGold)
                    Text("boosters")
                        .font(.cosmicCaption(10))
                        .foregroundStyle(Color.cosmicTextSecondary)
                }
            }
        }
        .padding(16)
        .cosmicCard(cornerRadius: 16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    LinearGradient(
                        colors: [Color.cosmicPurple.opacity(0.4), Color.cosmicRose.opacity(0.4)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }

    // MARK: - Premium Pass

    private var premiumPassSection: some View {
        VStack(spacing: 0) {
            if storeManager.isPremium {
                // Already premium
                HStack(spacing: 12) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(Color.cosmicGold)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Pass Premium Actif")
                            .font(.cosmicHeadline(16))
                            .foregroundStyle(Color.cosmicGold)

                        Text("+1 booster quotidien, tirages illimites, carte Collector")
                            .font(.cosmicCaption(12))
                            .foregroundStyle(Color.cosmicTextSecondary)
                    }

                    Spacer()

                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.green)
                }
                .padding(16)
                .cosmicCard(cornerRadius: 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.cosmicGold.opacity(0.4), lineWidth: 1.5)
                )
            } else {
                // Premium upsell
                Button {
                    showPaywall = true
                } label: {
                    VStack(spacing: 14) {
                        HStack(spacing: 12) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(Color.cosmicGold)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Pass Premium")
                                    .font(.cosmicHeadline(18))
                                    .foregroundStyle(Color.cosmicText)

                                Text("L'experience cosmique ultime")
                                    .font(.cosmicCaption(12))
                                    .foregroundStyle(Color.cosmicTextSecondary)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.cosmicGold)
                        }

                        // Benefits
                        VStack(alignment: .leading, spacing: 8) {
                            premiumBenefit(icon: "gift.fill", text: "+1 booster supplementaire par jour")
                            premiumBenefit(icon: "sparkles", text: "Tirages de cartes illimites")
                            premiumBenefit(icon: "star.fill", text: "Carte Collector exclusive")
                            premiumBenefit(icon: "brain.head.profile", text: "Interpretations IA illimitees")
                        }
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.cosmicCard)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(
                                        LinearGradient(
                                            colors: [Color.cosmicGold.opacity(0.6), Color.cosmicGold.opacity(0.2)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1.5
                                    )
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func premiumBenefit(icon: String, text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundStyle(Color.cosmicGold)
                .frame(width: 18)

            Text(text)
                .font(.cosmicBody(13))
                .foregroundStyle(Color.cosmicTextSecondary)
        }
    }

    // MARK: - Cosmic Spheres Purchase

    private var cosmicSpheresSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Spheres Cosmiques")
                    .font(.cosmicHeadline(16))
                    .foregroundStyle(Color.cosmicText)

                Spacer()
            }

            Button {
                purchaseCosmicSpheres()
            } label: {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [.cosmicPurple, .cosmicRose],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 56, height: 56)

                        VStack(spacing: 2) {
                            Image(systemName: "circle.hexagongrid.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(.white)
                            Text("x50")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("50 Spheres Cosmiques")
                            .font(.cosmicHeadline(15))
                            .foregroundStyle(Color.cosmicText)

                        Text("= 5 ouvertures de booster")
                            .font(.cosmicCaption(12))
                            .foregroundStyle(Color.cosmicTextSecondary)
                    }

                    Spacer()

                    Text("0,99 €")
                        .font(.cosmicHeadline(16))
                        .foregroundStyle(Color.cosmicGold)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .strokeBorder(Color.cosmicGold.opacity(0.5), lineWidth: 1.5)
                        )
                }
                .padding(14)
                .cosmicCard(cornerRadius: 16)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Oracle Unlock Packs

    private var oracleUnlockSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Debloquer un Oracle")
                    .font(.cosmicHeadline(16))
                    .foregroundStyle(Color.cosmicText)

                Spacer()
            }

            ForEach(CollectibleDeck.allCases, id: \.rawValue) { deck in
                oracleUnlockRow(deck: deck)
            }
        }
    }

    private func oracleUnlockRow(deck: CollectibleDeck) -> some View {
        let owned = collectionManager.ownedCount(deck: deck)
        let total = deck.totalCards
        let isComplete = collectionManager.hasCompleteDeck(deck)

        return Button {
            if !isComplete {
                showUnlockConfirm = deck
            }
        } label: {
            HStack(spacing: 14) {
                Circle()
                    .fill(deck.accentColor)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: isComplete ? "checkmark" : "lock.open.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.white)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(deck.title)
                        .font(.cosmicHeadline(14))
                        .foregroundStyle(Color.cosmicText)

                    Text("\(owned)/\(total) cartes")
                        .font(.cosmicCaption(12))
                        .foregroundStyle(deck.accentColor)
                }

                Spacer()

                if isComplete {
                    Text("Complete")
                        .font(.cosmicCaption(12))
                        .foregroundStyle(.green)
                } else {
                    Text("9,99 €")
                        .font(.cosmicHeadline(14))
                        .foregroundStyle(Color.cosmicGold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .strokeBorder(Color.cosmicGold.opacity(0.5), lineWidth: 1.5)
                        )
                }
            }
            .padding(14)
            .cosmicCard(cornerRadius: 14)
        }
        .buttonStyle(.plain)
        .disabled(isComplete)
    }

    // MARK: - Sphere Booster

    private var sphereBoosterSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Ouvrir avec des Spheres")
                    .font(.cosmicHeadline(16))
                    .foregroundStyle(Color.cosmicText)

                Spacer()
            }

            Button {
                openSphereBooster()
            } label: {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [.cosmicPurple, .cosmicRose],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 56, height: 56)

                        VStack(spacing: 2) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 18))
                                .foregroundStyle(.white)
                            Text("x5")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Booster Cosmique")
                            .font(.cosmicHeadline(15))
                            .foregroundStyle(Color.cosmicText)

                        Text("5 cartes aleatoires")
                            .font(.cosmicCaption(12))
                            .foregroundStyle(Color.cosmicTextSecondary)
                    }

                    Spacer()

                    HStack(spacing: 4) {
                        Image(systemName: "circle.hexagongrid.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.cosmicPurple)
                        Text("10")
                            .font(.cosmicHeadline(16))
                            .foregroundStyle(sphereManager.canOpenBooster ? Color.cosmicGold : Color.cosmicTextSecondary)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .strokeBorder(
                                sphereManager.canOpenBooster
                                    ? Color.cosmicGold.opacity(0.5)
                                    : Color.cosmicTextSecondary.opacity(0.3),
                                lineWidth: 1.5
                            )
                    )
                }
                .padding(14)
                .cosmicCard(cornerRadius: 16)
            }
            .buttonStyle(.plain)
            .disabled(!sphereManager.canOpenBooster)
            .opacity(sphereManager.canOpenBooster ? 1 : 0.6)
        }
    }

    // MARK: - Confirmation Overlay

    private func confirmationOverlay(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 40))
                .foregroundStyle(.green)

            Text(message)
                .font(.cosmicHeadline(16))
                .foregroundStyle(Color.cosmicText)
                .multilineTextAlignment(.center)
        }
        .padding(24)
        .cosmicCard(cornerRadius: 20)
        .shadow(color: .black.opacity(0.3), radius: 20)
        .transition(.scale.combined(with: .opacity))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    purchaseConfirmation = nil
                }
            }
        }
    }

    // MARK: - Actions

    private func purchaseCosmicSpheres() {
        // In production, this goes through StoreKit IAP
        // For now, simulate the purchase
        Task {
            if let product = storeManager.product(for: StoreManager.spheres50ID) {
                await storeManager.purchase(product)
                // If purchase succeeded, add spheres
                sphereManager.add(CosmicSphereManager.spheresPerPurchase)
                withAnimation {
                    purchaseConfirmation = "+50 Spheres Cosmiques !"
                }
            } else {
                // Fallback: direct add for testing
                sphereManager.add(CosmicSphereManager.spheresPerPurchase)
                withAnimation {
                    purchaseConfirmation = "+50 Spheres Cosmiques !"
                }
            }
        }
    }

    private func openSphereBooster() {
        guard sphereManager.canOpenBooster else { return }
        showSphereConfirm = true
    }

    private func unlockFullDeck(_ deck: CollectibleDeck) {
        // In production, this goes through StoreKit IAP
        // For now, unlock all normal cards in the deck
        Task {
            let productID: String
            switch deck {
            case .oracle: productID = StoreManager.unlockOracleID
            case .quantum: productID = StoreManager.unlockQuantumID
            case .rune: productID = StoreManager.unlockRunesID
            }

            if let product = storeManager.product(for: productID) {
                await storeManager.purchase(product)
            }

            // Unlock all cards in the deck
            for n in 1...deck.totalCards {
                _ = collectionManager.addCard(deck: deck, number: n, rarity: .common)
            }

            withAnimation {
                purchaseConfirmation = "\(deck.title) debloque !"
            }
        }
    }
}
