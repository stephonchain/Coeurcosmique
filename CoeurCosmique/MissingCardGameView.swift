import SwiftUI

// MARK: - Missing Card Game View (Carte Absente)

struct MissingCardGameView: View {
    let onDismiss: () -> Void

    @StateObject private var sphereManager = CosmicSphereManager.shared
    @StateObject private var gameManager = MiniGameManager.shared

    @State private var phase: GamePhase = .menu
    @State private var allCards: [GameCard] = []
    @State private var missingCard: GameCard? = nil
    @State private var displayedCards: [GameCard] = []
    @State private var selectedAnswer: GameCard? = nil
    @State private var showWin = false
    @State private var showError = false
    @State private var memorizeCountdown: Int = 0
    @State private var round: Int = 0
    @State private var score: Int = 0
    @State private var difficulty: MissingDifficulty = .medium

    enum GamePhase {
        case menu
        case memorize    // Cards face up, memorize them
        case guess       // One card removed, find it
        case result      // Show if correct
    }

    enum MissingDifficulty: String, CaseIterable {
        case easy, medium, hard

        var label: String {
            switch self {
            case .easy: return "Facile"
            case .medium: return "Normal"
            case .hard: return "Difficile"
            }
        }

        var cardCount: Int {
            switch self {
            case .easy: return 4
            case .medium: return 6
            case .hard: return 9
            }
        }

        var memorizeTime: Int {
            switch self {
            case .easy: return 5
            case .medium: return 4
            case .hard: return 3
            }
        }

        var columns: Int {
            switch self {
            case .easy: return 2
            case .medium: return 3
            case .hard: return 3
            }
        }

        var roundsToWin: Int { return 3 }
    }

