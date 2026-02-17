import SwiftUI

// MARK: - Full Screen Card View

struct FullScreenCardView: View {
    enum CardContent {
        case tarot(TarotCard, isReversed: Bool)
        case oracle(OracleCard)
        case quantumOracle(QuantumOracleCard)
    }

    let content: CardContent
    let onDismiss: () -> Void

    @State private var appear: Double = 0

    var body: some View {
        ZStack {
            // Dark backdrop
            Color.black.opacity(0.93 * appear)
                .ignoresSafeArea()
                .onTapGesture(perform: animateDismiss)

            // Rotating card
            VStack(spacing: 16) {
                cardImage
                cardName
            }
            .padding(.horizontal, 24)
            .rotation3DEffect(
                .degrees((1 - appear) * 180),
                axis: (x: 0, y: 1, z: 0),
                perspective: 0.4
            )
            .scaleEffect(0.3 + 0.7 * appear)
            .opacity(appear)
            .onTapGesture(perform: animateDismiss)

            // Dismiss hint
            VStack {
                Spacer()
                Text("Touche pour fermer")
                    .font(.cosmicCaption(12))
                    .foregroundStyle(.white.opacity(0.4))
                    .padding(.bottom, 50)
            }
            .opacity(appear)
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.75)) {
                appear = 1
            }
        }
    }

    // MARK: - Card Image

    @ViewBuilder
    private var cardImage: some View {
        switch content {
        case .tarot(let card, let isReversed):
            tarotImage(card: card, isReversed: isReversed)
        case .oracle(let card):
            oracleImage(card: card)
        case .quantumOracle(let card):
            quantumOracleImage(card: card)
        }
    }

    // MARK: - Card Name

    @ViewBuilder
    private var cardName: some View {
        switch content {
        case .tarot(let card, let isReversed):
            VStack(spacing: 4) {
                Text(card.name)
                    .font(.cosmicTitle(22))
                    .foregroundStyle(.white)
                if isReversed {
                    Text("Inversée")
                        .font(.cosmicCaption(12))
                        .foregroundStyle(Color.cosmicRose)
                }
            }
        case .oracle(let card):
            Text("\(card.number). \(card.name)")
                .font(.cosmicTitle(22))
                .foregroundStyle(.white)
        case .quantumOracle(let card):
            VStack(spacing: 6) {
                HStack(spacing: 8) {
                    Text(card.family.icon)
                        .font(.system(size: 18))
                    Text("\(card.number). \(card.name)")
                        .font(.cosmicTitle(22))
                }
                .foregroundStyle(.white)
                
                Text(card.family.rawValue)
                    .font(.cosmicCaption(12))
                    .foregroundStyle(card.family.color)
                    .textCase(.uppercase)
                    .kerning(1.5)
            }
        }
    }

    // MARK: - Tarot Image

    private func tarotImage(card: TarotCard, isReversed: Bool) -> some View {
        Group {
            if !card.imageName.isEmpty, UIImage(named: card.imageName) != nil {
                Image(card.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                tarotFallback(card: card)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(LinearGradient.cosmicGoldGradient, lineWidth: 2)
        )
        .shadow(color: .cosmicGold.opacity(0.4), radius: 30)
        .rotationEffect(isReversed ? .degrees(180) : .zero)
    }

    private func tarotFallback(card: TarotCard) -> some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [Color.cosmicPurple.opacity(0.3), Color.cosmicCard],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .aspectRatio(0.6, contentMode: .fit)
            .overlay(
                VStack(spacing: 12) {
                    Text("✦")
                        .font(.system(size: 50))
                        .foregroundStyle(Color.cosmicGold.opacity(0.5))
                    Text("\(card.number). \(card.name)")
                        .font(.cosmicHeadline(18))
                        .foregroundStyle(.white.opacity(0.7))
                }
            )
    }

    // MARK: - Oracle Image

    private func oracleImage(card: OracleCard) -> some View {
        Group {
            if UIImage(named: card.imageName) != nil {
                Image(card.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.cosmicRose.opacity(0.25),
                                Color.cosmicPurple.opacity(0.2),
                                Color.cosmicCard
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .aspectRatio(0.6, contentMode: .fit)
                    .overlay(
                        VStack(spacing: 12) {
                            Text("♡")
                                .font(.system(size: 50))
                                .foregroundStyle(Color.cosmicRose.opacity(0.5))
                            Text(card.name)
                                .font(.cosmicHeadline(18))
                                .foregroundStyle(.white.opacity(0.7))
                        }
                    )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(
                    LinearGradient(
                        colors: [.cosmicRose, .cosmicPurple, .cosmicGold],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .shadow(color: .cosmicRose.opacity(0.4), radius: 30)
    }
    
    // MARK: - Quantum Oracle Image
    
    private func quantumOracleImage(card: QuantumOracleCard) -> some View {
        Group {
            if UIImage(named: card.imageName) != nil {
                Image(card.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                card.family.color.opacity(0.25),
                                Color.cosmicPurple.opacity(0.2),
                                Color.cosmicCard
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .aspectRatio(0.6, contentMode: .fit)
                    .overlay(
                        VStack(spacing: 12) {
                            Text(card.family.icon)
                                .font(.system(size: 50))
                                .foregroundStyle(card.family.color.opacity(0.5))
                            Text(card.name)
                                .font(.cosmicHeadline(18))
                                .foregroundStyle(.white.opacity(0.7))
                        }
                    )
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(
                    LinearGradient(
                        colors: [card.family.color, .cosmicPurple, card.family.color],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .shadow(color: card.family.color.opacity(0.4), radius: 30)
    }

    // MARK: - Dismiss

    private func animateDismiss() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            appear = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            onDismiss()
        }
    }
}
