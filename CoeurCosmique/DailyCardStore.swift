import Foundation

struct DailyCardStore {
    private enum Keys {
        static let lastDrawDate = "daily_draw_date"
        static let lastCardName = "daily_card_name"
        static let lastCardIsReversed = "daily_card_is_reversed"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func readTodayCard(deck: [TarotCard]) -> DrawnCard? {
        let calendar = Calendar.current
        guard
            let date = defaults.object(forKey: Keys.lastDrawDate) as? Date,
            calendar.isDateInToday(date),
            let name = defaults.string(forKey: Keys.lastCardName),
            let card = deck.first(where: { $0.name == name })
        else {
            return nil
        }

        let isReversed = defaults.bool(forKey: Keys.lastCardIsReversed)
        return DrawnCard(card: card, isReversed: isReversed)
    }

    func saveTodayCard(_ card: DrawnCard, deck: [TarotCard], now: Date = Date()) {
        guard let resolved = card.resolve(from: deck) else { return }
        defaults.set(now, forKey: Keys.lastDrawDate)
        defaults.set(resolved.name, forKey: Keys.lastCardName)
        defaults.set(card.isReversed, forKey: Keys.lastCardIsReversed)
    }
}
