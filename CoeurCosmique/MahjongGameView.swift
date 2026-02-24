import SwiftUI

// MARK: - Mahjong Game View

struct MahjongGameView: View {
    let onDismiss: () -> Void

    @StateObject private var sphereManager = CosmicSphereManager.shared
    @StateObject private var gameManager = MiniGameManager.shared

    @State private var tiles: [MahjongTile] = []
    @State private var selectedTile: Int? = nil
    @State private var matchedCount: Int = 0
    @State private var totalPairs: Int = 0
    @State private var moves: Int = 0
    @State private var showWin = false
    @State private var showHint = false
    @State private var difficulty: MahjongDifficulty = .medium
    @State private var started = false
    @State private var gridColumns: Int = 6

    enum MahjongDifficulty: String, CaseIterable {
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
            case .easy: return 10     // 20 tiles = 4x5
            case .medium: return 15   // 30 tiles = 5x6
            case .hard: return 21     // 42 tiles = 6x7
            }
        }

        var columns: Int {
            switch self {
            case .easy: return 5
            case .medium: return 6
            case .hard: return 7
            }
        }

        var rows: Int {
            switch self {
            case .easy: return 4
            case .medium: return 5
            case .hard: return 6
            }
        }
    }

    var body: some View {
        ZStack {
            Color.cosmicBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                gameHeader

                if !started {
                    difficultySelection
                } else {
                    gameBoard
                    statsBar
                }
            }

            if showWin {
                GameWinOverlay(
                    gameType: .mahjong,
                    onDismiss: onDismiss,
                    onPlayAgain: {
                        showWin = false
                        started = false
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

            Text("Mahjong Cosmique")
                .font(.cosmicHeadline(18))
                .foregroundStyle(Color.cosmicText)

            Spacer()

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

            Image(systemName: "rectangle.grid.3x2")
                .font(.system(size: 50, weight: .light))
                .foregroundStyle(Color.cosmicPurple.opacity(0.6))

            Text("Mahjong Cosmique")
                .font(.cosmicTitle(24))
                .foregroundStyle(Color.cosmicText)

            Text("Associe les paires de tuiles identiques.\nSeules les tuiles libres peuvent etre selectionnees.")
                .font(.cosmicBody(14))
                .foregroundStyle(Color.cosmicTextSecondary)
                .multilineTextAlignment(.center)

            HStack(spacing: 8) {
                Image(systemName: "diamond.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(.cyan)
                Text("+\(MiniGameManager.mahjongReward) Spheres par victoire")
                    .font(.cosmicCaption(13))
                    .foregroundStyle(.cyan)
            }

            VStack(spacing: 14) {
                ForEach(MahjongDifficulty.allCases, id: \.rawValue) { diff in
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
                                        .strokeBorder(Color.cosmicPurple.opacity(0.3), lineWidth: 1)
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
        let cols = Array(repeating: GridItem(.flexible(), spacing: 4), count: gridColumns)
        let tileWidth = (UIScreen.main.bounds.width - 32 - CGFloat(gridColumns - 1) * 4) / CGFloat(gridColumns)
        let tileHeight = tileWidth * 1.35

        return ScrollView(showsIndicators: false) {
            LazyVGrid(columns: cols, spacing: 4) {
                ForEach(Array(tiles.enumerated()), id: \.element.id) { index, tile in
                    if tile.isRemoved {
                        // Empty space
                        Color.clear
                            .frame(width: tileWidth, height: tileHeight)
                    } else {
                        mahjongTileView(tile: tile, index: index, width: tileWidth, height: tileHeight)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }

    private func mahjongTileView(tile: MahjongTile, index: Int, width: CGFloat, height: CGFloat) -> some View {
        let isFree = isTileFree(index: index)
        let isSelected = selectedTile == index

        return ZStack {
            if UIImage(named: tile.card.imageName) != nil {
                Image(tile.card.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            } else {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.cosmicCard)
                    .frame(width: width, height: height)
                    .overlay(
                        Text(tile.card.name)
                            .font(.system(size: 7))
                            .foregroundStyle(Color.cosmicText)
                            .multilineTextAlignment(.center)
                            .padding(2)
                    )
            }

            // Selection highlight
            if isSelected {
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(Color.cosmicGold, lineWidth: 2.5)
                    .frame(width: width, height: height)
            }

            // Locked overlay
            if !isFree {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.black.opacity(0.4))
                    .frame(width: width, height: height)
            }
        }
        .shadow(color: isFree ? Color.cosmicPurple.opacity(0.3) : .clear, radius: isFree ? 4 : 0)
        .onTapGesture {
            guard isFree else { return }
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

            Label("\(matchedCount)/\(totalPairs) paires", systemImage: "checkmark.circle")
                .font(.cosmicCaption(13))
                .foregroundStyle(Color.cosmicPurple)

            if showHint {
                Button {
                    highlightHint()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 10))
                        Text("Indice")
                            .font(.cosmicCaption(11))
                    }
                    .foregroundStyle(Color.cosmicGold)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color.cosmicSurface)
    }

    // MARK: - Logic

    private func startGame() {
        let cards = GameCard.buildPool(count: difficulty.pairCount)
        var allTiles: [MahjongTile] = []

        for card in cards {
            allTiles.append(MahjongTile(card: card, row: 0, col: 0))
            allTiles.append(MahjongTile(card: card, row: 0, col: 0))
        }

        allTiles.shuffle()
        gridColumns = difficulty.columns

        // Assign row/col positions
        for (i, _) in allTiles.enumerated() {
            let row = i / gridColumns
            let col = i % gridColumns
            allTiles[i].row = row
            allTiles[i].col = col
        }

        tiles = allTiles
        totalPairs = difficulty.pairCount
        matchedCount = 0
        moves = 0
        selectedTile = nil
        showHint = true
        started = true
    }

    private func isTileFree(index: Int) -> Bool {
        let tile = tiles[index]
        if tile.isRemoved { return false }

        let row = tile.row
        let col = tile.col

        // A tile is free if it has at least one exposed horizontal side
        let leftFree = col == 0 || neighborRemoved(row: row, col: col - 1)
        let rightFree = col == gridColumns - 1 || neighborRemoved(row: row, col: col + 1)

        return leftFree || rightFree
    }

    private func neighborRemoved(row: Int, col: Int) -> Bool {
        guard let idx = tiles.firstIndex(where: { $0.row == row && $0.col == col && !$0.isRemoved }) else {
            return true // no tile there = free
        }
        return false
    }

    private func tapTile(index: Int) {
        if let selected = selectedTile {
            if selected == index {
                // Deselect
                selectedTile = nil
                return
            }

            let first = tiles[selected]
            let second = tiles[index]

            if first.card.matchID == second.card.matchID {
                // Match!
                withAnimation(.easeOut(duration: 0.3)) {
                    tiles[selected].isRemoved = true
                    tiles[index].isRemoved = true
                }
                matchedCount += 1
                moves += 1
                selectedTile = nil

                if matchedCount == totalPairs {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        gameManager.rewardWin(game: .mahjong, sphereManager: sphereManager)
                        showWin = true
                    }
                }
            } else {
                // No match
                moves += 1
                selectedTile = index
            }
        } else {
            selectedTile = index
        }
    }

    private func highlightHint() {
        // Find a valid pair
        let freeIndices = tiles.enumerated().filter { !$0.element.isRemoved && isTileFree(index: $0.offset) }

        for i in 0..<freeIndices.count {
            for j in (i + 1)..<freeIndices.count {
                if freeIndices[i].element.card.matchID == freeIndices[j].element.card.matchID {
                    selectedTile = freeIndices[i].offset
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        if selectedTile == freeIndices[i].offset {
                            selectedTile = nil
                        }
                    }
                    return
                }
            }
        }
    }
}

// MARK: - Mahjong Tile

struct MahjongTile: Identifiable {
    let id = UUID()
    let card: GameCard
    var row: Int
    var col: Int
    var isRemoved: Bool = false
}
