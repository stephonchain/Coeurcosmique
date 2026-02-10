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

    // MARK: - Dependencies

    let deck: [TarotCard] = TarotDeck.allCards
    private let engine = TarotReadingEngine()
    private let dailyStore = DailyCardStore()
    private let historyStore = ReadingHistoryStore()

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
    }

    // MARK: - History

    func loadHistory() {
        history = historyStore.load()
    }
}
