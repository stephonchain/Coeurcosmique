import Foundation
import SwiftUI

// MARK: - Rune Aett (Family)

enum RuneAett: String, CaseIterable, Codable {
    case freyja
    case heimdall
    case tyr

    var title: String {
        switch self {
        case .freyja: return "L'Aett de Freyja"
        case .heimdall: return "L'Aett de Heimdall"
        case .tyr: return "L'Aett de Tyr"
        }
    }

    var subtitle: String {
        switch self {
        case .freyja: return "La Création de la Matière"
        case .heimdall: return "Les Forces du Changement"
        case .tyr: return "La Synthèse Spirituelle"
        }
    }

    var cosmicTheme: String {
        switch self {
        case .freyja: return "Le Big Bang"
        case .heimdall: return "L'Évolution"
        case .tyr: return "L'Humanité Cosmique"
        }
    }

    var icon: String {
        switch self {
        case .freyja: return "flame.fill"
        case .heimdall: return "tornado"
        case .tyr: return "star.fill"
        }
    }

    var color: Color {
        switch self {
        case .freyja: return .cosmicGold
        case .heimdall: return .cosmicPurple
        case .tyr: return .cosmicRose
        }
    }
}

// MARK: - Rune Card

struct RuneCard: Equatable, Identifiable, Codable, Hashable {
    let id: UUID
    let number: Int
    let name: String
    let letter: String
    let aett: RuneAett
    let conceptTraditionnel: String
    let visionCosmique: String
    let visionCosmiqueDescription: String
    let message: String
    let imageName: String

    init(
        id: UUID = UUID(),
        number: Int,
        name: String,
        letter: String,
        aett: RuneAett,
        conceptTraditionnel: String,
        visionCosmique: String,
        visionCosmiqueDescription: String,
        message: String,
        imageName: String
    ) {
        self.id = id
        self.number = number
        self.name = name
        self.letter = letter
        self.aett = aett
        self.conceptTraditionnel = conceptTraditionnel
        self.visionCosmique = visionCosmique
        self.visionCosmiqueDescription = visionCosmiqueDescription
        self.message = message
        self.imageName = imageName
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Drawn Rune Card

struct DrawnRuneCard: Equatable, Identifiable, Codable, Hashable {
    let id: UUID
    let cardID: UUID
    let cardNumber: Int

    init(card: RuneCard) {
        self.id = UUID()
        self.cardID = card.id
        self.cardNumber = card.number
    }

    func resolve(from deck: [RuneCard]) -> RuneCard? {
        deck.first { $0.id == cardID } ?? deck.first { $0.number == cardNumber }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Rune Spread Types

enum RuneSpreadType: String, CaseIterable, Codable, Identifiable {
    case pulsar
    case ceintureOrion
    case bouclierAlgiz
    case croixGalactique

    var id: String { rawValue }

    var cardCount: Int {
        switch self {
        case .pulsar: return 1
        case .ceintureOrion: return 3
        case .bouclierAlgiz: return 4
        case .croixGalactique: return 5
        }
    }

    var title: String {
        switch self {
        case .pulsar: return "Le Pulsar"
        case .ceintureOrion: return "La Ceinture d'Orion"
        case .bouclierAlgiz: return "Le Bouclier d'Algiz"
        case .croixGalactique: return "La Croix Galactique"
        }
    }

    var subtitle: String {
        switch self {
        case .pulsar: return "Réponse immédiate, guidance du jour"
        case .ceintureOrion: return "Comprends l'évolution d'une situation"
        case .bouclierAlgiz: return "Conseil d'action face à un blocage"
        case .croixGalactique: return "Vue d'ensemble d'un problème complexe"
        }
    }

    var labels: [String] {
        switch self {
        case .pulsar:
            return ["Fréquence du Jour"]
        case .ceintureOrion:
            return ["L'Origine", "Le Vortex", "La Destination"]
        case .bouclierAlgiz:
            return ["Le Défi", "L'Allié", "L'Action Juste", "Le Résultat"]
        case .croixGalactique:
            return ["Le Cœur", "L'Ouest (Passé)", "L'Est (Obstacles/Aides)", "Le Sud (Ressources)", "Le Nord (Potentiel)"]
        }
    }

    var icon: String {
        switch self {
        case .pulsar: return "dot.radiowaves.left.and.right"
        case .ceintureOrion: return "star.leadinghalf.filled"
        case .bouclierAlgiz: return "shield.fill"
        case .croixGalactique: return "plus.circle.fill"
        }
    }

    var description: String {
        switch self {
        case .pulsar:
            return "Tire une rune pour capter la fréquence dominante du jour ou obtenir une réponse directe"
        case .ceintureOrion:
            return "Trois runes alignées pour comprendre l'origine, le présent et la destination d'une situation"
        case .bouclierAlgiz:
            return "Quatre runes en losange pour un conseil d'action quand tu te sens bloqué ou attaqué"
        case .croixGalactique:
            return "Cinq runes en croix pour une vue d'ensemble complète d'un problème complexe"
        }
    }
}

// MARK: - Rune Reading

struct RuneReading: Equatable, Identifiable, Codable {
    let id: UUID
    let spread: RuneSpreadType
    let cards: [DrawnRuneCard]
    let generatedAt: Date
    let question: String?

    init(
        id: UUID = UUID(),
        spread: RuneSpreadType,
        cards: [DrawnRuneCard],
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
