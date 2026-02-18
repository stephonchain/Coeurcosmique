import Foundation

// MARK: - Daily Card Info (any deck)

enum DailyCardInfo {
    case tarot(TarotCard, isReversed: Bool)
    case oracle(OracleCard)
    case quantumOracle(QuantumOracleCard)

    var name: String {
        switch self {
        case .tarot(let card, _): return card.name
        case .oracle(let card): return card.name
        case .quantumOracle(let card): return card.name
        }
    }

    var message: String {
        switch self {
        case .tarot(let card, let isReversed):
            return isReversed ? card.reversedMeaning : card.uprightMeaning
        case .oracle(let card):
            return card.message
        case .quantumOracle(let card):
            return card.messageProfond
        }
    }

    var keywords: [String] {
        switch self {
        case .tarot(let card, _): return card.keywords
        case .oracle(let card): return card.keywords
        case .quantumOracle(let card): return card.essence
        }
    }

    var fullScreenContent: FullScreenCardView.CardContent {
        switch self {
        case .tarot(let card, let isReversed):
            return .tarot(card, isReversed: isReversed)
        case .oracle(let card):
            return .oracle(card)
        case .quantumOracle(let card):
            return .quantumOracle(card)
        }
    }
}

// MARK: - Daily Card Store

struct DailyCardStore {
    private enum Keys {
        static let lastDrawDate = "daily_draw_date"
        static let lastCardName = "daily_card_name"
        static let lastCardIsReversed = "daily_card_is_reversed"
        static let lastCardDeckType = "daily_card_deck_type"
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func readTodayCard(
        tarotDeck: [TarotCard],
        oracleDeck: [OracleCard],
        quantumDeck: [QuantumOracleCard]
    ) -> DailyCardInfo? {
        let calendar = Calendar.current
        guard
            let date = defaults.object(forKey: Keys.lastDrawDate) as? Date,
            calendar.isDateInToday(date),
            let name = defaults.string(forKey: Keys.lastCardName),
            let deckType = defaults.string(forKey: Keys.lastCardDeckType)
        else {
            return nil
        }

        switch deckType {
        case "tarot":
            guard let card = tarotDeck.first(where: { $0.name == name }) else { return nil }
            let isReversed = defaults.bool(forKey: Keys.lastCardIsReversed)
            return .tarot(card, isReversed: isReversed)
        case "oracle":
            guard let card = oracleDeck.first(where: { $0.name == name }) else { return nil }
            return .oracle(card)
        case "quantum":
            guard let card = quantumDeck.first(where: { $0.name == name }) else { return nil }
            return .quantumOracle(card)
        default:
            return nil
        }
    }

    func saveTodayCard(_ info: DailyCardInfo, now: Date = Date()) {
        defaults.set(now, forKey: Keys.lastDrawDate)
        defaults.set(info.name, forKey: Keys.lastCardName)

        switch info {
        case .tarot(_, let isReversed):
            defaults.set("tarot", forKey: Keys.lastCardDeckType)
            defaults.set(isReversed, forKey: Keys.lastCardIsReversed)
        case .oracle:
            defaults.set("oracle", forKey: Keys.lastCardDeckType)
            defaults.set(false, forKey: Keys.lastCardIsReversed)
        case .quantumOracle:
            defaults.set("quantum", forKey: Keys.lastCardDeckType)
            defaults.set(false, forKey: Keys.lastCardIsReversed)
        }
    }
}
