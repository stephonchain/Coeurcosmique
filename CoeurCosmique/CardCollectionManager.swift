import SwiftUI

@MainActor
final class CardCollectionManager: ObservableObject {
    static let shared = CardCollectionManager()

    // MARK: - Published State

    @Published private(set) var collection: [String: CollectedCardEntry] = [:]

    // MARK: - Storage

    private static let storageKey = "cardCollection_v1"

    // MARK: - Init

    init() {
        load()
    }

    // MARK: - Collection Queries

    func owns(deck: CollectibleDeck, number: Int) -> Bool {
        let key = "\(deck.rawValue)_\(number)"
        return collection[key] != nil
    }

    func ownsGolden(deck: CollectibleDeck, number: Int) -> Bool {
        let key = "\(deck.rawValue)_\(number)_golden"
        return collection[key] != nil
    }

    func bestRarity(deck: CollectibleDeck, number: Int) -> CardRarity? {
        if ownsGolden(deck: deck, number: number) { return .golden }
        let key = "\(deck.rawValue)_\(number)"
        return collection[key]?.rarity
    }

    func ownedCount(deck: CollectibleDeck) -> Int {
        (1...deck.totalCards).filter { owns(deck: deck, number: $0) }.count
    }

    func totalOwned() -> Int {
        CollectibleDeck.allCases.reduce(0) { $0 + ownedCount(deck: $1) }
    }

    static var totalCollectible: Int {
        CollectibleDeck.allCases.reduce(0) { $0 + $1.totalCards }
    }

    func completionPercent(deck: CollectibleDeck) -> Double {
        Double(ownedCount(deck: deck)) / Double(deck.totalCards)
    }

    func hasCompleteDeck(_ deck: CollectibleDeck) -> Bool {
        ownedCount(deck: deck) == deck.totalCards
    }

    func duplicateCount(deck: CollectibleDeck, number: Int) -> Int {
        let key = "\(deck.rawValue)_\(number)"
        return max(0, (collection[key]?.count ?? 0) - 1)
    }

    // MARK: - Add Cards

    func addCard(deck: CollectibleDeck, number: Int, rarity: CardRarity) -> Bool {
        let isGolden = rarity == .golden
        let baseKey = "\(deck.rawValue)_\(number)"
        let key = isGolden ? "\(baseKey)_golden" : baseKey
        let isNew: Bool

        if var existing = collection[key] {
            existing.count += 1
            collection[key] = existing
            isNew = false
        } else {
            let entry = CollectedCardEntry(
                cardID: CollectibleCardID(deck: deck, number: number),
                rarity: rarity,
                obtainedAt: Date(),
                count: 1
            )
            collection[key] = entry

            // Also ensure base card exists for golden
            if isGolden && collection[baseKey] == nil {
                let baseEntry = CollectedCardEntry(
                    cardID: CollectibleCardID(deck: deck, number: number),
                    rarity: .common,
                    obtainedAt: Date(),
                    count: 1
                )
                collection[baseKey] = baseEntry
            }
            isNew = true
        }

        save()
        return isNew
    }

    // MARK: - Persistence

    private func save() {
        if let data = try? JSONEncoder().encode(collection) {
            UserDefaults.standard.set(data, forKey: Self.storageKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: Self.storageKey),
              let decoded = try? JSONDecoder().decode([String: CollectedCardEntry].self, from: data)
        else { return }
        collection = decoded
    }

    // MARK: - Debug

    func resetCollection() {
        collection = [:]
        save()
    }
}
