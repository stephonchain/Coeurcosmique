import Foundation

public enum TarotSpreadType: String, CaseIterable, Codable {
    case dailyGuidance
    case pastPresentFuture
    case relationship
    case situationActionOutcome

    public var cardCount: Int {
        switch self {
        case .dailyGuidance:
            return 1
        case .pastPresentFuture:
            return 3
        case .relationship:
            return 3
        case .situationActionOutcome:
            return 3
        }
    }

    public var title: String {
        switch self {
        case .dailyGuidance: return "Carte du jour"
        case .pastPresentFuture: return "Passé · Présent · Futur"
        case .relationship: return "Relationnel"
        case .situationActionOutcome: return "Situation · Action · Résultat"
        }
    }

    public var labels: [String] {
        switch self {
        case .dailyGuidance:
            return ["Message du jour"]
        case .pastPresentFuture:
            return ["Passé", "Présent", "Futur"]
        case .relationship:
            return ["Toi", "L'autre", "Lien"]
        case .situationActionOutcome:
            return ["Situation", "Action", "Résultat"]
        }
    }
}

public struct TarotReading: Equatable {
    public let spread: TarotSpreadType
    public let cards: [DrawnCard]
    public let generatedAt: Date
    public let question: String?

    public init(spread: TarotSpreadType, cards: [DrawnCard], generatedAt: Date = Date(), question: String? = nil) {
        self.spread = spread
        self.cards = cards
        self.generatedAt = generatedAt
        self.question = question
    }
}
