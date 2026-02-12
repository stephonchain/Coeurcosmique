import SwiftUI

enum AppTab: String, CaseIterable {
    case home
    case draw
    case oracle
    case collection
    case journal
}

@MainActor
final class AppViewModel: ObservableObject {
    // MARK: - Published State

    @Published var selectedTab: AppTab = .home
    @Published var dailyCard: DrawnCard?
    @Published var currentReading: TarotReading?
    @Published var history: [ReadingHistoryEntry] = []
    @Published var todayDrawCount: Int = 0

    // Oracle state
    @Published var currentOracleReading: OracleReading?
    @Published var todayOracleDrawCount: Int = 0

    // MARK: - Dependencies

    let deck: [TarotCard] = TarotDeck.allCards
    let oracleDeck: [OracleCard] = OracleDeck.allCards
    private let engine = TarotReadingEngine()
    private let dailyStore = DailyCardStore()
    private let historyStore = ReadingHistoryStore()

    private static let drawCountKey = "dailyDrawCount"
    private static let drawDateKey = "lastDrawDate"
    private static let oracleDrawCountKey = "oracleDailyDrawCount"
    private static let oracleDrawDateKey = "oracleLastDrawDate"

    static let freeDailyDrawLimit = 1
    static let freeJournalLimit = 3
    static let freeOracleDailyLimit = 1

    // MARK: - Daily Card

    func loadDailyCard() {
        if let saved = dailyStore.readTodayCard(deck: deck) {
            dailyCard = saved
        }
    }

    func drawNewDailyCard() {
        let reading = engine.draw(spread: .dailyGuidance)
        guard let card = reading.cards.first else { return }
        dailyCard = card
        dailyStore.saveTodayCard(card, deck: deck)
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
        currentOracleReading = OracleReading(spread: spread, cards: drawnCards, question: question)
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
}
