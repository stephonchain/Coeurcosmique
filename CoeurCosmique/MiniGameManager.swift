import SwiftUI

// MARK: - Mini Game Manager

@MainActor
final class MiniGameManager: ObservableObject {
    static let shared = MiniGameManager()

    // Sphere rewards per game win
    static let memoryReward = 2
    static let missingCardReward = 1
    static let mahjongReward = 3

    // Stats keys
    private static let gamesPlayedKey = "minigames_totalPlayed"
    private static let spheresEarnedKey = "minigames_totalSpheresEarned"

    @Published private(set) var totalGamesPlayed: Int = 0
    @Published private(set) var totalSpheresEarned: Int = 0

    init() {
        totalGamesPlayed = UserDefaults.standard.integer(forKey: Self.gamesPlayedKey)
        totalSpheresEarned = UserDefaults.standard.integer(forKey: Self.spheresEarnedKey)
    }

    func rewardWin(game: MiniGameType, sphereManager: CosmicSphereManager) {
        let reward = game.reward
        sphereManager.add(reward)
        totalGamesPlayed += 1
        totalSpheresEarned += reward
        UserDefaults.standard.set(totalGamesPlayed, forKey: Self.gamesPlayedKey)
        UserDefaults.standard.set(totalSpheresEarned, forKey: Self.spheresEarnedKey)
    }
}

// MARK: - Mini Game Type

enum MiniGameType: String, CaseIterable, Identifiable {
    var id: String { rawValue }

    case memory
    case missingCard
    case mahjong

    var title: String {
        switch self {
        case .memory: return "Memory"
        case .missingCard: return "Carte Absente"
        case .mahjong: return "Mahjong Cosmique"
        }
    }

    var subtitle: String {
        switch self {
        case .memory: return "Retrouve les paires"
        case .missingCard: return "Quelle carte manque ?"
        case .mahjong: return "Associe les tuiles"
        }
    }

    var icon: String {
        switch self {
        case .memory: return "square.grid.2x2"
        case .missingCard: return "eye.slash"
        case .mahjong: return "rectangle.grid.3x2"
        }
    }

    var color: Color {
        switch self {
        case .memory: return .cyan
        case .missingCard: return .cosmicRose
        case .mahjong: return .cosmicPurple
        }
    }

    var reward: Int {
        switch self {
        case .memory: return MiniGameManager.memoryReward
        case .missingCard: return MiniGameManager.missingCardReward
        case .mahjong: return MiniGameManager.mahjongReward
        }
    }
}

// MARK: - Game Card (shared card model for mini-games)

struct GameCard: Identifiable, Equatable {
    let id = UUID()
    let matchID: String   // cards with same matchID are pairs
    let imageName: String
    let name: String

    static func == (lhs: GameCard, rhs: GameCard) -> Bool {
        lhs.id == rhs.id
    }

    /// Build a pool of game cards from all collectible decks
    static func buildPool(count: Int) -> [GameCard] {
        var allCards: [GameCard] = []

        for card in OracleDeck.allCards {
            allCards.append(GameCard(
                matchID: "oracle_\(card.number)",
                imageName: card.imageName,
                name: card.name
            ))
        }
        for card in QuantumOracleDeck.allCards {
            allCards.append(GameCard(
                matchID: "quantum_\(card.number)",
                imageName: card.imageName,
                name: card.name
            ))
        }
        for card in RuneDeck.allCards {
            allCards.append(GameCard(
                matchID: "rune_\(card.number)",
                imageName: card.imageName,
                name: card.name
            ))
        }

        return Array(allCards.shuffled().prefix(count))
    }
}

// MARK: - Game Win Overlay

struct GameWinOverlay: View {
    let gameType: MiniGameType
    let onDismiss: () -> Void
    let onPlayAgain: () -> Void

    @State private var appeared = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(Color.cosmicGold)
                    .scaleEffect(appeared ? 1.0 : 0.3)

                Text("Victoire !")
                    .font(.cosmicTitle(28))
                    .foregroundStyle(Color.cosmicGold)

                HStack(spacing: 8) {
                    Image(systemName: "diamond.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(.cyan)
                    Text("+\(gameType.reward) Spheres Cosmiques")
                        .font(.cosmicHeadline(16))
                        .foregroundStyle(.cyan)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Capsule().fill(Color.cyan.opacity(0.15))
                )

                VStack(spacing: 12) {
                    Button {
                        onPlayAgain()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.clockwise")
                            Text("Rejouer")
                                .font(.cosmicHeadline(16))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [gameType.color, gameType.color.opacity(0.7)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                    }
                    .buttonStyle(.plain)

                    Button {
                        onDismiss()
                    } label: {
                        Text("Retour")
                            .font(.cosmicCaption(14))
                            .foregroundStyle(Color.cosmicTextSecondary)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 40)
            }
            .padding(30)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                appeared = true
            }
        }
    }
}
