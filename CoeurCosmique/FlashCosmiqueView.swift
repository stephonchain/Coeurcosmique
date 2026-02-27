import SwiftUI

// MARK: - Flash Cosmique View

struct FlashCosmiqueView: View {
    let onDismiss: () -> Void

    @EnvironmentObject var collectionManager: CardCollectionManager
    @StateObject private var flashManager = FlashCardManager.shared

    @State private var selectedDeck: CollectibleDeck? = nil
    @State private var difficulty: FlashDifficulty = .medium
    @State private var phase: FlashPhase = .deckSelection
    @State private var quizItems: [FlashQuizItem] = []
    @State private var currentIndex: Int = 0
    @State private var choices: [FlashQuizItem] = []
    @State private var selectedChoice: FlashQuizItem? = nil
    @State private var showResult: Bool = false
    @State private var isCorrect: Bool = false
    @State private var sessionCorrect: Int = 0
    @State private var sessionTotal: Int = 0
    @State private var newlyMastered: [(CollectibleDeck, Int, String)] = [] // deck, number, name
    @State private var showSessionEnd = false

    enum FlashPhase {
        case deckSelection
        case difficultySelection
        case quiz
        case sessionSummary
    }

    enum FlashDifficulty: String, CaseIterable {
        case easy, medium, hard

        var label: String {
            switch self {
            case .easy: return "Facile"
            case .medium: return "Normal"
            case .hard: return "Difficile"
            }
        }

        var choiceCount: Int {
            switch self {
            case .easy: return 3
            case .medium: return 5
            case .hard: return 7
            }
        }

        var detail: String {
            switch self {
            case .easy: return "3 choix"
            case .medium: return "5 choix"
            case .hard: return "7 choix"
            }
        }
    }

    var body: some View {
        ZStack {
            Color.cosmicBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                gameHeader

                if phase == .deckSelection {
                    deckSelectionView
                } else if phase == .difficultySelection {
                    difficultySelectionView
                } else if phase == .quiz {
                    quizView
                } else {
                    sessionSummaryView
                }
            }

            // Quiz result popup overlay
            if phase == .quiz, showResult, currentIndex < quizItems.count {
                VStack {
                    Spacer()
                    resultPopup(correctItem: quizItems[currentIndex])
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
    }

    // MARK: - Header

    private var gameHeader: some View {
        HStack {
            Button {
                switch phase {
                case .deckSelection:
                    onDismiss()
                case .difficultySelection:
                    phase = .deckSelection
                case .quiz:
                    phase = .sessionSummary
                case .sessionSummary:
                    phase = .deckSelection
                }
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

            Text("Flash Cosmique")
                .font(.cosmicHeadline(18))
                .foregroundStyle(Color.cosmicText)

            Spacer()

            // Progress indicator when in quiz
            if phase == .quiz && !quizItems.isEmpty {
                Text("\(currentIndex + 1)/\(quizItems.count)")
                    .font(.cosmicCaption(12))
                    .foregroundStyle(Color.cosmicGold)
            } else {
                Color.clear.frame(width: 40)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }

    // MARK: - Deck Selection

    private var deckSelectionView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                Text("Maitrise une carte pour l'obtenir en GOLD !")
                    .font(.cosmicBody(13))
                    .foregroundStyle(Color.cosmicTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .padding(.top, 8)

                // Deck cards
                VStack(spacing: 14) {
                    ForEach(CollectibleDeck.allCases, id: \.rawValue) { deck in
                        deckCard(deck: deck)
                    }
                }
                .padding(.horizontal, 20)

                // SRS legend compact
                HStack(spacing: 12) {
                    srsLevelBadge("J0", color: .cosmicTextSecondary)
                    srsLevelBadge("J1", color: .cyan)
                    srsLevelBadge("J3", color: .blue)
                    srsLevelBadge("J7", color: .cosmicPurple)
                    srsLevelBadge("J31", color: .cosmicGold)
                }
                .padding(.bottom, 20)
            }
        }
    }

    private func deckCard(deck: CollectibleDeck) -> some View {
        let memorized = flashManager.memorizedCount(deck: deck)
        let inProgress = flashManager.inProgressCount(deck: deck)
        let dueCount = flashManager.cardsDueForReview(deck: deck).count
        let total = deck.totalCards
        let isMastered = memorized == total

        return Button {
            selectedDeck = deck
            phase = .difficultySelection
        } label: {
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            Text(deck.title)
                                .font(.cosmicHeadline(16))
                                .foregroundStyle(Color.cosmicText)

                            if isMastered {
                                HStack(spacing: 4) {
                                    Image(systemName: "crown.fill")
                                        .font(.system(size: 10))
                                    Text("MAITRISE")
                                        .font(.system(size: 9, weight: .bold))
                                }
                                .foregroundStyle(Color.cosmicGold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Capsule().fill(Color.cosmicGold.opacity(0.2)))
                            }
                        }

                        Text("\(deck.totalCards) cartes")
                            .font(.cosmicCaption(12))
                            .foregroundStyle(Color.cosmicTextSecondary)
                    }

                    Spacer()

                    if dueCount > 0 {
                        VStack(spacing: 2) {
                            Text("\(dueCount)")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundStyle(Color.cosmicGold)
                            Text("a revoir")
                                .font(.cosmicCaption(9))
                                .foregroundStyle(Color.cosmicTextSecondary)
                        }
                    } else {
                        VStack(spacing: 2) {
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 18))
                                .foregroundStyle(.green)
                            Text("a jour")
                                .font(.cosmicCaption(9))
                                .foregroundStyle(.green)
                        }
                    }
                }

