import SwiftUI

// MARK: - Oracle Spread Types

enum OracleSpreadType: String, CaseIterable, Codable, Identifiable {
    case singleGuidance
    case threeCards
    case loveReading

    var id: String { rawValue }

    var cardCount: Int {
        switch self {
        case .singleGuidance: return 1
        case .threeCards: return 3
        case .loveReading: return 3
        }
    }

    var title: String {
        switch self {
        case .singleGuidance: return "Message du Cœur"
        case .threeCards: return "Corps · Cœur · Âme"
        case .loveReading: return "Guidance Amoureuse"
        }
    }

    var subtitle: String {
        switch self {
        case .singleGuidance: return "Un message cosmique pour toi"
        case .threeCards: return "Éclaire chaque dimension de ton être"
        case .loveReading: return "Guidance pour tes relations"
        }
    }

    var labels: [String] {
        switch self {
        case .singleGuidance: return ["Message du Cœur"]
        case .threeCards: return ["Corps", "Cœur", "Âme"]
        case .loveReading: return ["Toi", "L'autre", "Le lien"]
        }
    }

    var icon: String {
        switch self {
        case .singleGuidance: return "heart.fill"
        case .threeCards: return "sparkles"
        case .loveReading: return "heart.circle.fill"
        }
    }
}

// MARK: - Oracle Reading

struct OracleReading: Equatable, Identifiable, Codable {
    let id: UUID
    let spread: OracleSpreadType
    let cards: [DrawnOracleCard]
    let generatedAt: Date
    let question: String?

    init(
        id: UUID = UUID(),
        spread: OracleSpreadType,
        cards: [DrawnOracleCard],
        generatedAt: Date = Date(),
        question: String? = nil
    ) {
        self.id = id
        self.spread = spread
        self.cards = cards
        self.generatedAt = generatedAt
        self.question = question
    }
}

// MARK: - Oracle Draw View

struct OracleDrawView: View {
    @ObservedObject var viewModel: AppViewModel
    @EnvironmentObject var storeManager: StoreManager
    @State private var selectedSpread: OracleSpreadType = .singleGuidance
    @State private var question: String = ""
    @State private var isDrawing = false
    @State private var revealedCards: Set<Int> = []
    @State private var showReading = false
    @State private var showPaywall = false
    @State private var fullScreenOracleCard: OracleCard? = nil
    @FocusState private var isQuestionFocused: Bool

    private var hasReachedFreeLimit: Bool {
        !storeManager.isPremium && viewModel.todayOracleDrawCount >= AppViewModel.freeOracleDailyLimit
    }

