import SwiftUI

enum AppTab: String, CaseIterable {
    case home
    case oracle
    case collection
    case boutique
    case journal
}

@MainActor
final class AppViewModel: ObservableObject {
    // MARK: - Published State

    @Published var selectedTab: AppTab = .home
    @Published var dailyCard: DailyCardInfo?
    @Published var currentReading: TarotReading?
    @Published var history: [ReadingHistoryEntry] = []
    @Published var oracleHistory: [OracleReadingHistoryEntry] = []
    @Published var quantumHistory: [QuantumOracleReadingHistoryEntry] = []
    @Published var todayDrawCount: Int = 0

    // Oracle state
    @Published var currentOracleReading: OracleReading?
    @Published var todayOracleDrawCount: Int = 0
    
    // Quantum Oracle state
    @Published var currentQuantumReading: QuantumOracleReading?
    @Published var todayQuantumDrawCount: Int = 0

    // Rune state
    @Published var currentRuneReading: RuneReading?
    @Published var todayRuneDrawCount: Int = 0

    // MARK: - Dependencies

    let deck: [TarotCard] = TarotDeck.allCards
    let oracleDeck: [OracleCard] = OracleDeck.allCards
    let quantumOracleDeck: [QuantumOracleCard] = QuantumOracleDeck.allCards
    private let engine = TarotReadingEngine()
    private let dailyStore = DailyCardStore()
    private let historyStore = ReadingHistoryStore()

    private static let drawCountKey = "dailyDrawCount"
    private static let drawDateKey = "lastDrawDate"
    private static let oracleDrawCountKey = "oracleDailyDrawCount"
    private static let oracleDrawDateKey = "oracleLastDrawDate"
    private static let quantumDrawCountKey = "quantumDailyDrawCount"
    private static let quantumDrawDateKey = "quantumLastDrawDate"
    private static let runeDrawCountKey = "runeDailyDrawCount"
    private static let runeDrawDateKey = "runeLastDrawDate"

    static let freeDailyDrawLimit = 1
    static let freeJournalLimit = 3
    static let freeOracleDailyLimit = 1

    // MARK: - Daily Card

    func loadDailyCard() {
        if let saved = dailyStore.readTodayCard(
            tarotDeck: deck,
            oracleDeck: oracleDeck,
            quantumDeck: quantumOracleDeck
        ) {
            dailyCard = saved
        }
    }

    func drawNewDailyCard() {
        let deckChoice = Int.random(in: 0..<3)
        let info: DailyCardInfo
        switch deckChoice {
        case 0:
            // Tarot
            let reading = engine.draw(spread: .dailyGuidance)
            guard let card = reading.cards.first,
                  let resolved = card.resolve(from: deck) else { return }
            info = .tarot(resolved, isReversed: card.isReversed)
        case 1:
            // Oracle
            guard let card = oracleDeck.randomElement() else { return }
            info = .oracle(card)
        default:
            // Quantum Oracle
            guard let card = quantumOracleDeck.randomElement() else { return }
            info = .quantumOracle(card)
        }
        dailyCard = info
        dailyStore.saveTodayCard(info)
    }

    // MARK: - Readings

    func performReading(spread: TarotSpreadType, question: String? = nil) {
        let reading = engine.draw(spread: spread, question: question)
        currentReading = reading

        let entry = ReadingHistoryEntry(from: reading, deck: deck)
        historyStore.append(entry)
        loadHistory()
        incrementDrawCount()
    }

    // MARK: - History

    func loadHistory() {
        history = historyStore.load()
    }

    func loadOracleHistory() {
        oracleHistory = historyStore.loadOracle()
    }

    func loadQuantumHistory() {
        quantumHistory = historyStore.loadQuantum()
    }

    // MARK: - Draw Tracking

    func loadTodayDrawCount() {
        let today = todayString
        let lastDate = UserDefaults.standard.string(forKey: Self.drawDateKey) ?? ""
        if lastDate == today {
            todayDrawCount = UserDefaults.standard.integer(forKey: Self.drawCountKey)
        } else {
            todayDrawCount = 0
        }
    }

    private func incrementDrawCount() {
        let today = todayString
        let lastDate = UserDefaults.standard.string(forKey: Self.drawDateKey) ?? ""
        if lastDate != today {
            todayDrawCount = 1
            UserDefaults.standard.set(today, forKey: Self.drawDateKey)
        } else {
            todayDrawCount += 1
        }
        UserDefaults.standard.set(todayDrawCount, forKey: Self.drawCountKey)
    }

