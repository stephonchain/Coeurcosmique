import SwiftUI

// MARK: - Card Front (showing card info)

struct TarotCardFront: View {
    let card: TarotCard
    let isReversed: Bool
    var size: CardSize = .medium

    enum CardSize {
        case small, medium, large

        var width: CGFloat {
            switch self {
            case .small: return 100
            case .medium: return 140
            case .large: return 220
            }
        }

        var height: CGFloat { width * 1.6 }

        var titleFont: Font {
            switch self {
            case .small: return .cosmicCaption(11)
            case .medium: return .cosmicCaption(13)
            case .large: return .cosmicHeadline(18)
            }
        }

        var numberFont: Font {
            switch self {
            case .small: return .cosmicNumber(10)
            case .medium: return .cosmicNumber(12)
            case .large: return .cosmicNumber(16)
            }
        }
    }

    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: size == .large ? 16 : 12)
                .fill(
                    LinearGradient(
                        colors: [
                            cardTopColor.opacity(0.3),
                            Color.cosmicCard,
                            Color.cosmicCard
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: size == .large ? 16 : 12)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.cosmicGold.opacity(0.5),
                                    Color.cosmicGold.opacity(0.2),
                                    Color.cosmicGold.opacity(0.1)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                )

            VStack(spacing: size == .large ? 12 : 6) {
                // Number
                Text(card.arcana == .major ? card.romanNumeral : "\(card.number)")
                    .font(size.numberFont)
                    .foregroundStyle(Color.cosmicGold)

                Spacer()

                // Symbol area
                Text(arcanaSymbol)
                    .font(.system(size: size == .large ? 44 : size == .medium ? 30 : 22))

                Spacer()

                // Card name
                Text(card.name)
                    .font(size.titleFont)
                    .foregroundStyle(Color.cosmicText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)

                if isReversed {
                    Text("Inversée")
                        .font(.cosmicCaption(size == .large ? 11 : 9))
                        .foregroundStyle(Color.cosmicRose)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            Capsule().fill(Color.cosmicRose.opacity(0.15))
                        )
                }
            }
            .padding(size == .large ? 16 : 10)
            .rotationEffect(isReversed ? .degrees(180) : .zero)
        }
        .frame(width: size.width, height: size.height)
        .shadow(color: cardTopColor.opacity(0.3), radius: 12)
    }

    private var cardTopColor: Color {
        switch card.arcana {
        case .major: return .cosmicGold
        case .cups: return .blue
        case .wands: return .orange
        case .swords: return .cyan
        case .pentacles: return .green
        }
    }

    private var arcanaSymbol: String {
        switch card.arcana {
        case .major:
            let symbols = ["🃏", "🎩", "📖", "👑", "🏛️", "⛪", "❤️", "🏇",
                          "⚖️", "🏮", "🎡", "🦁", "🙃", "💀", "🏺", "😈",
                          "🗼", "⭐", "🌙", "☀️", "📯", "🌍"]
            return card.number < symbols.count ? symbols[card.number] : "✦"
        case .cups: return "🏆"
        case .wands: return "🪄"
        case .swords: return "⚔️"
        case .pentacles: return "⭐"
        }
    }
}

// MARK: - Card Back (face down)

struct TarotCardBack: View {
    var size: TarotCardFront.CardSize = .medium

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size == .large ? 16 : 12)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.15, green: 0.10, blue: 0.30),
                            Color(red: 0.08, green: 0.05, blue: 0.18)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: size == .large ? 16 : 12)
                        .strokeBorder(
                            LinearGradient.cosmicGoldGradient,
                            lineWidth: 1.5
                        )
                )

            // Inner decorative border
            RoundedRectangle(cornerRadius: size == .large ? 12 : 8)
                .strokeBorder(Color.cosmicGold.opacity(0.3), lineWidth: 0.5)
                .padding(8)

            // Center motif
            VStack(spacing: 4) {
                Text("✦")
                    .font(.system(size: size == .large ? 32 : size == .medium ? 22 : 16))
                    .foregroundStyle(Color.cosmicGold)

                Text("C C")
                    .font(.cosmicCaption(size == .large ? 14 : 10))
                    .foregroundStyle(Color.cosmicGold.opacity(0.6))
                    .kerning(4)
            }
        }
        .frame(width: size.width, height: size.height)
        .shadow(color: Color.cosmicPurple.opacity(0.3), radius: 8)
    }
}

// MARK: - Flippable Card

struct FlippableTarotCard: View {
    let card: TarotCard
    let isReversed: Bool
    @Binding var isFlipped: Bool
    var size: TarotCardFront.CardSize = .medium

    var body: some View {
        ZStack {
            TarotCardBack(size: size)
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(
                    .degrees(isFlipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )

            TarotCardFront(card: card, isReversed: isReversed, size: size)
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(
                    .degrees(isFlipped ? 0 : -180),
                    axis: (x: 0, y: 1, z: 0)
                )
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isFlipped.toggle()
            }
        }
    }
}

// MARK: - Collection Grid Card

struct CollectionCardView: View {
    let card: TarotCard

    var body: some View {
        VStack(spacing: 8) {
            TarotCardFront(card: card, isReversed: false, size: .small)

            Text(card.name)
                .font(.cosmicCaption(11))
                .foregroundStyle(Color.cosmicTextSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }
}

#Preview("Card Front") {
    ZStack {
        CosmicBackground()
        TarotCardFront(
            card: TarotDeck.majorArcana[17],
            isReversed: false,
            size: .large
        )
    }
}

#Preview("Card Back") {
    ZStack {
        CosmicBackground()
        TarotCardBack(size: .large)
    }
}
