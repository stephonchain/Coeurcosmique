import SwiftUI

// MARK: - Rune Draw View

struct RuneDrawView: View {
    @ObservedObject var viewModel: AppViewModel
    @EnvironmentObject var storeManager: StoreManager
    @EnvironmentObject var creditManager: CreditManager
    @State private var selectedSpread: RuneSpreadType = .ceintureOrion
    @State private var question: String = ""
    @State private var isDrawing = false
    @State private var revealedCards: Set<Int> = []
    @State private var showReading = false
    @State private var showPaywall = false
    @State private var fullScreenRuneCard: RuneCard? = nil
    @FocusState private var isQuestionFocused: Bool

    // AI Interpretation
    @State private var aiInterpretation: String?
    @State private var isLoadingAI = false
    @State private var aiError: String?

    private var hasReachedFreeLimit: Bool {
        // Runes are Premium only
        !storeManager.isPremium
    }

    var body: some View {
        Group {
            if let reading = viewModel.currentRuneReading, showReading {
                runeReadingResultScreen(reading)
                    .transition(.opacity)
            } else {
                runeMenuScreen
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: showReading)
        .onAppear {
            if !storeManager.isPremium {
                showPaywall = true
            }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(storeManager: storeManager)
        }
        .overlay {
            if let card = fullScreenRuneCard {
                FullScreenCardView(content: .rune(card)) {
                    fullScreenRuneCard = nil
                }
            }
        }
    }

    // MARK: - Menu Screen

    private var runeMenuScreen: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Title
                VStack(spacing: 8) {
                    HStack(spacing: 10) {
                        Image(systemName: "hexagon.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.cosmicGold, .cosmicRose],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )

                        Text("Runes Cosmiques")
                            .font(.cosmicTitle(28))
                            .foregroundStyle(Color.cosmicText)
                    }

                    Text("Déchiffre le Code de l'Univers")
                        .font(.cosmicCaption())
                        .foregroundStyle(Color.cosmicTextSecondary)
                }
                .padding(.top, 16)

                // Premium badge
                premiumBadge

                // Spread selection
                runeSpreadSelection

                // Question input
                runeQuestionSection

                // Draw button
                runeDrawButton

                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Reading Result Screen

    private func runeReadingResultScreen(_ reading: RuneReading) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Spread title
                VStack(spacing: 8) {
                    Image(systemName: "hexagon.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.cosmicGold, .cosmicRose],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    Text(reading.spread.title)
                        .font(.cosmicTitle(26))
                        .foregroundStyle(Color.cosmicGold)

                    if let q = reading.question, !q.isEmpty {
                        Text("« \(q) »")
                            .font(.cosmicBody(14))
                            .foregroundStyle(Color.cosmicTextSecondary)
                            .italic()
                    }
                }
                .padding(.top, 16)

                // Cards
                ForEach(Array(reading.cards.enumerated()), id: \.element.id) { index, drawn in
                    let label = index < reading.spread.labels.count
                        ? reading.spread.labels[index]
                        : ""
                    runeCardView(drawn, label: label, index: index, total: reading.cards.count)
                }

                // AI Interpretation section
                if storeManager.isPremium {
                    runeAIInterpretationSection(reading)
                }

                // New draw button
                Button {
                    withAnimation {
                        showReading = false
                        viewModel.currentRuneReading = nil
                        revealedCards = []
                        question = ""
                        aiInterpretation = nil
                        aiError = nil
                    }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 15, weight: .medium))
                        Text("Nouveau tirage")
                            .font(.cosmicHeadline(16))
                    }
                    .foregroundStyle(Color.cosmicGold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.cosmicGold.opacity(0.5), lineWidth: 1.5)
                    )
                }
                .buttonStyle(.plain)

                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Premium Badge

    private var premiumBadge: some View {
        HStack(spacing: 8) {
            Image(systemName: "crown.fill")
                .font(.system(size: 12))
                .foregroundStyle(Color.cosmicGold)

            Text("Fonctionnalité Premium")
                .font(.cosmicCaption(11))
                .foregroundStyle(Color.cosmicTextSecondary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 7)
        .background(
            Capsule()
                .fill(Color.cosmicGold.opacity(0.12))
                .overlay(
                    Capsule()
                        .strokeBorder(Color.cosmicGold.opacity(0.3), lineWidth: 1)
                )
        )
    }

    // MARK: - Spread Selection

    private var runeSpreadSelection: some View {
        VStack(spacing: 12) {
            ForEach(RuneSpreadType.allCases) { spread in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        selectedSpread = spread
                    }
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: spread.icon)
                            .font(.system(size: 20))
                            .foregroundStyle(
                                selectedSpread == spread ? Color.cosmicGold : Color.cosmicTextSecondary
                            )
                            .frame(width: 32)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(spread.title)
                                .font(.cosmicBody(15))
                                .foregroundStyle(
                                    selectedSpread == spread ? Color.cosmicText : Color.cosmicTextSecondary
                                )

                            Text(spread.subtitle)
                                .font(.cosmicCaption(11))
                                .foregroundStyle(Color.cosmicTextSecondary.opacity(0.7))
                        }

                        Spacer()

                        Text("\(spread.cardCount) rune\(spread.cardCount > 1 ? "s" : "")")
                            .font(.cosmicCaption(11))
                            .foregroundStyle(Color.cosmicTextSecondary)

                        if selectedSpread == spread {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundStyle(Color.cosmicGold)
                        }
                    }
                    .padding(14)
                    .cosmicCard(cornerRadius: 14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(
                                selectedSpread == spread
                                    ? Color.cosmicGold.opacity(0.4)
                                    : Color.clear,
                                lineWidth: 1
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Question

    private var runeQuestionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ton intention runique (optionnel)")
                .font(.cosmicCaption())
                .foregroundStyle(Color.cosmicTextSecondary)

            TextField("Quelle fréquence souhaites-tu capter ?", text: $question)
                .font(.cosmicBody(15))
                .foregroundStyle(Color.cosmicText)
                .tint(Color.cosmicGold)
                .focused($isQuestionFocused)
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.cosmicCard)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.white.opacity(0.06), lineWidth: 0.5)
                        )
                )
        }
    }

    // MARK: - Draw Button

    private var runeDrawButton: some View {
        Button {
            if hasReachedFreeLimit {
                showPaywall = true
            } else {
                performRuneDraw()
            }
        } label: {
            HStack(spacing: 10) {
                if isDrawing {
                    ProgressView()
                        .tint(Color.white)
                } else if hasReachedFreeLimit {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 16, weight: .medium))
                } else {
                    Image(systemName: "hexagon.fill")
                        .font(.system(size: 16, weight: .medium))
                }

                Text(isDrawing
                     ? "Canalisation en cours..."
                     : hasReachedFreeLimit
                        ? "Activer Premium"
                        : "Tirer les runes")
                    .font(.cosmicHeadline(16))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [.cosmicGold, .cosmicRose],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .glow(.cosmicGold, radius: isDrawing ? 4 : 8)
        }
        .buttonStyle(.plain)
        .disabled(isDrawing)
    }

    // MARK: - Card View

    private func runeCardView(
        _ drawn: DrawnRuneCard,
        label: String,
        index: Int,
        total: Int
    ) -> some View {
        VStack(spacing: 16) {
            if let card = drawn.resolve(from: RuneDeck.allCards) {
                let isRevealed = revealedCards.contains(index)

                HStack {
                    Text(label)
                        .font(.cosmicCaption())
                        .foregroundStyle(card.aett.color)
                        .textCase(.uppercase)
                        .kerning(2)

                    Spacer()

                    if total > 1 {
                        Text("\(index + 1)/\(total)")
                            .font(.cosmicCaption(11))
                            .foregroundStyle(Color.cosmicTextSecondary)
                    }
                }

                FlippableRuneCard(
                    card: card,
                    isFlipped: Binding(
                        get: { isRevealed },
                        set: { if $0 { revealedCards.insert(index) } else { revealedCards.remove(index) } }
                    ),
                    size: total == 1 ? .large : .medium,
                    onFullScreen: { fullScreenRuneCard = card }
                )

                if isRevealed {
                    runeInterpretationView(card: card)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
        .padding(16)
        .cosmicCard()
    }

    private func runeInterpretationView(card: RuneCard) -> some View {
        VStack(spacing: 12) {
            // Card name and letter
            HStack(spacing: 8) {
                Image(systemName: card.aett.icon)
                    .font(.system(size: 16))
                    .foregroundStyle(card.aett.color)

                Text("\(card.number). \(card.name) (\(card.letter))")
                    .font(.cosmicHeadline(16))
                    .foregroundStyle(Color.cosmicText)
            }

            // Aett indicator
            Text(card.aett.title)
                .font(.cosmicCaption(10))
                .foregroundStyle(card.aett.color)
                .textCase(.uppercase)
                .kerning(1.5)

            // Vision Cosmique title
            HStack(spacing: 6) {
                Text(card.visionCosmique)
                    .font(.cosmicCaption(10))
                    .foregroundStyle(card.aett.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(
                        Capsule().fill(card.aett.color.opacity(0.12))
                    )
            }

            // Traditional concept
            Text(card.conceptTraditionnel)
                .font(.cosmicCaption(11))
                .foregroundStyle(Color.cosmicTextSecondary.opacity(0.7))

            // Message
            Text(card.message)
                .font(.cosmicBody(13))
                .foregroundStyle(Color.cosmicTextSecondary.opacity(0.9))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .italic()
                .padding(.vertical, 8)

            // Extended cosmic vision (premium)
            if storeManager.isPremium {
                VStack(spacing: 8) {
                    Divider()
                        .background(card.aett.color.opacity(0.2))

                    Text(card.visionCosmiqueDescription)
                        .font(.cosmicBody(13))
                        .foregroundStyle(Color.cosmicText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                }
            }
        }
    }

    // MARK: - AI Interpretation

    private func runeAIInterpretationSection(_ reading: RuneReading) -> some View {
        VStack(spacing: 16) {
            if let interpretation = aiInterpretation {
                // Display AI result
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.cosmicGold)

                        Text("Déchiffrage Cosmique IA")
                            .font(.cosmicHeadline(16))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.cosmicGold, .cosmicRose],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }

                    Text(interpretation)
                        .font(.cosmicBody(14))
                        .foregroundStyle(Color.cosmicText.opacity(0.9))
                        .multilineTextAlignment(.leading)
                        .lineSpacing(5)
                }
                .padding(20)
                .cosmicCard()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(
                            LinearGradient(
                                colors: [Color.cosmicGold.opacity(0.3), Color.cosmicRose.opacity(0.15)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
            } else {
                // Request button
                VStack(spacing: 10) {
                    Button {
                        requestRuneAIInterpretation(reading)
                    } label: {
                        HStack(spacing: 10) {
                            if isLoadingAI {
                                ProgressView()
                                    .tint(Color.white)
                            } else {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 16, weight: .medium))
                            }

                            Text(isLoadingAI ? "Déchiffrage en cours..." : "Interpretation IA")
                                .font(.cosmicHeadline(15))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(
                                    LinearGradient(
                                        colors: [.cosmicGold.opacity(0.8), .cosmicRose.opacity(0.6)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(isLoadingAI || !creditManager.hasCredits)

                    // Credit indicator
                    HStack(spacing: 6) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(Color.cosmicGold)

                        if creditManager.hasCredits {
                            Text("\(creditManager.credits) credit\(creditManager.credits > 1 ? "s" : "") restant\(creditManager.credits > 1 ? "s" : "") aujourd'hui")
                                .font(.cosmicCaption(11))
                                .foregroundStyle(Color.cosmicTextSecondary)
                        } else {
                            Text("Plus de credits pour aujourd'hui")
                                .font(.cosmicCaption(11))
                                .foregroundStyle(Color.cosmicRose.opacity(0.8))
                        }
                    }

                    if let error = aiError {
                        Text(error)
                            .font(.cosmicCaption(11))
                            .foregroundStyle(Color.cosmicRose)
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
    }

    private func requestRuneAIInterpretation(_ reading: RuneReading) {
        guard creditManager.hasCredits else { return }
        isLoadingAI = true
        aiError = nil

        Task {
            do {
                let result = try await AIInterpretationService.shared.interpretRune(
                    reading: reading,
                    deck: RuneDeck.allCards
                )
                let _ = creditManager.consumeCredit()
                withAnimation {
                    aiInterpretation = result
                }
            } catch {
                aiError = error.localizedDescription
            }
            isLoadingAI = false
        }
    }

    // MARK: - Actions

    private func performRuneDraw() {
        isQuestionFocused = false
        isDrawing = true
        revealedCards = []

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            viewModel.performRuneReading(
                spread: selectedSpread,
                question: question.isEmpty ? nil : question
            )
            isDrawing = false
            withAnimation {
                showReading = true
            }

            // Auto-reveal cards sequentially
            if let reading = viewModel.currentRuneReading {
                for i in 0..<reading.cards.count {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.6 + 0.4) {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            _ = revealedCards.insert(i)
                        }
                    }
                }
            }
        }
    }
}