    var body: some View {
        ZStack {
            Color.cosmicBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                gameHeader

                switch phase {
                case .menu:
                    difficultySelection
                case .memorize:
                    memorizePhase
                case .guess:
                    guessPhase
                case .result:
                    EmptyView()
                }
            }

            if showWin {
                GameWinOverlay(
                    gameType: .missingCard,
                    onDismiss: onDismiss,
                    onPlayAgain: {
                        showWin = false
                        phase = .menu
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

            Text("Carte Absente")
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

            Image(systemName: "eye.slash")
                .font(.system(size: 50, weight: .light))
                .foregroundStyle(Color.cosmicRose.opacity(0.6))

            Text("Carte Absente")
                .font(.cosmicTitle(24))
                .foregroundStyle(Color.cosmicText)

            Text("Memorise les cartes. L'une d'elles disparait.\nRetrouve laquelle !")
                .font(.cosmicBody(14))
                .foregroundStyle(Color.cosmicTextSecondary)
                .multilineTextAlignment(.center)

            HStack(spacing: 8) {
                Image(systemName: "diamond.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(.cyan)
                Text("+\(MiniGameManager.missingCardReward) Sphere par victoire")
                    .font(.cosmicCaption(13))
                    .foregroundStyle(.cyan)
            }

            VStack(spacing: 14) {
                ForEach(MissingDifficulty.allCases, id: \.rawValue) { diff in
                    Button {
                        difficulty = diff
                        startGame()
                    } label: {
                        HStack {
                            Text(diff.label)
                                .font(.cosmicHeadline(16))
                                .foregroundStyle(.white)
                            Spacer()
                            Text("\(diff.cardCount) cartes · \(diff.memorizeTime)s")
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
                                        .strokeBorder(Color.cosmicRose.opacity(0.3), lineWidth: 1)
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

    // MARK: - Memorize Phase

    private var memorizePhase: some View {
        VStack(spacing: 16) {
            // Round + countdown
            HStack {
                Text("Manche \(round)/\(difficulty.roundsToWin)")
                    .font(.cosmicCaption(13))
                    .foregroundStyle(Color.cosmicTextSecondary)

                Spacer()

                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                    Text("\(memorizeCountdown)s")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                }
                .foregroundStyle(memorizeCountdown <= 2 ? .red : Color.cosmicGold)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            Text("Memorise les cartes !")
                .font(.cosmicHeadline(16))
                .foregroundStyle(Color.cosmicRose)

            cardGrid(cards: allCards, selectable: false)

            Spacer()
        }
    }

    // MARK: - Guess Phase

    private var guessPhase: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Manche \(round)/\(difficulty.roundsToWin)")
                    .font(.cosmicCaption(13))
                    .foregroundStyle(Color.cosmicTextSecondary)

                Spacer()

                Text("Score: \(score)/\(round - 1)")
                    .font(.cosmicCaption(13))
                    .foregroundStyle(Color.cosmicGold)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            Text("Quelle carte a disparu ?")
                .font(.cosmicHeadline(16))
                .foregroundStyle(Color.cosmicRose)

            cardGrid(cards: displayedCards, selectable: true)

            if showError {
                VStack(spacing: 8) {
                    Text("Mauvaise reponse !")
                        .font(.cosmicCaption(13))
                        .foregroundStyle(.red)
                    if let missing = missingCard {
                        Text("C'etait : \(missing.name)")
                            .font(.cosmicCaption(12))
                            .foregroundStyle(Color.cosmicTextSecondary)
                    }
                }
                .padding(.vertical, 8)
            }

            Spacer()

            // Choice buttons from ALL original cards (pick the missing one)
            Text("Choisis la carte manquante :")
                .font(.cosmicCaption(12))
                .foregroundStyle(Color.cosmicTextSecondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(allCards) { card in
                        let isMissing = !displayedCards.contains(where: { $0.matchID == card.matchID })
                        Button {
                            selectAnswer(card)
                        } label: {
                            VStack(spacing: 4) {
                                cardThumbnail(card: card, size: 50)
                                Text(card.name)
                                    .font(.system(size: 8))
                                    .foregroundStyle(Color.cosmicText)
                                    .lineLimit(1)
                            }
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedAnswer?.matchID == card.matchID ? Color.cosmicRose.opacity(0.3) : Color.cosmicCard)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(
                                        isMissing && showError ? Color.green : Color.clear,
                                        lineWidth: 2
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                        .disabled(showError)
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 20)
        }
    }

    // MARK: - Card Grid

    private func cardGrid(cards: [GameCard], selectable: Bool) -> some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: difficulty.columns)
        let cardWidth = (UIScreen.main.bounds.width - 40 - CGFloat(difficulty.columns - 1) * 10) / CGFloat(difficulty.columns)
        let cardHeight = cardWidth * 1.4

        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(cards) { card in
                if UIImage(named: card.imageName) != nil {
                    Image(card.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: cardWidth, height: cardHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.cosmicCard)
                        .frame(width: cardWidth, height: cardHeight)
                        .overlay(
                            VStack(spacing: 4) {
                                Text(card.name)
                                    .font(.cosmicCaption(10))
                                    .foregroundStyle(Color.cosmicText)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(4)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.cosmicPurple.opacity(0.3), lineWidth: 1)
                        )
                }
            }
        }
        .padding(.horizontal, 20)
    }

    private func cardThumbnail(card: GameCard, size: CGFloat) -> some View {
        Group {
            if UIImage(named: card.imageName) != nil {
                Image(card.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size * 1.4)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            } else {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.cosmicCard)
                    .frame(width: size, height: size * 1.4)
                    .overlay(
                        Text(card.name)
                            .font(.system(size: 7))
                            .foregroundStyle(Color.cosmicText)
                    )
            }
        }
    }

    // MARK: - Logic

    private func startGame() {
        round = 0
        score = 0
        startRound()
    }

    private func startRound() {
        round += 1
        showError = false
        selectedAnswer = nil

        allCards = GameCard.buildPool(count: difficulty.cardCount)
        missingCard = nil
        displayedCards = []

        // Start memorize phase
        memorizeCountdown = difficulty.memorizeTime
        phase = .memorize

        startCountdown()
    }

    private func startCountdown() {
        guard memorizeCountdown > 0 else {
            removeMissingCard()
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            memorizeCountdown -= 1
            startCountdown()
        }
    }

    private func removeMissingCard() {
        let idx = Int.random(in: 0..<allCards.count)
        missingCard = allCards[idx]
        displayedCards = allCards.filter { $0.id != allCards[idx].id }.shuffled()
        phase = .guess
    }

    private func selectAnswer(_ card: GameCard) {
        selectedAnswer = card

        if card.matchID == missingCard?.matchID {
            // Correct!
            score += 1
            if round >= difficulty.roundsToWin {
                // Game won
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    gameManager.rewardWin(game: .missingCard, sphereManager: sphereManager)
                    showWin = true
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    startRound()
                }
            }
        } else {
            // Wrong
            showError = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                if round >= difficulty.roundsToWin {
                    // Game over but still won if score > 0... let's be generous
                    if score > 0 {
                        gameManager.rewardWin(game: .missingCard, sphereManager: sphereManager)
                    }
                    showWin = score > 0
                    if !showWin { phase = .menu }
                } else {
                    startRound()
                }
            }
        }
    }
}
