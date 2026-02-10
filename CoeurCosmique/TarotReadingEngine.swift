import Foundation

struct TarotReadingEngine {
    private let deck: [TarotCard]

    init(deck: [TarotCard] = TarotDeck.allCards) {
        self.deck = deck
    }

    func draw(spread: TarotSpreadType, question: String? = nil) -> TarotReading {
        var availableCards = deck.shuffled()
        var drawnCards: [DrawnCard] = []

        for _ in 0..<spread.cardCount {
            guard let card = availableCards.popLast() else { break }
            let isReversed = Bool.random()
            drawnCards.append(DrawnCard(card: card, isReversed: isReversed))
        }

        return TarotReading(spread: spread, cards: drawnCards, question: question)
    }
}
