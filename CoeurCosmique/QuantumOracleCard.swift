import Foundation

// MARK: - Quantum Oracle Family

enum QuantumFamily: String, CaseIterable, Codable {
    case loisFondamentales
    case cosmologieAme
    case paradoxesTemporels
    case conscienceMulti
    case anomaliesCosmiques
    case forcesLiaison

    var title: String {
        switch self {
        case .loisFondamentales: return "Les Lois Fondamentales"
        case .cosmologieAme: return "La Cosmologie de l'Âme"
        case .paradoxesTemporels: return "Les Paradoxes Temporels"
        case .conscienceMulti: return "La Conscience Multidimensionnelle"
        case .anomaliesCosmiques: return "Les Anomalies Cosmiques"
        case .forcesLiaison: return "Les Forces de Liaison"
        }
    }

    var subtitle: String {
        switch self {
        case .loisFondamentales: return "La Structure de la Réalité"
        case .cosmologieAme: return "Les Lieux de Conscience"
        case .paradoxesTemporels: return "Le Temps et l'Espace"
        case .conscienceMulti: return "L'Être et l'Identité"
        case .anomaliesCosmiques: return "Les Défis et les Cadeaux"
        case .forcesLiaison: return "L'Amour et l'Interaction"
        }
    }

    var dominantColor: String {
        switch self {
        case .loisFondamentales: return "Bleu Roi et Or"
        case .cosmologieAme: return "Noir, Violet profond, Indigo"
        case .paradoxesTemporels: return "Argent, Gris irisé, Cyan"
        case .conscienceMulti: return "Jaune, Orange, Blanc éclatant"
        case .anomaliesCosmiques: return "Néon, Contrastes forts"
        case .forcesLiaison: return "Rose, Rouge rubis, Magenta"
        }
    }

    var icon: String {
        switch self {
        case .loisFondamentales: return "atom"
        case .cosmologieAme: return "moon.stars.fill"
        case .paradoxesTemporels: return "clock.arrow.2.circlepath"
        case .conscienceMulti: return "brain.head.profile"
        case .anomaliesCosmiques: return "bolt.fill"
        case .forcesLiaison: return "heart.fill"
        }
    }
}

// MARK: - Quantum Interpretation per card

struct QuantumInterpretation: Equatable, Codable {
    // Tirage 1 - Le Lien des Âmes (Relationnel)
    let alphaYou: String
    let betaOther: String
    let linkResult: String

    // Tirage 2 - Le Chat de Schrödinger (Décisionnel)
    let situation: String
    let actionBoxA: String
    let nonActionBoxB: String
    let collapseResult: String

    // Tirage 3 - Le Saut Quantique (Évolutif)
    let gravity: String
    let darkEnergy: String
    let horizon: String
    let wormhole: String
    let newGalaxy: String
}

// MARK: - Quantum Oracle Card

struct QuantumOracleCard: Equatable, Identifiable, Codable, Hashable {
    let id: UUID
    let number: Int
    let name: String
    let family: QuantumFamily
    let essence: [String]
    let messageProfond: String
    let imageName: String
    let interpretation: QuantumInterpretation

