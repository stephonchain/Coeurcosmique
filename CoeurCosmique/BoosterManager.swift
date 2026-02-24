import SwiftUI
import Combine

@MainActor
final class BoosterManager: ObservableObject {
    static let shared = BoosterManager()

    // MARK: - Constants

    static let boosterSize = 5
    static let cooldownSeconds: TimeInterval = 12 * 60 * 60 // 12 hours
    static let premiumCooldownSeconds: TimeInterval = 24 * 60 * 60 // 24 hours (premium gets +1 per day)

    // MARK: - Published State

    @Published private(set) var canOpenBooster: Bool = false
    @Published private(set) var nextBoosterDate: Date? = nil
    @Published private(set) var boostersOpenedToday: Int = 0
    @Published private(set) var lastBoosterCards: [BoosterCard] = []
    @Published private(set) var streak: Int = 0

    // MARK: - Storage Keys

    private static let lastOpenKey = "booster_lastOpenTime"
    private static let openedTodayKey = "booster_openedToday"
    private static let openedDateKey = "booster_openedDate"
    private static let streakKey = "booster_streak"
    private static let lastStreakDateKey = "booster_lastStreakDate"

    // Timer
    private var timer: AnyCancellable?

    // MARK: - Init

    init() {
        loadState()
        startTimer()
    }

    // MARK: - Timer

