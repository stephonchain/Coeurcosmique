import Foundation
import TarotCore

@MainActor
final class TarotHomeViewModel: ObservableObject {
    @Published var selectedSpread: TarotSpreadType = .dailyGuidance
    @Published var question: String = ""
    @Published var currentReading: TarotReading?
    @Published var history: [ReadingHistoryEntry] = []

    private let engine = TarotReadingEngine()
    private let dailyStore = DailyCardStore()
    private let historyStore = ReadingHistoryStore()

    init() {
        history = historyStore.load()
    }

    func loadDailyCardIfNeeded() {
        guard selectedSpread == .dailyGuidance else { return }
        guard currentReading == nil else { return }

        if let dailyCard = dailyStore.readTodayCard(deck: TarotDeck.riderWaiteFR) {
            currentReading = TarotReading(spread: .dailyGuidance, cards: [dailyCard])
        }
    }

    func drawCards() {
        let trimmedQuestion = question.trimmingCharacters(in: .whitespacesAndNewlines)
        let reading = engine.draw(
            spread: selectedSpread,
            question: trimmedQuestion.isEmpty ? nil : trimmedQuestion
        )
        currentReading = reading

        if selectedSpread == .dailyGuidance, let card = reading.cards.first {
            dailyStore.saveTodayCard(card)
        }

        historyStore.append(
            ReadingHistoryEntry(
                spread: selectedSpread,
                question: trimmedQuestion.isEmpty ? "Sans question" : trimmedQuestion,
                cardNames: reading.cards.map { $0.card.name }
            )
        )
        history = historyStore.load()
    }
}
