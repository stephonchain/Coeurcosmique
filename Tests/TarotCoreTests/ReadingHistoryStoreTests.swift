import XCTest
@testable import TarotCore

final class ReadingHistoryStoreTests: XCTestCase {
    func testAppendThenLoadReturnsEntry() {
        let defaults = UserDefaults(suiteName: "ReadingHistoryStoreTests")!
        defaults.removePersistentDomain(forName: "ReadingHistoryStoreTests")

        let store = ReadingHistoryStore(defaults: defaults)
        let entry = ReadingHistoryEntry(
            spread: .dailyGuidance,
            question: "Message du jour",
            cardNames: ["Le Mat"]
        )

        store.append(entry)
        let entries = store.load()

        XCTAssertEqual(entries.count, 1)
        XCTAssertEqual(entries.first?.question, "Message du jour")
        XCTAssertEqual(entries.first?.cardNames, ["Le Mat"])
    }
}
