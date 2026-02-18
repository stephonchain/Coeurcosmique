import SwiftUI

struct DrawView: View {
    @ObservedObject var viewModel: AppViewModel
    @EnvironmentObject var storeManager: StoreManager
    @EnvironmentObject var creditManager: CreditManager
    @State private var selectedSpread: TarotSpreadType = .pastPresentFuture
    @State private var question: String = ""
    @State private var isDrawing = false
    @State private var revealedCards: Set<Int> = []
    @State private var showReading = false
    @State private var showPaywall = false
    @State private var fullScreenTarotCard: TarotCard? = nil
    @State private var fullScreenIsReversed = false
    @FocusState private var isQuestionFocused: Bool

    // AI Interpretation
    @State private var aiInterpretation: String?
    @State private var isLoadingAI = false
    @State private var aiError: String?

    private var hasReachedFreeLimit: Bool {
        !storeManager.isPremium && viewModel.todayDrawCount >= AppViewModel.freeDailyDrawLimit
    }

    var body: some View {
        Group {
            if let reading = viewModel.currentReading, showReading {
                readingResultScreen(reading)
                    .transition(.opacity)
            } else {
                drawMenuScreen
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: showReading)
        .onAppear {
            viewModel.loadTodayDrawCount()
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(storeManager: storeManager)
        }
        .overlay {
            if let card = fullScreenTarotCard {
                FullScreenCardView(content: .tarot(card, isReversed: fullScreenIsReversed)) {
                    fullScreenTarotCard = nil
                }
            }
        }
    }

    // MARK: - Draw Menu Screen

    private var drawMenuScreen: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Title
                VStack(spacing: 6) {
                    Text("Tirage")
                        .font(.cosmicTitle(28))
                        .foregroundStyle(Color.cosmicText)

                    Text("Choisis ton type de lecture")
                        .font(.cosmicCaption())
                        .foregroundStyle(Color.cosmicTextSecondary)
                }
                .padding(.top, 16)

                // Free limit banner
                if hasReachedFreeLimit {
                    freeLimitBanner
                }

                // Spread selection
                spreadSelectionSection

                // Question input
                questionSection

                // Draw button
                drawButton

                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Reading Result Screen

    private func readingResultScreen(_ reading: TarotReading) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Spread title
                VStack(spacing: 8) {
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
                if reading.cards.count == 1 {
                    singleCardView(reading.cards[0], label: reading.spread.labels[0], index: 0)
                } else {
                    ForEach(Array(reading.cards.enumerated()), id: \.element.id) { index, drawn in
                        let label = index < reading.spread.labels.count
                            ? reading.spread.labels[index]
                            : ""
                        cardReadingView(drawn, label: label, index: index)
                    }
                }

                // AI Interpretation section
                if storeManager.isPremium {
                    tarotAIInterpretationSection(reading)
                }

                // New draw button
                Button {
                    withAnimation {
                        showReading = false
                        viewModel.currentReading = nil
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

    // MARK: - Free Limit Banner

    private var freeLimitBanner: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.cosmicGold)

                Text("Tu as utilisé ton tirage gratuit du jour")
                    .font(.cosmicBody(14))
                    .foregroundStyle(Color.cosmicText)
            }

            Text("Passe en Premium pour des tirages illimités")
                .font(.cosmicCaption(12))
                .foregroundStyle(Color.cosmicTextSecondary)

            Button {
                showPaywall = true
            } label: {
                Text("Voir les offres")
                    .font(.cosmicHeadline(13))
                    .foregroundStyle(Color.cosmicBackground)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(
                        Capsule().fill(LinearGradient.cosmicGoldGradient)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .cosmicCard(cornerRadius: 14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(Color.cosmicGold.opacity(0.3), lineWidth: 1)
        )
    }

    // MARK: - Spread Selection

    private var spreadSelectionSection: some View {
        VStack(spacing: 12) {
            ForEach(TarotSpreadType.allCases) { spread in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        selectedSpread = spread
                    }
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: spread.icon)
                            .font(.system(size: 18))
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

                        Text("\(spread.cardCount) carte\(spread.cardCount > 1 ? "s" : "")")
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

    private var questionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ta question (optionnel)")
                .font(.cosmicCaption())
                .foregroundStyle(Color.cosmicTextSecondary)

            TextField("Qu'est-ce qui occupe ton esprit ?", text: $question)
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

    private var drawButton: some View {
        Button {
            if hasReachedFreeLimit {
                showPaywall = true
            } else {
                performDraw()
            }
        } label: {
            HStack(spacing: 10) {
                if isDrawing {
                    ProgressView()
                        .tint(Color.cosmicBackground)
                } else if hasReachedFreeLimit {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 16, weight: .medium))
                } else {
                    Image(systemName: "sparkles")
                        .font(.system(size: 16, weight: .medium))
                }

                Text(isDrawing
                     ? "Consultation en cours..."
                     : hasReachedFreeLimit
                        ? "Débloquer les tirages illimités"
                        : "Tirer les cartes")
                    .font(.cosmicHeadline(16))
            }
            .foregroundStyle(Color.cosmicBackground)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient.cosmicGoldGradient)
            )
            .glow(.cosmicGold, radius: isDrawing ? 4 : 8)
        }
        .buttonStyle(.plain)
        .disabled(isDrawing)
    }

