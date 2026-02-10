import Foundation

public struct ReadingHistoryEntry: Identifiable, Equatable, Codable {
    public let id: UUID
    public let createdAt: Date
    public let spread: TarotSpreadType
    public let question: String
    public let cardNames: [String]

    public init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        spread: TarotSpreadType,
        question: String,
        cardNames: [String]
    ) {
        self.id = id
        self.createdAt = createdAt
        self.spread = spread
        self.question = question
        self.cardNames = cardNames
    }
}

public struct ReadingHistoryStore {
    private enum Keys {
        static let history = "tarot_reading_history"
    }

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    public func load() -> [ReadingHistoryEntry] {
        guard let data = defaults.data(forKey: Keys.history),
              let entries = try? decoder.decode([ReadingHistoryEntry].self, from: data) else {
            return []
        }
        return entries.sorted { $0.createdAt > $1.createdAt }
    }

    public func save(_ entries: [ReadingHistoryEntry]) {
        guard let data = try? encoder.encode(entries) else { return }
        defaults.set(data, forKey: Keys.history)
    }

    public func append(_ entry: ReadingHistoryEntry, maxCount: Int = 100) {
        var entries = load()
        entries.insert(entry, at: 0)
        if entries.count > maxCount {
            entries = Array(entries.prefix(maxCount))
        }
        save(entries)
    }
}
