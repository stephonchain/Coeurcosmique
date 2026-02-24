import SwiftUI

// MARK: - Mini Game Manager

@MainActor
final class MiniGameManager: ObservableObject {
    static let shared = MiniGameManager()

    // All games reward 1 sphere per win (Memory requires 3 wins)
    static let sphereReward = 1
    static let memoryWinsNeeded = 3

    // Stats keys
    private static let gamesPlayedKey = "minigames_totalPlayed"
    private static let spheresEarnedKey = "minigames_totalSpheresEarned"
    private static let memoryWinProgressKey = "minigames_memoryWinProgress"

    @Published private(set) var totalGamesPlayed: Int = 0
    @Published private(set) var totalSpheresEarned: Int = 0
    @Published private(set) var memoryWinProgress: Int = 0 // 0, 1, or 2 — resets to 0 after sphere

    init() {
        totalGamesPlayed = UserDefaults.standard.integer(forKey: Self.gamesPlayedKey)
        totalSpheresEarned = UserDefaults.standard.integer(forKey: Self.spheresEarnedKey)
        memoryWinProgress = UserDefaults.standard.integer(forKey: Self.memoryWinProgressKey)
    }

    /// Standard reward: 1 sphere on win (for Carte Absente, Mahjong)
    func rewardWin(game: MiniGameType, sphereManager: CosmicSphereManager) {
        sphereManager.add(Self.sphereReward)
        totalGamesPlayed += 1
        totalSpheresEarned += Self.sphereReward
        save()
    }

    /// Memory reward: 1 sphere every 3 wins. Returns true if sphere was awarded.
    @discardableResult
    func rewardMemoryWin(sphereManager: CosmicSphereManager) -> Bool {
        totalGamesPlayed += 1
        memoryWinProgress += 1

        if memoryWinProgress >= Self.memoryWinsNeeded {
            memoryWinProgress = 0
            sphereManager.add(Self.sphereReward)
            totalSpheresEarned += Self.sphereReward
            save()
            return true
        }

        save()
        return false
    }

    private func save() {
        UserDefaults.standard.set(totalGamesPlayed, forKey: Self.gamesPlayedKey)
        UserDefaults.standard.set(totalSpheresEarned, forKey: Self.spheresEarnedKey)
        UserDefaults.standard.set(memoryWinProgress, forKey: Self.memoryWinProgressKey)
    }
}

// MARK: - Mini Game Type

enum MiniGameType: String, CaseIterable, Identifiable {
    var id: String { rawValue }

    case memory
    case missingCard
    case mahjong
    case flashCosmique

    var title: String {
        switch self {
        case .memory: return "Memory"
        case .missingCard: return "Carte Absente"
        case .mahjong: return "Mahjong Cosmique"
        case .flashCosmique: return "Flash Cosmique"
        }
    }

    var subtitle: String {
        switch self {
        case .memory: return "Retrouve les paires"
        case .missingCard: return "Quelle carte manque ?"
        case .mahjong: return "Associe les tuiles"
        case .flashCosmique: return "Apprends les cartes"
        }
    }

    var icon: String {
        switch self {
        case .memory: return "square.grid.2x2"
        case .missingCard: return "eye.slash"
        case .mahjong: return "rectangle.grid.3x2"
        case .flashCosmique: return "brain.head.profile"
        }
    }

    var color: Color {
        switch self {
        case .memory: return .cyan
        case .missingCard: return .cosmicRose
        case .mahjong: return .cosmicPurple
        case .flashCosmique: return .cosmicGold
        }
    }

    var reward: Int { MiniGameManager.sphereReward }

    var rewardLabel: String {
        switch self {
        case .memory: return "1 / 3 victoires"
        case .missingCard: return "+1 Sphere"
        case .mahjong: return "+1 Sphere"
        case .flashCosmique: return "Cartes GOLD"
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
    let spheresEarned: Int  // 0 = no sphere this time (e.g. Memory 1/3)
    let subtitle: String?   // e.g. "2/3 victoires" for Memory progress
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

                if spheresEarned > 0 {
                    HStack(spacing: 8) {
                        Image(systemName: "diamond.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(.cyan)
                        Text("+\(spheresEarned) Sphere Cosmique")
                            .font(.cosmicHeadline(16))
                            .foregroundStyle(.cyan)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        Capsule().fill(Color.cyan.opacity(0.15))
                    )
                }

                if let subtitle {
                    Text(subtitle)
                        .font(.cosmicCaption(13))
                        .foregroundStyle(Color.cosmicTextSecondary)
                }

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

// MARK: - Game Over Overlay

struct GameOverOverlay: View {
    let message: String
    let onDismiss: () -> Void
    let onRetry: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "xmark.circle")
                    .font(.system(size: 50))
                    .foregroundStyle(Color.cosmicRose)

                Text("Partie terminee")
                    .font(.cosmicTitle(24))
                    .foregroundStyle(Color.cosmicRose)

                Text(message)
                    .font(.cosmicBody(14))
                    .foregroundStyle(Color.cosmicTextSecondary)
                    .multilineTextAlignment(.center)

                VStack(spacing: 12) {
                    Button {
                        onRetry()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.clockwise")
                            Text("Reessayer")
                                .font(.cosmicHeadline(16))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [.cosmicPurple, .cosmicRose],
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
    }
}
