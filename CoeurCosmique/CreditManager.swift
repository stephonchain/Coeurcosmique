import Foundation

@MainActor
final class CreditManager: ObservableObject {

    // MARK: - Configuration

    static let dailyCreditAllowance = 3

    // MARK: - Published State

    @Published private(set) var credits: Int = 0

    // MARK: - Keys

    private static let creditsKey = "ai_credits_balance"
    private static let lastRefillDateKey = "ai_credits_last_refill"

    // MARK: - Init

    init() {
        refillIfNeeded()
    }

    // MARK: - Public

    var hasCredits: Bool { credits > 0 }

    func consumeCredit() -> Bool {
        guard credits > 0 else { return false }
        credits -= 1
        save()
        return true
    }

    func refillIfNeeded() {
        let today = Self.todayString
        let lastRefill = UserDefaults.standard.string(forKey: Self.lastRefillDateKey) ?? ""

        if lastRefill != today {
            credits = Self.dailyCreditAllowance
            UserDefaults.standard.set(today, forKey: Self.lastRefillDateKey)
            save()
        } else {
            credits = UserDefaults.standard.integer(forKey: Self.creditsKey)
        }
    }

    // MARK: - Private

    private func save() {
        UserDefaults.standard.set(credits, forKey: Self.creditsKey)
    }

    private static var todayString: String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: Date())
    }
}
