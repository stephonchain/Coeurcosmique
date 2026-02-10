import Foundation

public struct TarotReadingEngine {
    private let deck: [TarotCard]
    private let randomSource: any RandomNumberGenerator

    public init(deck: [TarotCard] = TarotDeck.riderWaiteFR, randomSource: any RandomNumberGenerator = SystemRandomNumberGenerator()) {
        self.deck = deck
        self.randomSource = randomSource
    }

    public func draw(spread: TarotSpreadType, question: String? = nil) -> TarotReading {
        var generator = randomSource
        var availableCards = deck.shuffled(using: &generator)
        var drawnCards: [DrawnCard] = []

        for _ in 0..<spread.cardCount {
            guard let card = availableCards.popLast() else { break }
            let isReversed = Bool.random(using: &generator)
            drawnCards.append(DrawnCard(card: card, isReversed: isReversed))
        }

        return TarotReading(spread: spread, cards: drawnCards, question: question)
    }
}