    private func singleCardView(_ drawn: DrawnCard, label: String, index: Int) -> some View {
        VStack(spacing: 16) {
            if let card = drawn.resolve(from: viewModel.deck) {
                let isRevealed = revealedCards.contains(index)

                Text(label)
                    .font(.cosmicCaption())
                    .foregroundStyle(Color.cosmicPurple)
                    .textCase(.uppercase)
                    .kerning(2)

                FlippableTarotCard(
                    card: card,
                    isReversed: drawn.isReversed,
                    isFlipped: Binding(
                        get: { isRevealed },
                        set: { if $0 { revealedCards.insert(index) } else { revealedCards.remove(index) } }
                    ),
                    size: .large,
                    onFullScreen: {
                        fullScreenTarotCard = card
                        fullScreenIsReversed = drawn.isReversed
                    }
                )

                if isRevealed {
                    cardInterpretationView(card: card, drawn: drawn)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
        .padding(20)
        .cosmicCard()
    }

    private func cardReadingView(_ drawn: DrawnCard, label: String, index: Int) -> some View {
        VStack(spacing: 16) {
            if let card = drawn.resolve(from: viewModel.deck) {
                let isRevealed = revealedCards.contains(index)

                HStack {
                    Text(label)
                        .font(.cosmicCaption())
                        .foregroundStyle(Color.cosmicPurple)
                        .textCase(.uppercase)
                        .kerning(2)

                    Spacer()

                    Text("\(index + 1)/\(viewModel.currentReading?.cards.count ?? 0)")
                        .font(.cosmicCaption(11))
                        .foregroundStyle(Color.cosmicTextSecondary)
                }

                FlippableTarotCard(
                    card: card,
                    isReversed: drawn.isReversed,
                    isFlipped: Binding(
                        get: { isRevealed },
                        set: { if $0 { revealedCards.insert(index) } else { revealedCards.remove(index) } }
                    ),
                    size: .medium,
                    onFullScreen: {
                        fullScreenTarotCard = card
                        fullScreenIsReversed = drawn.isReversed
                    }
                )

                if isRevealed {
                    cardInterpretationView(card: card, drawn: drawn)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
        .padding(16)
        .cosmicCard()
    }

    private func cardInterpretationView(card: TarotCard, drawn: DrawnCard) -> some View {
        VStack(spacing: 10) {
            Text(card.name)
                .font(.cosmicHeadline(16))
                .foregroundStyle(Color.cosmicText)

            if drawn.isReversed {
                Text("Inversée")
                    .font(.cosmicCaption(11))
                    .foregroundStyle(Color.cosmicRose)
            }

            Text(drawn.interpretation(from: viewModel.deck))
                .font(.cosmicBody(14))
                .foregroundStyle(Color.cosmicTextSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)

            HStack(spacing: 6) {
                ForEach(card.keywords, id: \.self) { keyword in
                    Text(keyword)
                        .font(.cosmicCaption(10))
                        .foregroundStyle(Color.cosmicPurple)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            Capsule().fill(Color.cosmicPurple.opacity(0.12))
                        )
                }
            }
        }
    }

    // MARK: - AI Interpretation

    private func tarotAIInterpretationSection(_ reading: TarotReading) -> some View {
        VStack(spacing: 16) {
            if let interpretation = aiInterpretation {
                // Display AI result
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.cosmicGold)

                        Text("Synthese IA du Tirage")
                            .font(.cosmicHeadline(16))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.cosmicGold, .cosmicPurple],
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
                                colors: [Color.cosmicGold.opacity(0.3), Color.cosmicPurple.opacity(0.15)],
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
                        requestTarotAIInterpretation(reading)
                    } label: {
                        HStack(spacing: 10) {
                            if isLoadingAI {
                                ProgressView()
                                    .tint(Color.white)
                            } else {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 16, weight: .medium))
                            }

                            Text(isLoadingAI ? "Analyse en cours..." : "Interpretation IA")
                                .font(.cosmicHeadline(15))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(
                                    LinearGradient(
                                        colors: [.cosmicGold.opacity(0.8), .cosmicPurple.opacity(0.6)],
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

    private func requestTarotAIInterpretation(_ reading: TarotReading) {
        guard creditManager.hasCredits else { return }
        isLoadingAI = true
        aiError = nil

        Task {
            do {
                let result = try await AIInterpretationService.shared.interpretTarot(
                    reading: reading,
                    deck: viewModel.deck
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

    private func performDraw() {
        isQuestionFocused = false
        isDrawing = true
        revealedCards = []

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            viewModel.performReading(
                spread: selectedSpread,
                question: question.isEmpty ? nil : question
            )
            isDrawing = false
            withAnimation {
                showReading = true
            }

            // Auto-reveal cards sequentially
            if let reading = viewModel.currentReading {
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
