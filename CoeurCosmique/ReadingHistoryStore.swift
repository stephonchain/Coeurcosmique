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

// MARK: - Oracle Reading History Entry

struct OracleReadingHistoryEntry: Identifiable, Equatable, Codable {
    let id: UUID
    let createdAt: Date
    let spread: OracleSpreadType
    let question: String
    let cardNames: [String]

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        spread: OracleSpreadType,
        question: String,
        cardNames: [String]
    ) {
        self.id = id
        self.createdAt = createdAt
        self.spread = spread
        self.question = question
        self.cardNames = cardNames
    }

    init(from reading: OracleReading, deck: [OracleCard]) {
        self.id = UUID()
        self.createdAt = reading.generatedAt
        self.spread = reading.spread
        self.question = reading.question ?? ""
        self.cardNames = reading.cards.compactMap { $0.resolve(from: deck)?.name }
    }
}

// MARK: - Quantum Oracle Reading History Entry

struct QuantumOracleReadingHistoryEntry: Identifiable, Equatable, Codable {
    let id: UUID
    let createdAt: Date
    let spread: QuantumSpreadType
    let question: String
    let cardNames: [String]

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        spread: QuantumSpreadType,
        question: String,
        cardNames: [String]
    ) {
        self.id = id
        self.createdAt = createdAt
        self.spread = spread
        self.question = question
        self.cardNames = cardNames
    }

    init(from reading: QuantumOracleReading, deck: [QuantumOracleCard]) {
        self.id = UUID()
        self.createdAt = reading.generatedAt
        self.spread = reading.spread
        self.question = reading.question ?? ""
        self.cardNames = reading.cards.compactMap { $0.resolve(from: deck)?.name }
    }
}

// MARK: - History Store

struct ReadingHistoryStore {
    private enum Keys {
        static let history = "tarot_reading_history"
        static let oracleHistory = "oracle_reading_history"
        static let quantumHistory = "quantum_reading_history"
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

    // MARK: - Oracle History

    func loadOracle() -> [OracleReadingHistoryEntry] {
        guard let data = defaults.data(forKey: Keys.oracleHistory),
              let entries = try? decoder.decode([OracleReadingHistoryEntry].self, from: data) else {
            return []
        }
        return entries.sorted { $0.createdAt > $1.createdAt }
    }

    func saveOracle(_ entries: [OracleReadingHistoryEntry]) {
        guard let data = try? encoder.encode(entries) else { return }
        defaults.set(data, forKey: Keys.oracleHistory)
    }

    func appendOracle(_ entry: OracleReadingHistoryEntry, maxCount: Int = 100) {
        var entries = loadOracle()
        entries.insert(entry, at: 0)
        if entries.count > maxCount {
            entries = Array(entries.prefix(maxCount))
        }
        saveOracle(entries)
    }

    // MARK: - Quantum Oracle History

    func loadQuantum() -> [QuantumOracleReadingHistoryEntry] {
        guard let data = defaults.data(forKey: Keys.quantumHistory),
              let entries = try? decoder.decode([QuantumOracleReadingHistoryEntry].self, from: data) else {
            return []
        }
        return entries.sorted { $0.createdAt > $1.createdAt }
    }

    func saveQuantum(_ entries: [QuantumOracleReadingHistoryEntry]) {
        guard let data = try? encoder.encode(entries) else { return }
        defaults.set(data, forKey: Keys.quantumHistory)
    }

    func appendQuantum(_ entry: QuantumOracleReadingHistoryEntry, maxCount: Int = 100) {
        var entries = loadQuantum()
        entries.insert(entry, at: 0)
        if entries.count > maxCount {
            entries = Array(entries.prefix(maxCount))
        }
        saveQuantum(entries)
    }
}
