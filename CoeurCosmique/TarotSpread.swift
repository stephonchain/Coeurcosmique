import Foundation

enum TarotSpreadType: String, CaseIterable, Codable, Identifiable {
    case dailyGuidance
    case pastPresentFuture
    case relationship
    case situationActionOutcome
    case yesNo

    var id: String { rawValue }

    var cardCount: Int {
        switch self {
        case .dailyGuidance: return 1
        case .pastPresentFuture: return 3
        case .relationship: return 3
        case .situationActionOutcome: return 3
        case .yesNo: return 1
        }
    }

    var title: String {
        switch self {
        case .dailyGuidance: return "Guidance du jour"
        case .pastPresentFuture: return "Passé · Présent · Futur"
        case .relationship: return "Relationnel"
        case .situationActionOutcome: return "Situation · Action · Résultat"
        case .yesNo: return "Oui ou Non"
        }
    }

    var subtitle: String {
        switch self {
        case .dailyGuidance: return "Un message pour ta journée"
        case .pastPresentFuture: return "Comprends ton chemin"
        case .relationship: return "Éclaire ta relation"
        case .situationActionOutcome: return "Trouve ta voie d'action"
        case .yesNo: return "Une réponse claire"
        }
    }

    var labels: [String] {
        switch self {
        case .dailyGuidance: return ["Message du jour"]
        case .pastPresentFuture: return ["Passé", "Présent", "Futur"]
        case .relationship: return ["Toi", "L'autre", "Le lien"]
        case .situationActionOutcome: return ["Situation", "Action", "Résultat"]
        case .yesNo: return ["Réponse"]
        }
    }

    var icon: String {
        switch self {
        case .dailyGuidance: return "sun.max.fill"
        case .pastPresentFuture: return "clock.arrow.2.circlepath"
        case .relationship: return "heart.fill"
        case .situationActionOutcome: return "arrow.triangle.branch"
        case .yesNo: return "questionmark.circle.fill"
        }
    }
}

struct TarotReading: Equatable, Identifiable, Codable {
    let id: UUID
    let spread: TarotSpreadType
    let cards: [DrawnCard]
    let generatedAt: Date
    let question: String?

    init(
        id: UUID = UUID(),
        spread: TarotSpreadType,
        cards: [DrawnCard],
        generatedAt: Date = Date(),
        question: String? = nil
    ) {
        self.id = id
        self.spread = spread
        self.cards = cards
        self.generatedAt = generatedAt
        self.question = question
    }
}