                // Progress bar
                ProgressView(value: Double(memorized), total: Double(total))
                    .tint(deck.accentColor)

                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Circle().fill(Color.green).frame(width: 6, height: 6)
                        Text("\(memorized) maitrisees")
                            .font(.cosmicCaption(10))
                            .foregroundStyle(Color.cosmicTextSecondary)
                    }
                    HStack(spacing: 4) {
                        Circle().fill(Color.cyan).frame(width: 6, height: 6)
                        Text("\(inProgress) en cours")
                            .font(.cosmicCaption(10))
                            .foregroundStyle(Color.cosmicTextSecondary)
                    }
                    Spacer()
                }
            }
            .padding(16)
            .cosmicCard(cornerRadius: 14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(deck.accentColor.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func srsLevelBadge(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Capsule().fill(color.opacity(0.15)))
    }

    // MARK: - Difficulty Selection

    private var difficultySelectionView: some View {
        VStack(spacing: 30) {
            Spacer()

            if let deck = selectedDeck {
                let dueCount = flashManager.cardsDueForReview(deck: deck).count

                Text(deck.title)
                    .font(.cosmicTitle(22))
                    .foregroundStyle(deck.accentColor)

                if dueCount > 0 {
                    Text("\(dueCount) cartes a revoir aujourd'hui")
                        .font(.cosmicBody(14))
                        .foregroundStyle(Color.cosmicTextSecondary)
                } else {
                    Text("Aucune carte a revoir.\nTu peux reviser les nouvelles cartes !")
                        .font(.cosmicBody(14))
                        .foregroundStyle(Color.cosmicTextSecondary)
                        .multilineTextAlignment(.center)
                }
            }

            VStack(spacing: 14) {
                ForEach(FlashDifficulty.allCases, id: \.rawValue) { diff in
                    Button {
                        difficulty = diff
                        startSession()
                    } label: {
                        HStack {
                            Text(diff.label)
                                .font(.cosmicHeadline(16))
                                .foregroundStyle(.white)
                            Spacer()
                            Text(diff.detail)
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
                                        .strokeBorder(Color.cosmicGold.opacity(0.3), lineWidth: 1)
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

    // MARK: - Quiz View

    private var quizView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                if currentIndex < quizItems.count {
                    let item = quizItems[currentIndex]

                    // SRS level badge
                    HStack(spacing: 8) {
                        let lvl = flashManager.level(deck: item.deck, number: item.number)
                        let entry = FlashCardEntry(deckType: "", cardNumber: 0, level: lvl, nextReviewDate: Date())
                        Text("Niveau: \(entry.levelLabel)")
                            .font(.cosmicCaption(11))
                            .foregroundStyle(entry.levelColor)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(entry.levelColor.opacity(0.15)))

                        Spacer()

                        Text("Score: \(sessionCorrect)/\(sessionTotal)")
                            .font(.cosmicCaption(12))
                            .foregroundStyle(Color.cosmicGold)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    // Description card
                    VStack(spacing: 12) {
                        Text("Quelle carte correspond ?")
                            .font(.cosmicHeadline(15))
                            .foregroundStyle(Color.cosmicGold)

                        // Keywords
                        if !item.keywords.isEmpty {
                            HStack(spacing: 6) {
                                ForEach(item.keywords.prefix(3), id: \.self) { kw in
                                    Text(kw)
                                        .font(.cosmicCaption(10))
                                        .foregroundStyle(Color.cosmicPurple)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(Capsule().fill(Color.cosmicPurple.opacity(0.12)))
                                }
                            }
                        }

                        // Description (card name redacted until answer)
                        Text(showResult ? item.description : redactDescription(item.description, hiding: item.name))
                            .font(.cosmicBody(14))
                            .foregroundStyle(Color.cosmicText.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                            .animation(.easeInOut(duration: 0.3), value: showResult)
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .cosmicCard(cornerRadius: 16)
                    .padding(.horizontal, 20)

                    // Choices
                    let columns = difficulty == .hard
                        ? [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]
                        : [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]

                    // Calculate responsive card size
                    let colCount = difficulty == .hard ? 3 : 2
                    let cardWidth = (UIScreen.main.bounds.width - 40 - CGFloat(colCount - 1) * 10) / CGFloat(colCount)
                    let cardHeight = cardWidth * 1.4

                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(choices, id: \.number) { choice in
                            choiceCard(choice: choice, correctItem: item, width: cardWidth, height: cardHeight)
                        }
                    }
                    .padding(.horizontal, 20)

                    // Extra space at bottom for popup overlay
                    Spacer(minLength: showResult ? 160 : 40)
                }
            }
        }
    }

    private func choiceCard(choice: FlashQuizItem, correctItem: FlashQuizItem, width: CGFloat, height: CGFloat) -> some View {
        let isSelected = selectedChoice?.number == choice.number && selectedChoice?.deck == choice.deck
        let isAnswer = choice.number == correctItem.number && choice.deck == correctItem.deck
        let borderColor: Color = {
            guard showResult else {
                return isSelected ? Color.cosmicGold : Color.clear
            }
            if isAnswer { return .green }
            if isSelected && !isAnswer { return .red }
            return Color.clear
        }()

        return Button {
            guard !showResult else { return }
            selectChoice(choice)
        } label: {
            VStack(spacing: 6) {
                ZStack {
                    if UIImage(named: choice.imageName) != nil {
                        Image(choice.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: width, height: height)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.cosmicCard)
                            .frame(width: width, height: height)
                            .overlay(
                                Text(choice.name)
                                    .font(.cosmicCaption(10))
                                    .foregroundStyle(Color.cosmicText)
                                    .multilineTextAlignment(.center)
                                    .padding(4)
                            )
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(borderColor, lineWidth: 3)
                        .frame(width: width, height: height)
                )

                Text(choice.name)
                    .font(.cosmicCaption(10))
                    .foregroundStyle(Color.cosmicText)
                    .lineLimit(1)
            }
        }
        .buttonStyle(.plain)
        .disabled(showResult)
    }

    private func resultPopup(correctItem: FlashQuizItem) -> some View {
        VStack(spacing: 10) {
            // Drag indicator
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.cosmicTextSecondary.opacity(0.4))
                .frame(width: 40, height: 4)

            if isCorrect {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.system(size: 22))
                    Text("Correct !")
                        .font(.cosmicHeadline(16))
                        .foregroundStyle(.green)

                    Spacer()

                    let newLevel = flashManager.level(deck: correctItem.deck, number: correctItem.number)
                    if newLevel >= FlashCardManager.maxLevel {
                        HStack(spacing: 4) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 10))
                            Text("GOLD")
                                .font(.system(size: 10, weight: .bold))
                        }
                        .foregroundStyle(Color.cosmicGold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color.cosmicGold.opacity(0.2)))
                    } else {
                        let entry = FlashCardEntry(deckType: "", cardNumber: 0, level: newLevel, nextReviewDate: Date())
                        Text(entry.levelLabel)
                            .font(.cosmicCaption(11))
                            .foregroundStyle(entry.levelColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(entry.levelColor.opacity(0.15)))
                    }
                }
            } else {
                HStack(spacing: 8) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.red)
                        .font(.system(size: 22))

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Incorrect")
                            .font(.cosmicHeadline(14))
                            .foregroundStyle(.red)
                        Text("C'etait : \(correctItem.name) — Retour a J0")
                            .font(.cosmicCaption(11))
                            .foregroundStyle(Color.cosmicTextSecondary)
                    }

                    Spacer()
                }
            }

            Button {
                advanceToNext()
            } label: {
                Text("Suivant")
                    .font(.cosmicHeadline(14))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
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
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.cosmicBackground)
                .shadow(color: .black.opacity(0.5), radius: 20, y: -5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .strokeBorder(isCorrect ? Color.green.opacity(0.3) : Color.red.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, 12)
        .padding(.bottom, 8)
    }

    // MARK: - Helpers

    private func redactDescription(_ text: String, hiding name: String) -> String {
        let redacted = String(repeating: "●", count: min(name.count, 10))
        return text.replacingOccurrences(of: name, with: redacted, options: [.caseInsensitive])
    }

    // MARK: - Session Summary

    private var sessionSummaryView: some View {
        VStack(spacing: 16) {
            Text("Session terminee !")
                .font(.cosmicTitle(22))
                .foregroundStyle(Color.cosmicGold)
                .padding(.top, 10)

            // Stats
            HStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text("\(sessionCorrect)")
                        .font(.cosmicHeadline(22))
                        .foregroundStyle(.green)
                    Text("Correctes")
                        .font(.cosmicCaption(10))
                        .foregroundStyle(Color.cosmicTextSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .cosmicCard(cornerRadius: 12)

                VStack(spacing: 4) {
                    Text("\(sessionTotal - sessionCorrect)")
                        .font(.cosmicHeadline(22))
                        .foregroundStyle(.red)
                    Text("Incorrectes")
                        .font(.cosmicCaption(10))
                        .foregroundStyle(Color.cosmicTextSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .cosmicCard(cornerRadius: 12)

                VStack(spacing: 4) {
                    Text("\(sessionTotal > 0 ? sessionCorrect * 100 / sessionTotal : 0)%")
                        .font(.cosmicHeadline(22))
                        .foregroundStyle(Color.cosmicGold)
                    Text("Precision")
                        .font(.cosmicCaption(10))
                        .foregroundStyle(Color.cosmicTextSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .cosmicCard(cornerRadius: 12)
            }
            .padding(.horizontal, 20)

            // Newly mastered cards
            if !newlyMastered.isEmpty {
                VStack(spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: "crown.fill")
                            .foregroundStyle(Color.cosmicGold)
                        Text("Cartes maitrisees !")
                            .font(.cosmicHeadline(14))
                            .foregroundStyle(Color.cosmicGold)
                    }

                    ForEach(newlyMastered, id: \.1) { (deck, number, name) in
                        HStack(spacing: 8) {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 10))
                                .foregroundStyle(Color.cosmicGold)
                            Text(name)
                                .font(.cosmicBody(13))
                                .foregroundStyle(Color.cosmicText)
                            Spacer()
                            Text("GOLD")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(Color.cosmicGold)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Capsule().fill(Color.cosmicGold.opacity(0.2)))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .cosmicCard(cornerRadius: 10)
                    }
                }
                .padding(.horizontal, 20)
            }

            // Deck progress
            if let deck = selectedDeck {
                VStack(spacing: 8) {
                    ProgressView(
                        value: Double(flashManager.memorizedCount(deck: deck)),
                        total: Double(deck.totalCards)
                    )
                    .tint(deck.accentColor)

                    Text("\(flashManager.memorizedCount(deck: deck))/\(deck.totalCards) cartes maitrisees — \(deck.title)")
                        .font(.cosmicCaption(11))
                        .foregroundStyle(Color.cosmicTextSecondary)

                    if flashManager.isDeckMastered(deck: deck) {
                        HStack(spacing: 6) {
                            Image(systemName: "sparkles")
                                .foregroundStyle(Color.cosmicGold)
                            Text("Oracle maitrise ! Toutes les cartes GOLD obtenues !")
                                .font(.cosmicCaption(11))
                                .foregroundStyle(Color.cosmicGold)
                        }
                    }
                }
                .padding(14)
                .cosmicCard(cornerRadius: 12)
                .padding(.horizontal, 20)
            }

            // Buttons
            VStack(spacing: 10) {
                if let deck = selectedDeck, flashManager.cardsDueForReview(deck: deck).count > 0 {
                    Button {
                        startSession()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.clockwise")
                            Text("Continuer la revision")
                                .font(.cosmicHeadline(14))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
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
                }

                Button {
                    phase = .deckSelection
                } label: {
                    Text("Choisir un autre oracle")
                        .font(.cosmicCaption(14))
                        .foregroundStyle(Color.cosmicTextSecondary)
                }
                .buttonStyle(.plain)

                Button {
                    onDismiss()
                } label: {
                    Text("Retour a l'accueil")
                        .font(.cosmicCaption(13))
                        .foregroundStyle(Color.cosmicTextSecondary.opacity(0.7))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 30)

            Spacer()
        }
    }

    // MARK: - Logic

    private func startSession() {
        guard let deck = selectedDeck else { return }

        sessionCorrect = 0
        sessionTotal = 0
        currentIndex = 0
        newlyMastered = []

        // Get cards due for review, limit session to 10 cards
        let due = flashManager.cardsDueForReview(deck: deck)
        let allDeckItems = FlashQuizItem.buildAll(deck: deck)

        var sessionItems: [FlashQuizItem] = []
        for (number, level) in due.prefix(10) {
            if let item = allDeckItems.first(where: { $0.number == number }) {
                sessionItems.append(FlashQuizItem(
                    deck: item.deck,
                    number: item.number,
                    name: item.name,
                    imageName: item.imageName,
                    description: item.description,
                    keywords: item.keywords,
                    currentLevel: level
                ))
            }
        }

        if sessionItems.isEmpty {
            // No cards due — offer new cards
            let learned = Set(flashManager.entries.keys)
            for item in allDeckItems {
                let key = FlashCardManager.cardKey(deck: item.deck, number: item.number)
                if !learned.contains(key) {
                    sessionItems.append(item)
                }
                if sessionItems.count >= 10 { break }
            }
        }

        guard !sessionItems.isEmpty else {
            phase = .sessionSummary
            return
        }

        quizItems = sessionItems.shuffled()
        currentIndex = 0
        showResult = false
        selectedChoice = nil
        buildChoices()
        phase = .quiz
    }

    private func buildChoices() {
        guard currentIndex < quizItems.count, let deck = selectedDeck else { return }
        let correctItem = quizItems[currentIndex]
        let allDeckItems = FlashQuizItem.buildAll(deck: deck)

        // Pick random wrong answers
        var pool = allDeckItems.filter { $0.number != correctItem.number }
        pool.shuffle()
        let wrongChoices = Array(pool.prefix(difficulty.choiceCount - 1))

        choices = (wrongChoices + [correctItem]).shuffled()
    }

    private func selectChoice(_ choice: FlashQuizItem) {
        guard currentIndex < quizItems.count else { return }
        let correctItem = quizItems[currentIndex]
        selectedChoice = choice
        sessionTotal += 1

        let correct = choice.number == correctItem.number && choice.deck == correctItem.deck
        isCorrect = correct

        if correct {
            sessionCorrect += 1
            let wasMastered = flashManager.isMemorized(deck: correctItem.deck, number: correctItem.number)
            flashManager.markCorrect(deck: correctItem.deck, number: correctItem.number)

            // Check if just became mastered → award GOLD card
            if !wasMastered && flashManager.isMemorized(deck: correctItem.deck, number: correctItem.number) {
                let _ = collectionManager.addCard(deck: correctItem.deck, number: correctItem.number, rarity: .golden)
                newlyMastered.append((correctItem.deck, correctItem.number, correctItem.name))
            }
        } else {
            flashManager.markWrong(deck: correctItem.deck, number: correctItem.number)
        }

        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            showResult = true
        }
    }

    private func advanceToNext() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
            showResult = false
        }
        selectedChoice = nil
        currentIndex += 1

        if currentIndex >= quizItems.count {
            phase = .sessionSummary
        } else {
            buildChoices()
        }
    }
}
