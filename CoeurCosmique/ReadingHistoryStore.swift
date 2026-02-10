import Foundation

struct ReadingHistoryEntry: Identifiable, Equatable, Codable {
    let id: UUID
    let createdAt: Date
    let spread: TarotSpreadType
    let question: String
    let cardNames: [String]
    let cardReversals: [Bool]

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        spread: TarotSpreadType,
        question: String,
        cardNames: [String],
        cardReversals: [Bool] = []
    ) {
        self.id = id
        self.createdAt = createdAt
        self.spread = spread
        self.question = question
        self.cardNames = cardNames
        self.cardReversals = cardReversals
    }

    init(from reading: TarotReading, deck: [TarotCard]) {
        self.id = UUID()
        self.createdAt = reading.generatedAt
        self.spread = reading.spread
        self.question = reading.question ?? ""
        self.cardNames = reading.cards.compactMap { $0.resolve(from: deck)?.name }
        self.cardReversals = reading.cards.map(\.isReversed)
    }
}

struct ReadingHistoryStore {
    private enum Keys {
        static let history = "tarot_reading_history"
    }

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load() -> [ReadingHistoryEntry] {
        guard let data = defaults.data(forKey: Keys.history),
              let entries = try? decoder.decode([ReadingHistoryEntry].self, from: data) else {
            return []
        }
        return entries.sorted { $0.createdAt > $1.createdAt }
    }

    func save(_ entries: [ReadingHistoryEntry]) {
        guard let data = try? encoder.encode(entries) else { return }
        defaults.set(data, forKey: Keys.history)
    }

    func append(_ entry: ReadingHistoryEntry, maxCount: Int = 100) {
        var entries = load()
        entries.insert(entry, at: 0)
        if entries.count > maxCount {
            entries = Array(entries.prefix(maxCount))
        }
        save(entries)
    }
}
