import SwiftUI

// MARK: - Oracle Card Front

struct OracleCardFront: View {
    let card: OracleCard
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
            case .small: return .cosmicCaption(10)
            case .medium: return .cosmicCaption(12)
            case .large: return .cosmicHeadline(16)
            }
        }
    }

    var body: some View {
        ZStack {
            // Card border
            RoundedRectangle(cornerRadius: size == .large ? 16 : 12)
                .fill(Color.cosmicCard)
                .overlay(
                    RoundedRectangle(cornerRadius: size == .large ? 16 : 12)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.cosmicRose.opacity(0.5),
                                    Color.cosmicPurple.opacity(0.3),
                                    Color.cosmicGold.opacity(0.2)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                )

            // Card image from asset catalog
            Image(card.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width - (size == .large ? 16 : 10),
                       height: size.height - (size == .large ? 16 : 10))
                .clipShape(RoundedRectangle(cornerRadius: size == .large ? 12 : 8))
                .padding(size == .large ? 8 : 5)

            // Fallback overlay if image missing
            oracleFallback
                .clipShape(RoundedRectangle(cornerRadius: size == .large ? 12 : 8))
                .padding(size == .large ? 8 : 5)
                .opacity(UIImage(named: card.imageName) == nil ? 1 : 0)

            // Bottom name overlay
            VStack {
                Spacer()

                Text(card.name)
                    .font(size.titleFont)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .padding(.horizontal, 6)
                    .padding(.vertical, size == .large ? 7 : 4)
                    .frame(maxWidth: .infinity)
                    .background(
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .environment(\.colorScheme, .dark)
                    )
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: size == .large ? 16 : 12,
                            bottomTrailingRadius: size == .large ? 16 : 12,
                            topTrailingRadius: 0
                        )
                    )
            }
        }
        .frame(width: size.width, height: size.height)
        .shadow(color: Color.cosmicRose.opacity(0.3), radius: 12)
    }

    private var oracleFallback: some View {
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
            .overlay(
                VStack(spacing: 6) {
                    Text("♡")
                        .font(.system(size: size == .large ? 40 : size == .medium ? 28 : 18))
                        .foregroundStyle(Color.cosmicRose.opacity(0.5))
                    Text("\(card.number)")
                        .font(.cosmicNumber(size == .large ? 16 : 11))
                        .foregroundStyle(Color.cosmicTextSecondary.opacity(0.4))
                }
            )
    }
}

// MARK: - Oracle Card Back

struct OracleCardBack: View {
    var size: OracleCardFront.CardSize = .medium

    var body: some View {
        Image("oracle-card-back")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width, height: size.height)
            .clipShape(RoundedRectangle(cornerRadius: size == .large ? 16 : 12))
            .overlay(
                RoundedRectangle(cornerRadius: size == .large ? 16 : 12)
                    .strokeBorder(
                        LinearGradient(
                            colors: [.cosmicRose, .cosmicPurple, .cosmicGold],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .shadow(color: Color.cosmicPurple.opacity(0.3), radius: 8)
    }
}

// MARK: - Flippable Oracle Card

struct FlippableOracleCard: View {
    let card: OracleCard
    @Binding var isFlipped: Bool
    var size: OracleCardFront.CardSize = .medium
    var onFullScreen: (() -> Void)? = nil

    var body: some View {
        ZStack {
            OracleCardBack(size: size)
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(
                    .degrees(isFlipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )

            OracleCardFront(card: card, size: size)
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(
                    .degrees(isFlipped ? 0 : -180),
                    axis: (x: 0, y: 1, z: 0)
                )
        }
        .onTapGesture {
            if isFlipped, let onFullScreen {
                onFullScreen()
            } else {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    isFlipped.toggle()
                }
            }
        }
    }
}

// MARK: - Oracle Collection Card

struct OracleCollectionCardView: View {
    let card: OracleCard

    var body: some View {
        OracleCardFront(card: card, size: .small)
    }
}