    private func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.refreshAvailability()
            }
    }

    func refreshAvailability() {
        let now = Date()
        let lastOpen = UserDefaults.standard.object(forKey: Self.lastOpenKey) as? Date

        if let lastOpen {
            let cooldown = Self.cooldownSeconds
            let nextDate = lastOpen.addingTimeInterval(cooldown)
            if now >= nextDate {
                canOpenBooster = true
                nextBoosterDate = nil
            } else {
                canOpenBooster = false
                nextBoosterDate = nextDate
            }
        } else {
            // Never opened - available immediately
            canOpenBooster = true
            nextBoosterDate = nil
        }

        // Reset daily count if new day
        let today = todayString()
        let lastDate = UserDefaults.standard.string(forKey: Self.openedDateKey) ?? ""
        if lastDate != today {
            boostersOpenedToday = 0
        }
    }

    var timeRemaining: TimeInterval {
        guard let next = nextBoosterDate else { return 0 }
        return max(0, next.timeIntervalSinceNow)
    }

    var formattedTimeRemaining: String {
        let total = Int(timeRemaining)
        let hours = total / 3600
        let minutes = (total % 3600) / 60
        let seconds = total % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    // MARK: - Open Booster

    func openBooster(collectionManager: CardCollectionManager) -> [BoosterCard] {
        guard canOpenBooster else { return [] }

        var cards: [BoosterCard] = []

        // Build card pool: all oracle + quantum + rune cards
        var pool: [(CollectibleDeck, Int)] = []
        for n in 1...CollectibleDeck.oracle.totalCards {
            pool.append((.oracle, n))
        }
        for n in 1...CollectibleDeck.quantum.totalCards {
            pool.append((.quantum, n))
        }
        for n in 1...CollectibleDeck.rune.totalCards {
            pool.append((.rune, n))
        }

        // Pull 5 random cards
        let shuffled = pool.shuffled()
        for i in 0..<Self.boosterSize {
            let (deck, number) = shuffled[i % shuffled.count]
            let rarity = rollRarity()
            let isNew = collectionManager.addCard(deck: deck, number: number, rarity: rarity)

            cards.append(BoosterCard(
                deck: deck,
                number: number,
                rarity: rarity,
                isNew: isNew
            ))
        }

        // Save state
        let now = Date()
        UserDefaults.standard.set(now, forKey: Self.lastOpenKey)

        let today = todayString()
        let lastDate = UserDefaults.standard.string(forKey: Self.openedDateKey) ?? ""
        if lastDate != today {
            boostersOpenedToday = 1
            UserDefaults.standard.set(today, forKey: Self.openedDateKey)
        } else {
            boostersOpenedToday += 1
        }
        UserDefaults.standard.set(boostersOpenedToday, forKey: Self.openedTodayKey)

        // Update streak
        updateStreak()

        lastBoosterCards = cards
        refreshAvailability()

        return cards
    }

    // MARK: - Sphere Booster (no cooldown impact)

    func openSphereBooster(collectionManager: CardCollectionManager) -> [BoosterCard] {
        var cards: [BoosterCard] = []

        var pool: [(CollectibleDeck, Int)] = []
        for n in 1...CollectibleDeck.oracle.totalCards {
            pool.append((.oracle, n))
        }
        for n in 1...CollectibleDeck.quantum.totalCards {
            pool.append((.quantum, n))
        }
        for n in 1...CollectibleDeck.rune.totalCards {
            pool.append((.rune, n))
        }

        let shuffled = pool.shuffled()
        for i in 0..<Self.boosterSize {
            let (deck, number) = shuffled[i % shuffled.count]
            let rarity = rollRarity()
            let isNew = collectionManager.addCard(deck: deck, number: number, rarity: rarity)
            cards.append(BoosterCard(deck: deck, number: number, rarity: rarity, isNew: isNew))
        }

        lastBoosterCards = cards
        return cards
    }

    // MARK: - Premium Extra Booster

    func hasPremiumBoosterAvailable(isPremium: Bool) -> Bool {
        guard isPremium else { return false }
        // Premium gets a second booster if they already opened one today
        return boostersOpenedToday == 1 && !canOpenBooster
    }

    func openPremiumBooster(collectionManager: CardCollectionManager) -> [BoosterCard] {
        // Temporarily enable and open
        var cards: [BoosterCard] = []

        var pool: [(CollectibleDeck, Int)] = []
        for n in 1...CollectibleDeck.oracle.totalCards {
            pool.append((.oracle, n))
        }
        for n in 1...CollectibleDeck.quantum.totalCards {
            pool.append((.quantum, n))
        }
        for n in 1...CollectibleDeck.rune.totalCards {
            pool.append((.rune, n))
        }

        let shuffled = pool.shuffled()
        for i in 0..<Self.boosterSize {
            let (deck, number) = shuffled[i % shuffled.count]
            let rarity = rollRarity()
            let isNew = collectionManager.addCard(deck: deck, number: number, rarity: rarity)
            cards.append(BoosterCard(deck: deck, number: number, rarity: rarity, isNew: isNew))
        }

        let today = todayString()
        boostersOpenedToday = 2
        UserDefaults.standard.set(today, forKey: Self.openedDateKey)
        UserDefaults.standard.set(boostersOpenedToday, forKey: Self.openedTodayKey)

        lastBoosterCards = cards
        return cards
    }

    // MARK: - Rarity Roll

    private func rollRarity() -> CardRarity {
        let roll = Double.random(in: 0..<1)
        // Streak bonus: +1% golden per streak day (max +10%)
        let goldenBonus = min(Double(streak) * 0.01, 0.10)

        if roll < CardRarity.golden.weight + goldenBonus {
            return .golden
        } else if roll < CardRarity.golden.weight + goldenBonus + CardRarity.holographic.weight {
            return .holographic
        } else if roll < CardRarity.golden.weight + goldenBonus + CardRarity.holographic.weight + CardRarity.rare.weight {
            return .rare
        } else {
            return .common
        }
    }

    // MARK: - Streak

    private func updateStreak() {
        let today = todayString()
        let lastStreakDate = UserDefaults.standard.string(forKey: Self.lastStreakDateKey) ?? ""

        if lastStreakDate == yesterday() {
            streak += 1
        } else if lastStreakDate != today {
            streak = 1
        }

        UserDefaults.standard.set(streak, forKey: Self.streakKey)
        UserDefaults.standard.set(today, forKey: Self.lastStreakDateKey)
    }

    // MARK: - Helpers

    private func loadState() {
        let today = todayString()
        let lastDate = UserDefaults.standard.string(forKey: Self.openedDateKey) ?? ""
        if lastDate == today {
            boostersOpenedToday = UserDefaults.standard.integer(forKey: Self.openedTodayKey)
        } else {
            boostersOpenedToday = 0
        }
        streak = UserDefaults.standard.integer(forKey: Self.streakKey)

        // Check if streak is broken
        let lastStreakDate = UserDefaults.standard.string(forKey: Self.lastStreakDateKey) ?? ""
        if lastStreakDate != today && lastStreakDate != yesterday() {
            streak = 0
            UserDefaults.standard.set(0, forKey: Self.streakKey)
        }

        refreshAvailability()
    }

    private func todayString() -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: Date())
    }

    private func yesterday() -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date())
    }
}
