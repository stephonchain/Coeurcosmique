import SwiftUI

struct DrawView: View {
    @ObservedObject var viewModel: AppViewModel
    @EnvironmentObject var storeManager: StoreManager
    @State private var selectedSpread: TarotSpreadType = .pastPresentFuture
    @State private var question: String = ""
    @State private var isDrawing = false
    @State private var revealedCards: Set<Int> = []
    @State private var showReading = false
    @State private var showPaywall = false
    @FocusState private var isQuestionFocused: Bool

    private var hasReachedFreeLimit: Bool {
        !storeManager.isPremium && viewModel.todayDrawCount >= AppViewModel.freeDailyDrawLimit
    }

    var body: some View {
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

                // Reading display
                if let reading = viewModel.currentReading {
                    readingSection(reading)
                }

                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            viewModel.loadTodayDrawCount()
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(storeManager: storeManager)
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

    // MARK: - Reading Display

    private func readingSection(_ reading: TarotReading) -> some View {
        VStack(spacing: 24) {
            // Divider
            HStack(spacing: 12) {
                Rectangle()
                    .fill(Color.cosmicDivider)
                    .frame(height: 1)
                Text("✦")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.cosmicGold)
                Rectangle()
                    .fill(Color.cosmicDivider)
                    .frame(height: 1)
            }

            // Spread title
            Text(reading.spread.title)
                .font(.cosmicHeadline(18))
                .foregroundStyle(Color.cosmicGold)

            if let q = reading.question, !q.isEmpty {
                Text("« \(q) »")
                    .font(.cosmicBody(14))
                    .foregroundStyle(Color.cosmicTextSecondary)
                    .italic()
            }

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
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
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
                    size: .large
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
                    size: .medium
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

    // MARK: - Actions

    private func performDraw() {
        isQuestionFocused = false
        isDrawing = true
        revealedCards = []
        showReading = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            viewModel.performReading(
                spread: selectedSpread,
                question: question.isEmpty ? nil : question
            )
            isDrawing = false
            showReading = true

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
