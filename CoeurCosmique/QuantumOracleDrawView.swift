import SwiftUI

// MARK: - Quantum Oracle Draw View

struct QuantumOracleDrawView: View {
    @ObservedObject var viewModel: AppViewModel
    @EnvironmentObject var storeManager: StoreManager
    @State private var selectedSpread: QuantumSpreadType = .intricationDesAmes
    @State private var question: String = ""
    @State private var isDrawing = false
    @State private var revealedCards: Set<Int> = []
    @State private var showReading = false
    @State private var showPaywall = false
    @State private var fullScreenQuantumCard: QuantumOracleCard? = nil
    @FocusState private var isQuestionFocused: Bool
    
    private var hasReachedFreeLimit: Bool {
        // Quantum Oracle is Premium only
        !storeManager.isPremium
    }
    
    var body: some View {
        Group {
            if let reading = viewModel.currentQuantumReading, showReading {
                quantumReadingResultScreen(reading)
                    .transition(.opacity)
            } else {
                quantumMenuScreen
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: showReading)
        .onAppear {
            // Premium check happens here
            if !storeManager.isPremium {
                showPaywall = true
            }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(storeManager: storeManager)
        }
        .overlay {
            if let card = fullScreenQuantumCard {
                FullScreenCardView(content: .quantumOracle(card)) {
                    fullScreenQuantumCard = nil
                }
            }
        }
    }
    
    // MARK: - Quantum Menu Screen
    
    private var quantumMenuScreen: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Title
                VStack(spacing: 8) {
                    HStack(spacing: 10) {
                        Text("∞")
                            .font(.system(size: 24))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.cosmicPurple, .cosmicRose],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Text("Oracle Quantique")
                            .font(.cosmicTitle(28))
                            .foregroundStyle(Color.cosmicText)
                    }
                    
                    Text("Explore les lois de l'intrication cosmique")
                        .font(.cosmicCaption())
                        .foregroundStyle(Color.cosmicTextSecondary)
                }
                .padding(.top, 16)
                
                // Premium badge
                premiumBadge
                
                // Spread selection
                quantumSpreadSelection
                
                // Question input
                quantumQuestionSection
                
                // Draw button
                quantumDrawButton
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Quantum Reading Result Screen
    
