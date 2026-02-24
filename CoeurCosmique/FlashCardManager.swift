import SwiftUI

// MARK: - Flash Card Manager (Spaced Repetition System)

@MainActor
final class FlashCardManager: ObservableObject {
    static let shared = FlashCardManager()

    // SRS intervals in days: J0, J1, J3, J7, J31
    static let srsIntervals: [Int] = [0, 1, 3, 7, 31]
    static let maxLevel = 5 // level 5 = memorized (passed J31)

    private static let storageKey = "flashcard_entries"

    @Published private(set) var entries: [String: FlashCardEntry] = [:]

    init() {
        loadEntries()
    }

    // MARK: - Card Key

    static func cardKey(deck: CollectibleDeck, number: Int) -> String {
        "\(deck.rawValue)_\(number)"
    }

    // MARK: - Query

    func entry(deck: CollectibleDeck, number: Int) -> FlashCardEntry? {
        entries[Self.cardKey(deck: deck, number: number)]
    }

    func level(deck: CollectibleDeck, number: Int) -> Int {
        entry(deck: deck, number: number)?.level ?? 0
    }

    func isMemorized(deck: CollectibleDeck, number: Int) -> Bool {
        level(deck: deck, number: number) >= Self.maxLevel
    }

    func memorizedCount(deck: CollectibleDeck) -> Int {
        let totalCards = deck.totalCards
        var count = 0
        for n in 1...totalCards {
            if isMemorized(deck: deck, number: n) { count += 1 }
        }
        return count
    }

    func isDeckMastered(deck: CollectibleDeck) -> Bool {
        memorizedCount(deck: deck) == deck.totalCards
    }

    /// Cards due for review now (level < maxLevel AND nextReviewDate <= now)
    func cardsDueForReview(deck: CollectibleDeck) -> [(Int, Int)] {
        // Returns (cardNumber, currentLevel) pairs
        let now = Date()
        var due: [(Int, Int)] = []

        for n in 1...deck.totalCards {
            let key = Self.cardKey(deck: deck, number: n)
            if let entry = entries[key] {
                if entry.level < Self.maxLevel && entry.nextReviewDate <= now {
                    due.append((n, entry.level))
                }
            } else {
                // Never seen → level 0, due now
                due.append((n, 0))
            }
        }

        return due
    }

    /// Total cards in progress (started but not memorized)
    func inProgressCount(deck: CollectibleDeck) -> Int {
        var count = 0
        for n in 1...deck.totalCards {
            let key = Self.cardKey(deck: deck, number: n)
            if let entry = entries[key], entry.level > 0 && entry.level < Self.maxLevel {
                count += 1
            }
        }
        return count
    }

    // MARK: - Actions

    /// Mark a card as correctly answered → level up
    func markCorrect(deck: CollectibleDeck, number: Int) {
        let key = Self.cardKey(deck: deck, number: number)
        var entry = entries[key] ?? FlashCardEntry(
            deckType: deck.rawValue,
            cardNumber: number,
            level: 0,
            nextReviewDate: Date()
        )

        entry.level = min(entry.level + 1, Self.maxLevel)

        if entry.level < Self.maxLevel {
            let daysUntilNext = Self.srsIntervals[min(entry.level, Self.srsIntervals.count - 1)]
            entry.nextReviewDate = Calendar.current.date(byAdding: .day, value: daysUntilNext, to: Date()) ?? Date()
        } else {
            // Memorized! Set far future date
            entry.nextReviewDate = Date.distantFuture
        }

        entries[key] = entry
        saveEntries()
    }

    /// Mark a card as incorrectly answered → reset to level 0
    func markWrong(deck: CollectibleDeck, number: Int) {
        let key = Self.cardKey(deck: deck, number: number)
        var entry = entries[key] ?? FlashCardEntry(
            deckType: deck.rawValue,
            cardNumber: number,
            level: 0,
            nextReviewDate: Date()
        )

        entry.level = 0
        entry.nextReviewDate = Date() // Due again now

        entries[key] = entry
        saveEntries()
    }

    // MARK: - Persistence

    private func loadEntries() {
        guard let data = UserDefaults.standard.data(forKey: Self.storageKey),
              let decoded = try? JSONDecoder().decode([String: FlashCardEntry].self, from: data) else {
            return
        }
        entries = decoded
    }

    private func saveEntries() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: Self.storageKey)
        }
    }
}

// MARK: - Flash Card Entry

struct FlashCardEntry: Codable {
    let deckType: String
    let cardNumber: Int
    var level: Int           // 0-5 (5 = memorized, passed J31)
    var nextReviewDate: Date

    var levelLabel: String {
        switch level {
        case 0: return "Nouveau"
        case 1: return "J1"
        case 2: return "J3"
        case 3: return "J7"
        case 4: return "J31"
        case 5: return "Maitrise"
        default: return "?"
        }
    }

    var levelColor: Color {
        switch level {
        case 0: return .cosmicTextSecondary
        case 1: return .cyan
        case 2: return .blue
        case 3: return .cosmicPurple
        case 4: return .cosmicGold
        case 5: return .green
        default: return .cosmicTextSecondary
        }
    }
}

// MARK: - Flash Card Quiz Item

struct FlashQuizItem {
    let deck: CollectibleDeck
    let number: Int
    let name: String
    let imageName: String
    let description: String
    let keywords: [String]
    let currentLevel: Int

    /// Build quiz items for a specific deck
    static func buildAll(deck: CollectibleDeck) -> [FlashQuizItem] {
        switch deck {
        case .oracle:
            return OracleDeck.allCards.map { card in
                FlashQuizItem(
                    deck: .oracle,
                    number: card.number,
                    name: card.name,
                    imageName: card.imageName,
                    description: card.message,
                    keywords: card.keywords,
                    currentLevel: 0
                )
            }
        case .quantum:
            return QuantumOracleDeck.allCards.map { card in
                FlashQuizItem(
                    deck: .quantum,
                    number: card.number,
                    name: card.name,
                    imageName: card.imageName,
                    description: card.messageProfond,
                    keywords: card.essence,
                    currentLevel: 0
                )
            }
        case .rune:
            return RuneDeck.allCards.map { card in
                FlashQuizItem(
                    deck: .rune,
                    number: card.number,
                    name: card.name,
                    imageName: card.imageName,
                    description: card.message,
                    keywords: [card.visionCosmique, card.conceptTraditionnel],
                    currentLevel: 0
                )
            }
        }
    }
}
