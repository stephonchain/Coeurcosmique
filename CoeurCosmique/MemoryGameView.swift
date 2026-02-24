import SwiftUI

// MARK: - Memory Game View

struct MemoryGameView: View {
    let onDismiss: () -> Void

    @StateObject private var sphereManager = CosmicSphereManager.shared
    @StateObject private var gameManager = MiniGameManager.shared
    @State private var tiles: [MemoryTile] = []
    @State private var firstFlipped: Int? = nil
    @State private var secondFlipped: Int? = nil
    @State private var matchedIDs: Set<String> = []
    @State private var moves: Int = 0
    @State private var isChecking = false
    @State private var showWin = false
    @State private var lastWinEarnedSphere = false
    @State private var difficulty: MemoryDifficulty = .medium

    enum MemoryDifficulty: String, CaseIterable {
        case easy, medium, hard

        var label: String {
            switch self {
            case .easy: return "Facile"
            case .medium: return "Normal"
            case .hard: return "Difficile"
            }
        }

        var pairCount: Int {
            switch self {
            case .easy: return 6      // 4x3
            case .medium: return 8    // 4x4
            case .hard: return 10     // 4x5
            }
        }

        var columns: Int {
            switch self {
            case .easy: return 3
            case .medium: return 4
            case .hard: return 4
            }
        }
    }

