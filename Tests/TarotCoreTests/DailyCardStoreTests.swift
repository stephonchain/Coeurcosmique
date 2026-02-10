import XCTest
@testable import TarotCore

final class DailyCardStoreTests: XCTestCase {
    func testSaveAndReadTodayCard() {
        let defaults = UserDefaults(suiteName: "DailyCardStoreTests")!
        defaults.removePersistentDomain(forName: "DailyCardStoreTests")

        let store = DailyCardStore(defaults: defaults)
        let card = DrawnCard(card: TarotDeck.riderWaiteLite[0], isReversed: true)

        store.saveTodayCard(card)
        let loaded = store.readTodayCard(deck: TarotDeck.riderWaiteLite)

        XCTAssertEqual(loaded?.card.name, card.card.name)
        XCTAssertEqual(loaded?.isReversed, card.isReversed)
    }
}
