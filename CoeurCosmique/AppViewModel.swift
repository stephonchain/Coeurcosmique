import SwiftUI

enum AppTab: String, CaseIterable {
    case home
    case draw
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

    // MARK: - Dependencies

    let deck: [TarotCard] = TarotDeck.allCards
    private let engine = TarotReadingEngine()
    private let dailyStore = DailyCardStore()
    private let historyStore = ReadingHistoryStore()

    private static let drawCountKey = "dailyDrawCount"
    private static let drawDateKey = "lastDrawDate"

    static let freeDailyDrawLimit = 1
    static let freeJournalLimit = 3

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
}