    init(
        id: UUID = UUID(),
        number: Int,
        name: String,
        family: QuantumFamily,
        essence: [String],
        messageProfond: String,
        imageName: String,
        interpretation: QuantumInterpretation
    ) {
        self.id = id
        self.number = number
        self.name = name
        self.family = family
        self.essence = essence
        self.messageProfond = messageProfond
        self.imageName = imageName
        self.interpretation = interpretation
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Drawn Quantum Oracle Card

struct DrawnQuantumOracleCard: Equatable, Identifiable, Codable, Hashable {
    let id: UUID
    let cardID: UUID

    init(card: QuantumOracleCard) {
        self.id = UUID()
        self.cardID = card.id
    }

    func resolve(from deck: [QuantumOracleCard]) -> QuantumOracleCard? {
        deck.first { $0.id == cardID }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Quantum Spread Types

enum QuantumSpreadType: String, CaseIterable, Codable, Identifiable {
    case lienDesAmes
    case chatDeSchrodinger
    case sautQuantique

    var id: String { rawValue }

    var cardCount: Int {
        switch self {
        case .lienDesAmes: return 3
        case .chatDeSchrodinger: return 4
        case .sautQuantique: return 5
        }
    }

    var title: String {
        switch self {
        case .lienDesAmes: return "Le Lien des Âmes"
        case .chatDeSchrodinger: return "Le Chat de Schrödinger"
        case .sautQuantique: return "Le Saut Quantique"
        }
    }

    var subtitle: String {
        switch self {
        case .lienDesAmes: return "Le Scanner Relationnel"
        case .chatDeSchrodinger: return "L'Outil Décisionnel"
        case .sautQuantique: return "La Flèche d'Évolution"
        }
    }

    var labels: [String] {
        switch self {
        case .lienDesAmes: return ["Particule Alpha (Vous)", "Particule Bêta (L'Autre)", "Cordon Quantique (Le Lien)"]
        case .chatDeSchrodinger: return ["Superposition (Situation)", "Boîte Ouverte A (Action)", "Boîte Ouverte B (Non-Action)", "Effondrement de l'Onde (Synthèse)"]
        case .sautQuantique: return ["Gravité (Frein)", "Énergie Noire (Force)", "Horizon (Seuil)", "Trou de Ver (Aide)", "Nouvelle Galaxie (But)"]
        }
    }

    var shortLabels: [String] {
        switch self {
        case .lienDesAmes: return ["Alpha", "Bêta", "Lien"]
        case .chatDeSchrodinger: return ["Situation", "Action", "Non-Action", "Synthèse"]
        case .sautQuantique: return ["Gravité", "Énergie Noire", "Horizon", "Trou de Ver", "Nouvelle Galaxie"]
        }
    }

    var icon: String {
        switch self {
        case .lienDesAmes: return "link"
        case .chatDeSchrodinger: return "questionmark.square.dashed"
        case .sautQuantique: return "arrow.up.forward.circle.fill"
        }
    }

    var description: String {
        switch self {
        case .lienDesAmes: return "Comprendre les énergies invisibles entre vous et une autre personne ou un projet"
        case .chatDeSchrodinger: return "Face à un dilemme, ouvrir les deux boîtes de possibles"
        case .sautQuantique: return "Dessiner la trajectoire de votre âme pour les grandes transitions"
        }
    }

    /// Returns the interpretation text for a card at a given position index in this spread
    func interpretationText(for card: QuantumOracleCard, at positionIndex: Int) -> String {
        let interp = card.interpretation
        switch self {
        case .lienDesAmes:
            switch positionIndex {
            case 0: return interp.alphaYou
            case 1: return interp.betaOther
            case 2: return interp.linkResult
            default: return ""
            }
        case .chatDeSchrodinger:
            switch positionIndex {
            case 0: return interp.situation
            case 1: return interp.actionBoxA
            case 2: return interp.nonActionBoxB
            case 3: return interp.collapseResult
            default: return ""
            }
        case .sautQuantique:
            switch positionIndex {
            case 0: return interp.gravity
            case 1: return interp.darkEnergy
            case 2: return interp.horizon
            case 3: return interp.wormhole
            case 4: return interp.newGalaxy
            default: return ""
            }
        }
    }
}

// MARK: - Quantum Oracle Reading

struct QuantumOracleReading: Equatable, Identifiable, Codable {
    let id: UUID
    let spread: QuantumSpreadType
    let cards: [DrawnQuantumOracleCard]
    let generatedAt: Date
    let question: String?

    init(
        id: UUID = UUID(),
        spread: QuantumSpreadType,
        cards: [DrawnQuantumOracleCard],
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