    private var todayString: String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: Date())
    }

    // MARK: - Oracle Readings

    func performOracleReading(spread: OracleSpreadType, question: String? = nil) {
        var available = oracleDeck.shuffled()
        var drawnCards: [DrawnOracleCard] = []
        for _ in 0..<spread.cardCount {
            if let card = available.popLast() {
                drawnCards.append(DrawnOracleCard(card: card))
            }
        }
        let reading = OracleReading(spread: spread, cards: drawnCards, question: question)
        currentOracleReading = reading

        let entry = OracleReadingHistoryEntry(from: reading, deck: oracleDeck)
        historyStore.appendOracle(entry)
        loadOracleHistory()
        incrementOracleDrawCount()
    }

    // MARK: - Oracle Draw Tracking

    func loadTodayOracleDrawCount() {
        let today = todayString
        let lastDate = UserDefaults.standard.string(forKey: Self.oracleDrawDateKey) ?? ""
        if lastDate == today {
            todayOracleDrawCount = UserDefaults.standard.integer(forKey: Self.oracleDrawCountKey)
        } else {
            todayOracleDrawCount = 0
        }
    }

    private func incrementOracleDrawCount() {
        let today = todayString
        let lastDate = UserDefaults.standard.string(forKey: Self.oracleDrawDateKey) ?? ""
        if lastDate != today {
            todayOracleDrawCount = 1
            UserDefaults.standard.set(today, forKey: Self.oracleDrawDateKey)
        } else {
            todayOracleDrawCount += 1
        }
        UserDefaults.standard.set(todayOracleDrawCount, forKey: Self.oracleDrawCountKey)
    }
    
    // MARK: - Quantum Oracle Readings
    
    func performQuantumReading(spread: QuantumSpreadType, question: String? = nil) {
        var available = quantumOracleDeck.shuffled()
        var drawnCards: [DrawnQuantumOracleCard] = []
        for _ in 0..<spread.cardCount {
            if let card = available.popLast() {
                drawnCards.append(DrawnQuantumOracleCard(card: card))
            }
        }
        let reading = QuantumOracleReading(spread: spread, cards: drawnCards, question: question)
        currentQuantumReading = reading

        let entry = QuantumOracleReadingHistoryEntry(from: reading, deck: quantumOracleDeck)
        historyStore.appendQuantum(entry)
        loadQuantumHistory()
        incrementQuantumDrawCount()
    }
    
    // MARK: - Quantum Oracle Draw Tracking
    
    func loadTodayQuantumDrawCount() {
        let today = todayString
        let lastDate = UserDefaults.standard.string(forKey: Self.quantumDrawDateKey) ?? ""
        if lastDate == today {
            todayQuantumDrawCount = UserDefaults.standard.integer(forKey: Self.quantumDrawCountKey)
        } else {
            todayQuantumDrawCount = 0
        }
    }
    
    private func incrementQuantumDrawCount() {
        let today = todayString
        let lastDate = UserDefaults.standard.string(forKey: Self.quantumDrawDateKey) ?? ""
        if lastDate != today {
            todayQuantumDrawCount = 1
            UserDefaults.standard.set(today, forKey: Self.quantumDrawDateKey)
        } else {
            todayQuantumDrawCount += 1
        }
        UserDefaults.standard.set(todayQuantumDrawCount, forKey: Self.quantumDrawCountKey)
    }

    // MARK: - Rune Readings

    func performRuneReading(spread: RuneSpreadType, question: String? = nil) {
        var available = RuneDeck.allCards.shuffled()
        var drawnCards: [DrawnRuneCard] = []
        for _ in 0..<spread.cardCount {
            if let card = available.popLast() {
                drawnCards.append(DrawnRuneCard(card: card))
            }
        }
        let reading = RuneReading(spread: spread, cards: drawnCards, question: question)
        currentRuneReading = reading
        incrementRuneDrawCount()
    }

    // MARK: - Rune Draw Tracking

    func loadTodayRuneDrawCount() {
        let today = todayString
        let lastDate = UserDefaults.standard.string(forKey: Self.runeDrawDateKey) ?? ""
        if lastDate == today {
            todayRuneDrawCount = UserDefaults.standard.integer(forKey: Self.runeDrawCountKey)
        } else {
            todayRuneDrawCount = 0
        }
    }

    private func incrementRuneDrawCount() {
        let today = todayString
        let lastDate = UserDefaults.standard.string(forKey: Self.runeDrawDateKey) ?? ""
        if lastDate != today {
            todayRuneDrawCount = 1
            UserDefaults.standard.set(today, forKey: Self.runeDrawDateKey)
        } else {
            todayRuneDrawCount += 1
        }
        UserDefaults.standard.set(todayRuneDrawCount, forKey: Self.runeDrawCountKey)
    }
}
