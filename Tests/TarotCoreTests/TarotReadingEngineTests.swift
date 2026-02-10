import XCTest
@testable import TarotCore

private struct PredictableGenerator: RandomNumberGenerator {
    private var state: UInt64 = 42

    mutating func next() -> UInt64 {
        state = state &* 6364136223846793005 &+ 1
        return state
    }
}

final class TarotReadingEngineTests: XCTestCase {
    func testDeckContains78Cards() {
        XCTAssertEqual(TarotDeck.riderWaiteFR.count, 78)
    }

    func testPastPresentFutureReturnsThreeCards() {
        let engine = TarotReadingEngine(randomSource: PredictableGenerator())

        let reading = engine.draw(spread: .pastPresentFuture)

        XCTAssertEqual(reading.cards.count, 3)
    }

    func testDailyGuidanceReturnsOneCard() {
        let engine = TarotReadingEngine(randomSource: PredictableGenerator())

        let reading = engine.draw(spread: .dailyGuidance)

        XCTAssertEqual(reading.cards.count, 1)
    }

    func testDrawDoesNotDuplicateCardsInSameReading() {
        let engine = TarotReadingEngine(randomSource: PredictableGenerator())

        let reading = engine.draw(spread: .relationship)
        let uniqueNames = Set(reading.cards.map { $0.card.name })

        XCTAssertEqual(uniqueNames.count, reading.cards.count)
    }

    func testQuestionIsPersistedInReading() {
        let engine = TarotReadingEngine(randomSource: PredictableGenerator())

        let reading = engine.draw(spread: .situationActionOutcome, question: "Comment avancer ?")

        XCTAssertEqual(reading.question, "Comment avancer ?")
    }
}