    var body: some View {
        Group {
            if let reading = viewModel.currentOracleReading, showReading {
                oracleReadingResultScreen(reading)
                    .transition(.opacity)
            } else {
                oracleMenuScreen
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: showReading)
        .onAppear {
            viewModel.loadTodayOracleDrawCount()
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(storeManager: storeManager)
        }
        .overlay {
            if let card = fullScreenOracleCard {
                FullScreenCardView(content: .oracle(card)) {
                    fullScreenOracleCard = nil
                }
            }
        }
    }

    // MARK: - Oracle Menu Screen

    private var oracleMenuScreen: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Title
                VStack(spacing: 6) {
                    Text("Oracle")
                        .font(.cosmicTitle(28))
                        .foregroundStyle(Color.cosmicText)

                    Text("Écoute le message de ton cœur cosmique")
                        .font(.cosmicCaption())
                        .foregroundStyle(Color.cosmicTextSecondary)
                }
                .padding(.top, 16)

                // Free limit banner
                if hasReachedFreeLimit {
                    oracleFreeLimitBanner
                }

                // Spread selection
                oracleSpreadSelection

                // Question input
                oracleQuestionSection

                // Draw button
                oracleDrawButton

                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Oracle Reading Result Screen

    private func oracleReadingResultScreen(_ reading: OracleReading) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Spread title
                VStack(spacing: 8) {
                    Text(reading.spread.title)
                        .font(.cosmicTitle(26))
                        .foregroundStyle(Color.cosmicRose)

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
                    singleOracleCardView(reading.cards[0], label: reading.spread.labels[0], index: 0)
                } else {
                    ForEach(Array(reading.cards.enumerated()), id: \.element.id) { index, drawn in
                        let label = index < reading.spread.labels.count
                            ? reading.spread.labels[index]
                            : ""
                        multiOracleCardView(drawn, label: label, index: index, total: reading.cards.count)
                    }
                }

                // New draw button
                Button {
                    withAnimation {
                        showReading = false
                        viewModel.currentOracleReading = nil
                        revealedCards = []
                        question = ""
                    }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 15, weight: .medium))
                        Text("Nouveau tirage")
                            .font(.cosmicHeadline(16))
                    }
                    .foregroundStyle(Color.cosmicRose)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.cosmicRose.opacity(0.5), lineWidth: 1.5)
                    )
                }
                .buttonStyle(.plain)

                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Free Limit Banner

    private var oracleFreeLimitBanner: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.cosmicRose)

                Text("Tu as utilisé ton tirage Oracle gratuit du jour")
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
                .strokeBorder(Color.cosmicRose.opacity(0.3), lineWidth: 1)
        )
    }

    // MARK: - Spread Selection

    private var oracleSpreadSelection: some View {
        VStack(spacing: 12) {
            ForEach(OracleSpreadType.allCases) { spread in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        selectedSpread = spread
                    }
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: spread.icon)
                            .font(.system(size: 18))
                            .foregroundStyle(
                                selectedSpread == spread ? Color.cosmicRose : Color.cosmicTextSecondary
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
                                .foregroundStyle(Color.cosmicRose)
                        }
                    }
                    .padding(14)
                    .cosmicCard(cornerRadius: 14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(
                                selectedSpread == spread
                                    ? Color.cosmicRose.opacity(0.4)
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

    private var oracleQuestionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ton intention (optionnel)")
                .font(.cosmicCaption())
                .foregroundStyle(Color.cosmicTextSecondary)

            TextField("Que souhaites-tu éclairer ?", text: $question)
                .font(.cosmicBody(15))
                .foregroundStyle(Color.cosmicText)
                .tint(Color.cosmicRose)
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

    private var oracleDrawButton: some View {
        Button {
            if hasReachedFreeLimit {
                showPaywall = true
            } else {
                performOracleDraw()
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
                    Image(systemName: "heart.fill")
                        .font(.system(size: 16, weight: .medium))
                }

                Text(isDrawing
                     ? "L'Oracle se concentre..."
                     : hasReachedFreeLimit
                        ? "Débloquer les tirages illimités"
                        : "Recevoir mon message")
                    .font(.cosmicHeadline(16))
            }
            .foregroundStyle(Color.cosmicBackground)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [.cosmicRose, .cosmicPurple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .glow(.cosmicRose, radius: isDrawing ? 4 : 8)
        }
        .buttonStyle(.plain)
        .disabled(isDrawing)
    }

    private func singleOracleCardView(_ drawn: DrawnOracleCard, label: String, index: Int) -> some View {
        VStack(spacing: 16) {
            if let card = drawn.resolve(from: viewModel.oracleDeck) {
                let isRevealed = revealedCards.contains(index)

                Text(label)
                    .font(.cosmicCaption())
                    .foregroundStyle(Color.cosmicRose)
                    .textCase(.uppercase)
                    .kerning(2)

                FlippableOracleCard(
                    card: card,
                    isFlipped: Binding(
                        get: { isRevealed },
                        set: { if $0 { revealedCards.insert(index) } else { revealedCards.remove(index) } }
                    ),
                    size: .large,
                    onFullScreen: { fullScreenOracleCard = card }
                )

                if isRevealed {
                    oracleInterpretationView(card: card)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
        .padding(20)
        .cosmicCard()
    }

    private func multiOracleCardView(_ drawn: DrawnOracleCard, label: String, index: Int, total: Int) -> some View {
        VStack(spacing: 16) {
            if let card = drawn.resolve(from: viewModel.oracleDeck) {
                let isRevealed = revealedCards.contains(index)

                HStack {
                    Text(label)
                        .font(.cosmicCaption())
                        .foregroundStyle(Color.cosmicRose)
                        .textCase(.uppercase)
                        .kerning(2)

                    Spacer()

                    Text("\(index + 1)/\(total)")
                        .font(.cosmicCaption(11))
                        .foregroundStyle(Color.cosmicTextSecondary)
                }

                FlippableOracleCard(
                    card: card,
                    isFlipped: Binding(
                        get: { isRevealed },
                        set: { if $0 { revealedCards.insert(index) } else { revealedCards.remove(index) } }
                    ),
                    size: .medium,
                    onFullScreen: { fullScreenOracleCard = card }
                )

                if isRevealed {
                    oracleInterpretationView(card: card)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
        .padding(16)
        .cosmicCard()
    }

    private func oracleInterpretationView(card: OracleCard) -> some View {
        VStack(spacing: 10) {
            Text("\(card.number). \(card.name)")
                .font(.cosmicHeadline(16))
                .foregroundStyle(Color.cosmicText)

            Text(card.message)
                .font(.cosmicBody(14))
                .foregroundStyle(Color.cosmicText.opacity(0.9))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .italic()

            if storeManager.isPremium {
                Text(card.extendedMeaning)
                    .font(.cosmicBody(13))
                    .foregroundStyle(Color.cosmicTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.top, 4)
            }

            HStack(spacing: 6) {
                ForEach(card.keywords, id: \.self) { keyword in
                    Text(keyword)
                        .font(.cosmicCaption(10))
                        .foregroundStyle(Color.cosmicRose)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            Capsule().fill(Color.cosmicRose.opacity(0.12))
                        )
                }
            }
        }
    }

    // MARK: - Actions

    private func performOracleDraw() {
        isQuestionFocused = false
        isDrawing = true
        revealedCards = []

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            viewModel.performOracleReading(
                spread: selectedSpread,
                question: question.isEmpty ? nil : question
            )
            isDrawing = false
            withAnimation {
                showReading = true
            }

            // Auto-reveal cards sequentially
            if let reading = viewModel.currentOracleReading {
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