    var body: some View {
        ZStack {
            Color.cosmicBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                gameHeader

                if tiles.isEmpty {
                    // Difficulty selection
                    difficultySelection
                } else {
                    // Game board
                    gameBoard

                    // Stats bar
                    statsBar
                }
            }

            if showWin {
                GameWinOverlay(
                    gameType: .memory,
                    spheresEarned: lastWinEarnedSphere ? 1 : 0,
                    subtitle: lastWinEarnedSphere ? nil : "\(gameManager.memoryWinProgress)/\(MiniGameManager.memoryWinsNeeded) victoires pour 1 Sphere",
                    onDismiss: onDismiss,
                    onPlayAgain: {
                        showWin = false
                        tiles = []
                    }
                )
            }
        }
    }

    // MARK: - Header

    private var gameHeader: some View {
        HStack {
            Button {
                onDismiss()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                    Text("Retour")
                        .font(.cosmicCaption(14))
                }
                .foregroundStyle(Color.cosmicTextSecondary)
            }
            .buttonStyle(.plain)

            Spacer()

            Text("Memory")
                .font(.cosmicHeadline(18))
                .foregroundStyle(Color.cosmicText)

            Spacer()

            // Sphere balance
            HStack(spacing: 4) {
                Image(systemName: "diamond.fill")
                    .font(.system(size: 10))
                    .foregroundStyle(.cyan)
                Text("\(sphereManager.balance)")
                    .font(.cosmicCaption(12))
                    .foregroundStyle(.cyan)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }

    // MARK: - Difficulty Selection

    private var difficultySelection: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(systemName: "square.grid.2x2")
                .font(.system(size: 50, weight: .light))
                .foregroundStyle(Color.cyan.opacity(0.6))

            Text("Memory Cosmique")
                .font(.cosmicTitle(24))
                .foregroundStyle(Color.cosmicText)

            Text("Retrouve les paires de cartes identiques")
                .font(.cosmicBody(14))
                .foregroundStyle(Color.cosmicTextSecondary)
                .multilineTextAlignment(.center)

            HStack(spacing: 8) {
                Image(systemName: "diamond.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(.cyan)
                Text("1 Sphere toutes les 3 victoires (\(gameManager.memoryWinProgress)/3)")
                    .font(.cosmicCaption(13))
                    .foregroundStyle(.cyan)
            }

            VStack(spacing: 14) {
                ForEach(MemoryDifficulty.allCases, id: \.rawValue) { diff in
                    Button {
                        difficulty = diff
                        startGame()
                    } label: {
                        HStack {
                            Text(diff.label)
                                .font(.cosmicHeadline(16))
                                .foregroundStyle(.white)
                            Spacer()
                            Text("\(diff.pairCount) paires")
                                .font(.cosmicCaption(13))
                                .foregroundStyle(Color.cosmicTextSecondary)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.cosmicCard)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .strokeBorder(Color.cyan.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 40)

            Spacer()
        }
    }

    // MARK: - Game Board

    private var gameBoard: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: difficulty.columns)

        return ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(Array(tiles.enumerated()), id: \.element.id) { index, tile in
                    memoryTileView(tile: tile, index: index)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }

    private func memoryTileView(tile: MemoryTile, index: Int) -> some View {
        let isFlipped = tile.isMatched || index == firstFlipped || index == secondFlipped
        let cardWidth: CGFloat = (UIScreen.main.bounds.width - 32 - CGFloat(difficulty.columns - 1) * 8) / CGFloat(difficulty.columns)
        let cardHeight = cardWidth * 1.4

        return ZStack {
            if isFlipped {
                // Front - show card image
                if UIImage(named: tile.card.imageName) != nil {
                    Image(tile.card.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: cardWidth, height: cardHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.cosmicCard)
                        .frame(width: cardWidth, height: cardHeight)
                        .overlay(
                            Text(tile.card.name)
                                .font(.cosmicCaption(9))
                                .foregroundStyle(Color.cosmicText)
                                .multilineTextAlignment(.center)
                                .padding(4)
                        )
                }

                if tile.isMatched {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.green.opacity(0.2))
                        .frame(width: cardWidth, height: cardHeight)
                        .overlay(
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(.green.opacity(0.7))
                        )
                }
            } else {
                // Back
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(
                            colors: [.cosmicPurple.opacity(0.8), .cosmicRose.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: cardWidth, height: cardHeight)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.cosmicGold.opacity(0.3), lineWidth: 1)
                    )
                    .overlay(
                        Image(systemName: "sparkle")
                            .font(.system(size: 18))
                            .foregroundStyle(Color.cosmicGold.opacity(0.3))
                    )
            }
        }
        .rotation3DEffect(
            .degrees(isFlipped ? 0 : 180),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.easeInOut(duration: 0.3), value: isFlipped)
        .onTapGesture {
            guard !isChecking, !tile.isMatched else { return }
            guard index != firstFlipped else { return }
            tapTile(index: index)
        }
    }

    // MARK: - Stats Bar

    private var statsBar: some View {
        HStack(spacing: 20) {
            Label("\(moves) coups", systemImage: "hand.tap")
                .font(.cosmicCaption(13))
                .foregroundStyle(Color.cosmicTextSecondary)

            Spacer()

            Label("\(matchedIDs.count)/\(difficulty.pairCount) paires", systemImage: "checkmark.circle")
                .font(.cosmicCaption(13))
                .foregroundStyle(Color.cyan)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color.cosmicSurface)
    }

    // MARK: - Logic

    private func startGame() {
        let cards = GameCard.buildPool(count: difficulty.pairCount)
        var allTiles: [MemoryTile] = []
        for card in cards {
            allTiles.append(MemoryTile(card: card))
            allTiles.append(MemoryTile(card: card))
        }
        tiles = allTiles.shuffled()
        matchedIDs = []
        moves = 0
        firstFlipped = nil
        secondFlipped = nil
        isChecking = false
    }

    private func tapTile(index: Int) {
        if firstFlipped == nil {
            firstFlipped = index
        } else if secondFlipped == nil {
            secondFlipped = index
            moves += 1
            isChecking = true

            let first = tiles[firstFlipped!]
            let second = tiles[index]

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                if first.card.matchID == second.card.matchID {
                    // Match!
                    tiles[firstFlipped!].isMatched = true
                    tiles[index].isMatched = true
                    matchedIDs.insert(first.card.matchID)

                    if matchedIDs.count == difficulty.pairCount {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            lastWinEarnedSphere = gameManager.rewardMemoryWin(sphereManager: sphereManager)
                            showWin = true
                        }
                    }
                }

                firstFlipped = nil
                secondFlipped = nil
                isChecking = false
            }
        }
    }
}

// MARK: - Memory Tile

struct MemoryTile: Identifiable {
    let id = UUID()
    let card: GameCard
    var isMatched: Bool = false
}
