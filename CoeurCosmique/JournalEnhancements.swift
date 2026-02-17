import SwiftUI

// MARK: - Journal Tag

enum JournalTag: String, CaseIterable, Codable, Identifiable {
    case gratitude = "Gratitude"
    case reflection = "Réflexion"
    case dream = "Rêve"
    case intention = "Intention"
    case breakthrough = "Découverte"
    case challenge = "Défi"
    case emotion = "Émotion"
    case relationship = "Relation"
    
    var id: String { rawValue }
    
    var color: Color {
        switch self {
        case .gratitude: return .cosmicGold
        case .reflection: return .cosmicPurple
        case .dream: return .cosmicRose
        case .intention: return Color(red: 0.4, green: 0.7, blue: 0.9)
        case .breakthrough: return Color(red: 0.2, green: 0.8, blue: 0.6)
        case .challenge: return Color(red: 0.9, green: 0.5, blue: 0.3)
        case .emotion: return Color(red: 0.8, green: 0.4, blue: 0.7)
        case .relationship: return Color(red: 0.95, green: 0.6, blue: 0.7)
        }
    }
    
    var icon: String {
        switch self {
        case .gratitude: return "heart.fill"
        case .reflection: return "brain.head.profile"
        case .dream: return "moon.stars.fill"
        case .intention: return "target"
        case .breakthrough: return "lightbulb.fill"
        case .challenge: return "figure.climbing"
        case .emotion: return "face.smiling"
        case .relationship: return "person.2.fill"
        }
    }
}

// MARK: - Card Prompts Database

struct CardPrompts {
    static let prompts: [String: [String]] = [
        // Tarot Majeur
        "Le Bateleur": [
            "Quel nouveau départ aimerais-tu initier aujourd'hui ?",
            "Quelles compétences ou ressources as-tu à ta disposition ?"
        ],
        "La Papesse": [
            "Quelle sagesse intérieure cherche à émerger en toi ?",
            "Qu'est-ce que ton intuition te murmure ?"
        ],
        "L'Impératrice": [
            "Comment nourris-tu ta créativité aujourd'hui ?",
            "Où peux-tu manifester plus d'abondance dans ta vie ?"
        ],
        "L'Empereur": [
            "Quelle structure ou discipline t'aiderait à avancer ?",
            "Comment peux-tu exercer plus de leadership sur ta vie ?"
        ],
        "Le Pape": [
            "Quelle tradition ou enseignement te guide en ce moment ?",
            "À quelle sagesse ancestrale te connects-tu ?"
        ],
        "L'Amoureux": [
            "Face à quel choix important te trouves-tu ?",
            "Comment alignes-tu tes décisions avec tes valeurs ?"
        ],
        "Le Chariot": [
            "Vers quel objectif diriges-tu toute ton énergie ?",
            "Comment gardes-tu le cap malgré les obstacles ?"
        ],
        "La Justice": [
            "Quelle situation demande plus d'équilibre dans ta vie ?",
            "Quelle vérité dois-tu reconnaître ?"
        ],
        "L'Hermite": [
            "Quel enseignement découvres-tu dans la solitude ?",
            "Quelle lumière intérieure guides-tu vers les autres ?"
        ],
        "La Roue de Fortune": [
            "Quelle opportunité cyclique se présente à toi ?",
            "Comment accueilles-tu les changements dans ta vie ?"
        ],
        "La Force": [
            "Quelle force intérieure mobilises-tu aujourd'hui ?",
            "Comment t'exerces-tu à la compassion envers toi-même ?"
        ],
        "Le Pendu": [
            "Quelle perspective nouvelle adoptes-tu en lâchant prise ?",
            "Qu'es-tu prêt·e à sacrifier pour ta croissance ?"
        ],
        "L'Arcane sans Nom": [
            "Quelle transformation profonde s'opère en toi ?",
            "À quoi es-tu prêt·e à dire adieu pour renaître ?"
        ],
        "Tempérance": [
            "Comment trouves-tu l'équilibre entre tes différents roles ?",
            "Quelle alchimie créative t'anime ?"
        ],
        "Le Diable": [
            "Quelle chaîne auto-imposée es-tu prêt·e à briser ?",
            "Quels désirs profonds reconnais-tu sans jugement ?"
        ],
        "La Maison Dieu": [
            "Quelle croyance limitante s'effondre pour te libérer ?",
            "Quelle révélation soudaine transforme ta perspective ?"
        ],
        "L'Étoile": [
            "Quel espoir guide ton chemin ?",
            "Comment partages-tu ta lumière avec le monde ?"
        ],
        "La Lune": [
            "Quelles émotions profondes émergent à la surface ?",
            "Quel message ton inconscient cherche-t-il à te transmettre ?"
        ],
        "Le Soleil": [
            "Qu'est-ce qui t'apporte une joie pure aujourd'hui ?",
            "Comment célèbres-tu tes victoires ?"
        ],
        "Le Jugement": [
            "À quel appel profond réponds-tu ?",
            "Quelle version renouvelée de toi-même accueilles-tu ?"
        ],
        "Le Monde": [
            "Quel cycle arrives-tu à accomplir ?",
            "Comment célèbres-tu ton intégration et ta totalité ?"
        ],
        "Le Mat": [
            "Vers quelle aventure inconnue te lances-tu avec confiance ?",
            "Quelle liberté trouves-tu dans le non-savoir ?"
        ]
    ]
    
    static func forCard(_ cardName: String) -> [String] {
        return prompts[cardName] ?? [
            "Qu'est-ce que cette carte évoque en toi ?",
            "Comment cette énergie se manifeste-t-elle dans ta vie actuellement ?"
        ]
    }
    
    static func hasPrompts(for cardName: String) -> Bool {
        return prompts[cardName] != nil
    }
}
