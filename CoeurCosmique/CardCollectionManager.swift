import SwiftUI

@MainActor
final class CardCollectionManager: ObservableObject {
    static let shared = CardCollectionManager()

    // MARK: - Published State

    /// Cards actually pulled from boosters or bought via oracle unlock
    @Published private(set) var pulledCollection: [String: CollectedCardEntry] = [:]

    /// Whether user currently has premium (set externally)
    @Published var isPremium: Bool = false {
        didSet { objectWillChange.send() }
    }

    // MARK: - Storage

    private static let storageKey = "cardCollection_v1"

    // MARK: - Init

    init() {
        load()
    }

    // MARK: - Effective Collection (pulled + premium bonus)

    /// The full effective collection dictionary (for display in Collection grid)
    var collection: [String: CollectedCardEntry] {
        if isPremium {
            // Merge pulled cards with all normal cards from premium
            var effective = pulledCollection
            for deck in CollectibleDeck.allCases {
                for n in 1...deck.totalCards {
                    let key = "\(deck.rawValue)_\(n)"
                    if effective[key] == nil {
                        // Premium-granted card (not actually pulled)
                        effective[key] = CollectedCardEntry(
                            cardID: CollectibleCardID(deck: deck, number: n),
                            rarity: .common,
                            obtainedAt: Date(),
                            count: 1
                        )
                    }
                }
            }
            return effective
        } else {
            return pulledCollection
        }
    }

    // MARK: - Collection Queries

    func owns(deck: CollectibleDeck, number: Int) -> Bool {
        // Premium unlocks all normal cards
        if isPremium { return true }
        let key = "\(deck.rawValue)_\(number)"
        return pulledCollection[key] != nil
    }

    /// Check ownership based on pulled cards only (ignoring premium status)
    func ownsPulled(deck: CollectibleDeck, number: Int) -> Bool {
        let key = "\(deck.rawValue)_\(number)"
        return pulledCollection[key] != nil
    }

    func ownsGolden(deck: CollectibleDeck, number: Int) -> Bool {
        let key = "\(deck.rawValue)_\(number)_golden"
        return pulledCollection[key] != nil
    }

    func bestRarity(deck: CollectibleDeck, number: Int) -> CardRarity? {
        if ownsGolden(deck: deck, number: number) { return .golden }
        let key = "\(deck.rawValue)_\(number)"
        if let entry = pulledCollection[key] {
            return entry.rarity
        }
        if isPremium { return .common }
        return nil
    }

    func ownedCount(deck: CollectibleDeck) -> Int {
        if isPremium { return deck.totalCards }
        return (1...deck.totalCards).filter { ownsPulled(deck: deck, number: $0) }.count
    }

    /// Count of cards actually pulled (not premium-granted)
    func pulledCount(deck: CollectibleDeck) -> Int {
        (1...deck.totalCards).filter { ownsPulled(deck: deck, number: $0) }.count
    }

    func totalOwned() -> Int {
        CollectibleDeck.allCases.reduce(0) { $0 + ownedCount(deck: $1) }
    }

    func totalPulled() -> Int {
        CollectibleDeck.allCases.reduce(0) { $0 + pulledCount(deck: $1) }
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

    /// Check if deck is complete from pulled cards only (for permanent unlock)
    func hasCompletePulledDeck(_ deck: CollectibleDeck) -> Bool {
        pulledCount(deck: deck) == deck.totalCards
    }

    func duplicateCount(deck: CollectibleDeck, number: Int) -> Int {
        let key = "\(deck.rawValue)_\(number)"
        return max(0, (pulledCollection[key]?.count ?? 0) - 1)
    }

    // MARK: - Add Cards (from boosters/purchases - permanent)

    @discardableResult
    func addCard(deck: CollectibleDeck, number: Int, rarity: CardRarity) -> Bool {
        let isGolden = rarity == .golden
        let baseKey = "\(deck.rawValue)_\(number)"
        let key = isGolden ? "\(baseKey)_golden" : baseKey
        let isNew: Bool

        if var existing = pulledCollection[key] {
            existing.count += 1
            pulledCollection[key] = existing
            isNew = false
        } else {
            let entry = CollectedCardEntry(
                cardID: CollectibleCardID(deck: deck, number: number),
                rarity: rarity,
                obtainedAt: Date(),
                count: 1
            )
            pulledCollection[key] = entry

            // Also ensure base card exists for golden
            if isGolden && pulledCollection[baseKey] == nil {
                let baseEntry = CollectedCardEntry(
                    cardID: CollectibleCardID(deck: deck, number: number),
                    rarity: .common,
                    obtainedAt: Date(),
                    count: 1
                )
                pulledCollection[baseKey] = baseEntry
            }
            isNew = true
        }

        save()
        return isNew
    }

    // MARK: - Persistence

    private func save() {
        if let data = try? JSONEncoder().encode(pulledCollection) {
            UserDefaults.standard.set(data, forKey: Self.storageKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: Self.storageKey),
              let decoded = try? JSONDecoder().decode([String: CollectedCardEntry].self, from: data)
        else { return }
        pulledCollection = decoded
    }

    // MARK: - Debug

    func resetCollection() {
        pulledCollection = [:]
        save()
    }
}
