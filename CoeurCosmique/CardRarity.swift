import SwiftUI

// MARK: - Card Rarity

enum CardRarity: String, CaseIterable, Codable, Comparable {
    case common
    case rare
    case holographic
    case golden

    var label: String {
        switch self {
        case .common: return "Commune"
        case .rare: return "Rare"
        case .holographic: return "Holographique"
        case .golden: return "Dorée"
        }
    }

    var icon: String {
        switch self {
        case .common: return "circle.fill"
        case .rare: return "star.fill"
        case .holographic: return "sparkle"
        case .golden: return "crown.fill"
        }
    }

    var color: Color {
        switch self {
        case .common: return .cosmicTextSecondary
        case .rare: return .cosmicPurple
        case .holographic: return .cyan
        case .golden: return .cosmicGold
        }
    }

    // Relative weight for rarity rolls (not a probability — normalized at usage)
    var weight: Double {
        switch self {
        case .common: return 1.00     // 100%
        case .rare: return 0.20       // 20%
        case .holographic: return 0.10 // 10%
        case .golden: return 0.01     // 1%
        }
    }

    // Sort order for Comparable
    private var sortOrder: Int {
        switch self {
        case .common: return 0
        case .rare: return 1
        case .holographic: return 2
        case .golden: return 3
        }
    }

    static func < (lhs: CardRarity, rhs: CardRarity) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }
}

// MARK: - Collectible Card Identifier

struct CollectibleCardID: Codable, Hashable {
    let deck: CollectibleDeck
    let number: Int

    var key: String { "\(deck.rawValue)_\(number)" }
}

enum CollectibleDeck: String, CaseIterable, Codable {
    case oracle
    case quantum
    case rune

    var title: String {
        switch self {
        case .oracle: return "Oracle du Coeur Cosmique"
        case .quantum: return "Oracle du Lien Quantique"
        case .rune: return "Runes Cosmiques"
        }
    }

    var totalCards: Int {
        switch self {
        case .oracle: return 42
        case .quantum: return 42
        case .rune: return 24
        }
    }

    var accentColor: Color {
        switch self {
        case .oracle: return .cosmicRose
        case .quantum: return .cosmicPurple
        case .rune: return .cosmicGold
        }
    }
}

// MARK: - Collected Card Entry

struct CollectedCardEntry: Codable, Hashable {
    let cardID: CollectibleCardID
    let rarity: CardRarity
    let obtainedAt: Date
    var count: Int // how many times pulled (duplicates)
}

// MARK: - Booster Card (a card in a booster result)

struct BoosterCard: Identifiable, Equatable {
    let id = UUID()
    let deck: CollectibleDeck
    let number: Int
    let rarity: CardRarity
    let isNew: Bool // first time pulling this card

    static func == (lhs: BoosterCard, rhs: BoosterCard) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Booster Type

enum BoosterType: String, CaseIterable {
    case commun
    case rare
    case cosmique

    var label: String {
        switch self {
        case .commun: return "Booster Commun"
        case .rare: return "Booster Rare"
        case .cosmique: return "Booster Cosmique"
        }
    }

    var shortLabel: String {
        switch self {
        case .commun: return "COMMUN"
        case .rare: return "RARE"
        case .cosmique: return "COSMIQUE"
        }
    }

    var color: Color {
        switch self {
        case .commun: return .cosmicTextSecondary
        case .rare: return .cosmicPurple
        case .cosmique: return .cosmicGold
        }
    }

    var gradientColors: [Color] {
        switch self {
        case .commun: return [.cosmicPurple, .cosmicRose]
        case .rare: return [.purple, .cyan]
        case .cosmique: return [.cosmicGold, .orange, .cosmicGold]
        }
    }

    /// Roll a random booster type: Commun ~95.9%, Rare 4%, Cosmique 0.1%
    static func roll() -> BoosterType {
        let r = Double.random(in: 0..<1)
        if r < 0.001 {
            return .cosmique  // 0.1%
        } else if r < 0.041 {
            return .rare      // 4%
        } else {
            return .commun    // ~95.9%
        }
    }
}

// MARK: - Rarity Visual Modifier

struct RarityGlowModifier: ViewModifier {
    let rarity: CardRarity

    func body(content: Content) -> some View {
        switch rarity {
        case .common:
            content
        case .rare:
            content
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            LinearGradient(
                                colors: [Color.cosmicPurple.opacity(0.6), Color.cosmicPurple.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
        case .holographic:
            content
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            AngularGradient(
                                colors: [.cyan, .purple, .pink, .orange, .cyan],
                                center: .center
                            ),
                            lineWidth: 2.5
                        )
                )
                .shadow(color: .cyan.opacity(0.3), radius: 8)
        case .golden:
            content
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color(red: 1.0, green: 0.84, blue: 0.0),
                                    Color(red: 0.85, green: 0.65, blue: 0.13),
                                    Color(red: 1.0, green: 0.84, blue: 0.0),
                                    Color(red: 0.85, green: 0.65, blue: 0.13)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                )
                .shadow(color: Color.cosmicGold.opacity(0.5), radius: 12)
        }
    }
}

extension View {
    func rarityGlow(_ rarity: CardRarity) -> some View {
        modifier(RarityGlowModifier(rarity: rarity))
    }
}