    private func quantumReadingResultScreen(_ reading: QuantumOracleReading) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Spread title with family icon
                VStack(spacing: 8) {
                    Text("∞")
                        .font(.system(size: 20))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.cosmicPurple, .cosmicRose],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text(reading.spread.title)
                        .font(.cosmicTitle(26))
                        .foregroundStyle(Color.cosmicPurple)
                    
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
                    quantumCardView(drawn, label: label, index: index, total: reading.cards.count, spread: reading.spread)
                }
                
                // New draw button
                Button {
                    withAnimation {
                        showReading = false
                        viewModel.currentQuantumReading = nil
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
                    .foregroundStyle(Color.cosmicPurple)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.cosmicPurple.opacity(0.5), lineWidth: 1.5)
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
    
    private var quantumSpreadSelection: some View {
        VStack(spacing: 12) {
            ForEach([QuantumSpreadType.intricationDesAmes, .chatDeSchrodinger, .sautQuantique]) { spread in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        selectedSpread = spread
                    }
                } label: {
                    HStack(spacing: 14) {
                        Text(spread.icon)
                            .font(.system(size: 20))
                            .frame(width: 32)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(spread.title)
                                .font(.cosmicBody(15))
                                .foregroundStyle(
                                    selectedSpread == spread ? Color.cosmicText : Color.cosmicTextSecondary
                                )
                            
                            Text(spread.description)
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
                                .foregroundStyle(Color.cosmicPurple)
                        }
                    }
                    .padding(14)
                    .cosmicCard(cornerRadius: 14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(
                                selectedSpread == spread
                                    ? Color.cosmicPurple.opacity(0.4)
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
    
    private var quantumQuestionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ton intention quantique (optionnel)")
                .font(.cosmicCaption())
                .foregroundStyle(Color.cosmicTextSecondary)
            
            TextField("Quelle réalité souhaites-tu observer ?", text: $question)
                .font(.cosmicBody(15))
                .foregroundStyle(Color.cosmicText)
                .tint(Color.cosmicPurple)
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
    
    private var quantumDrawButton: some View {
        Button {
            if hasReachedFreeLimit {
                showPaywall = true
            } else {
                performQuantumDraw()
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
                    Text("∞")
                        .font(.system(size: 18, weight: .medium))
                }
                
                Text(isDrawing
                     ? "Intrication en cours..."
                     : hasReachedFreeLimit
                        ? "Activer Premium"
                        : "Observer l'onde quantique")
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
            .glow(.cosmicPurple, radius: isDrawing ? 4 : 8)
        }
        .buttonStyle(.plain)
        .disabled(isDrawing)
    }
    
    // MARK: - Card View
    
    private func quantumCardView(
        _ drawn: DrawnQuantumOracleCard,
        label: String,
        index: Int,
        total: Int,
        spread: QuantumSpreadType
    ) -> some View {
        VStack(spacing: 16) {
            if let card = drawn.resolve(from: QuantumOracleDeck.allCards) {
                let isRevealed = revealedCards.contains(index)
                
                HStack {
                    Text(label)
                        .font(.cosmicCaption())
                        .foregroundStyle(card.family.color)
                        .textCase(.uppercase)
                        .kerning(2)
                    
                    Spacer()
                    
                    if total > 1 {
                        Text("\(index + 1)/\(total)")
                            .font(.cosmicCaption(11))
                            .foregroundStyle(Color.cosmicTextSecondary)
                    }
                }
                
                FlippableQuantumOracleCard(
                    card: card,
                    isFlipped: Binding(
                        get: { isRevealed },
                        set: { if $0 { revealedCards.insert(index) } else { revealedCards.remove(index) } }
                    ),
                    size: total == 1 ? .large : .medium,
                    onFullScreen: { fullScreenQuantumCard = card }
                )
                
                if isRevealed {
                    quantumInterpretationView(card: card, spread: spread, positionIndex: index)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
        .padding(16)
        .cosmicCard()
    }
    
    private func quantumInterpretationView(
        card: QuantumOracleCard,
        spread: QuantumSpreadType,
        positionIndex: Int
    ) -> some View {
        VStack(spacing: 12) {
            // Card name and number
            HStack(spacing: 8) {
                Text(card.family.icon)
                    .font(.system(size: 16))
                
                Text("\(card.number). \(card.name)")
                    .font(.cosmicHeadline(16))
                    .foregroundStyle(Color.cosmicText)
            }
            
            // Family indicator
            Text(card.family.rawValue)
                .font(.cosmicCaption(10))
                .foregroundStyle(card.family.color)
                .textCase(.uppercase)
                .kerning(1.5)
            
            // Core essence keywords
            HStack(spacing: 6) {
                ForEach(card.essence, id: \.self) { keyword in
                    Text(keyword)
                        .font(.cosmicCaption(10))
                        .foregroundStyle(card.family.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            Capsule().fill(card.family.color.opacity(0.12))
                        )
                }
            }
            
            // Deep message
            Text(card.messageProfond)
                .font(.cosmicBody(13))
                .foregroundStyle(Color.cosmicTextSecondary.opacity(0.9))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
                .italic()
                .padding(.vertical, 8)
            
            // Spread-specific interpretation
            if storeManager.isPremium {
                VStack(spacing: 8) {
                    Divider()
                        .background(card.family.color.opacity(0.2))
                    
                    let spreadInterpretation = getSpreadInterpretation(
                        card: card,
                        spread: spread,
                        positionIndex: positionIndex
                    )
                    
                    Text(spreadInterpretation)
                        .font(.cosmicBody(13))
                        .foregroundStyle(Color.cosmicText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func getSpreadInterpretation(
        card: QuantumOracleCard,
        spread: QuantumSpreadType,
        positionIndex: Int
    ) -> String {
        switch spread {
        case .intricationDesAmes:
            switch positionIndex {
            case 0: return card.interpretation.alphaYou
            case 1: return card.interpretation.betaOther
            case 2: return card.interpretation.linkResult
            default: return ""
            }
        case .chatDeSchrodinger:
            switch positionIndex {
            case 0: return card.interpretation.situation
            case 1: return card.interpretation.actionBoxA
            case 2: return card.interpretation.nonActionBoxB
            case 3: return card.interpretation.collapseResult
            default: return ""
            }
        case .sautQuantique:
            switch positionIndex {
            case 0: return card.interpretation.gravity
            case 1: return card.interpretation.darkEnergy
            case 2: return card.interpretation.horizon
            case 3: return card.interpretation.wormhole
            case 4: return card.interpretation.newGalaxy
            default: return ""
            }
        }
    }
    
    // MARK: - Actions
    
    private func performQuantumDraw() {
        isQuestionFocused = false
        isDrawing = true
        revealedCards = []
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            viewModel.performQuantumReading(
                spread: selectedSpread,
                question: question.isEmpty ? nil : question
            )
            isDrawing = false
            withAnimation {
                showReading = true
            }
            
            // Auto-reveal cards sequentially
            if let reading = viewModel.currentQuantumReading {
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
