import SwiftUI

// MARK: - Spread Position

struct SpreadPosition {
    let x: CGFloat  // grid column (-2 to 2)
    let y: CGFloat  // grid row (-2 to 2)
}

// MARK: - Spread Layout Protocol

protocol SpreadLayoutProvider {
    var layoutPositions: [SpreadPosition] { get }
    var labels: [String] { get }
}

// MARK: - Spread Layout View

struct SpreadLayoutView<CardBack: View, CardFront: View>: View {
    let positions: [SpreadPosition]
    let labels: [String]
    let revealedCards: Set<Int>
    let accentColor: Color
    @ViewBuilder let cardBack: () -> CardBack
    @ViewBuilder let cardFront: (Int) -> CardFront
    let onTapCard: (Int) -> Void

    private let cardWidth: CGFloat = 80
    private let cardHeight: CGFloat = 128
    private let gridSpacing: CGFloat = 10

    private var cellWidth: CGFloat { cardWidth + gridSpacing }
    private var cellHeight: CGFloat { cardHeight + gridSpacing }

    // Compute bounding box
    private var minX: CGFloat { positions.map(\.x).min() ?? 0 }
    private var maxX: CGFloat { positions.map(\.x).max() ?? 0 }
    private var minY: CGFloat { positions.map(\.y).min() ?? 0 }
    private var maxY: CGFloat { positions.map(\.y).max() ?? 0 }

    private var layoutWidth: CGFloat { (maxX - minX) * cellWidth + cardWidth }
    private var layoutHeight: CGFloat { (maxY - minY) * cellHeight + cardHeight + 24 }

    var body: some View {
        ZStack {
            ForEach(Array(positions.enumerated()), id: \.offset) { index, pos in
                let isRevealed = revealedCards.contains(index)

                VStack(spacing: 4) {
                    // Position label
                    Text(index < labels.count ? labels[index] : "")
                        .font(.cosmicCaption(9))
                        .foregroundStyle(accentColor.opacity(0.7))
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .frame(width: cardWidth)

                    // Card
                    ZStack {
                        // Back
                        cardBack()
                            .frame(width: cardWidth, height: cardHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .opacity(isRevealed ? 0 : 1)
                            .rotation3DEffect(
                                .degrees(isRevealed ? 180 : 0),
                                axis: (x: 0, y: 1, z: 0)
                            )

                        // Front
                        cardFront(index)
                            .frame(width: cardWidth, height: cardHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .opacity(isRevealed ? 1 : 0)
                            .rotation3DEffect(
                                .degrees(isRevealed ? 0 : -180),
                                axis: (x: 0, y: 1, z: 0)
                            )
                    }
                    .shadow(color: isRevealed ? accentColor.opacity(0.3) : .clear, radius: 8)
                    .onTapGesture {
                        onTapCard(index)
                    }
                }
                .offset(
                    x: (pos.x - (minX + maxX) / 2) * cellWidth,
                    y: (pos.y - (minY + maxY) / 2) * cellHeight
                )
            }
        }
        .frame(width: layoutWidth, height: layoutHeight)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Mini Card Back (for layouts)

struct MiniCardBack: View {
    var accentColor: Color = .cosmicGold

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.cosmicCard)

            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(
                    LinearGradient(
                        colors: [accentColor.opacity(0.5), accentColor.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )

            // Inner pattern
            RoundedRectangle(cornerRadius: 6)
                .strokeBorder(accentColor.opacity(0.15), lineWidth: 0.5)
                .padding(8)

            Image(systemName: "sparkle")
                .font(.system(size: 16))
                .foregroundStyle(accentColor.opacity(0.25))
        }
    }
}

// MARK: - Mini Card Front (generic)

struct MiniCardFront: View {
    let imageName: String
    let title: String
    let subtitle: String
    let accentColor: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.cosmicCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            LinearGradient(
                                colors: [accentColor.opacity(0.6), accentColor.opacity(0.2)],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1.5
                        )
                )

            // Try image first
            if UIImage(named: imageName) != nil {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 74, height: 118)
                    .clipShape(RoundedRectangle(cornerRadius: 7))
                    .padding(3)
            } else {
                // Fallback
                VStack(spacing: 4) {
                    Text(subtitle)
                        .font(.system(size: 18, weight: .bold, design: .serif))
                        .foregroundStyle(accentColor.opacity(0.5))

                    Text(title)
                        .font(.cosmicCaption(8))
                        .foregroundStyle(Color.cosmicTextSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.6)
                }
                .padding(6)
            }

            // Bottom label
            VStack {
                Spacer()
                Text(title)
                    .font(.system(size: 7, weight: .medium))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial.opacity(0.8))
                    .environment(\.colorScheme, .dark)
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 10,
                            bottomTrailingRadius: 10,
                            topTrailingRadius: 0
                        )
                    )
            }
        }
    }
}

// MARK: - Layout Positions for all Spread Types

extension TarotSpreadType: SpreadLayoutProvider {
    var layoutPositions: [SpreadPosition] {
        switch self {
        case .dailyGuidance, .yesNo:
            return [SpreadPosition(x: 0, y: 0)]
        case .pastPresentFuture, .relationship, .situationActionOutcome:
            return [
                SpreadPosition(x: -1, y: 0),
                SpreadPosition(x: 0, y: 0),
                SpreadPosition(x: 1, y: 0)
            ]
        }
    }
}

extension OracleSpreadType: SpreadLayoutProvider {
    var layoutPositions: [SpreadPosition] {
        switch self {
        case .singleGuidance:
            return [SpreadPosition(x: 0, y: 0)]
        case .threeCards, .loveReading:
            return [
                SpreadPosition(x: -1, y: 0),
                SpreadPosition(x: 0, y: 0),
                SpreadPosition(x: 1, y: 0)
            ]
        }
    }
}

extension QuantumSpreadType: SpreadLayoutProvider {
    var layoutPositions: [SpreadPosition] {
        switch self {
        case .lienDesAmes:
            // Triangle: You (left), Other (right), Link (top center)
            return [
                SpreadPosition(x: -1, y: 0.5),
                SpreadPosition(x: 1, y: 0.5),
                SpreadPosition(x: 0, y: -0.5)
            ]
        case .chatDeSchrodinger:
            // Diamond: Situation (top), Action (left), Non-Action (right), Collapse (bottom)
            return [
                SpreadPosition(x: 0, y: -1),
                SpreadPosition(x: -1, y: 0),
                SpreadPosition(x: 1, y: 0),
                SpreadPosition(x: 0, y: 1)
            ]
        case .sautQuantique:
            // X pattern: Gravity (top-left), Dark Energy (top-right), Horizon (center), Wormhole (bottom-left), New Galaxy (bottom-right)
            return [
                SpreadPosition(x: -1, y: -1),
                SpreadPosition(x: 1, y: -1),
                SpreadPosition(x: 0, y: 0),
                SpreadPosition(x: -1, y: 1),
                SpreadPosition(x: 1, y: 1)
            ]
        }
    }
}

extension RuneSpreadType: SpreadLayoutProvider {
    var layoutPositions: [SpreadPosition] {
        switch self {
        case .pulsar:
            return [SpreadPosition(x: 0, y: 0)]
        case .ceintureOrion:
            // Horizontal: Origin, Vortex, Destination
            return [
                SpreadPosition(x: -1, y: 0),
                SpreadPosition(x: 0, y: 0),
                SpreadPosition(x: 1, y: 0)
            ]
        case .bouclierAlgiz:
            // Diamond: Challenge (top), Ally (left), Right Action (right), Result (bottom)
            return [
                SpreadPosition(x: 0, y: -1),
                SpreadPosition(x: -1, y: 0),
                SpreadPosition(x: 1, y: 0),
                SpreadPosition(x: 0, y: 1)
            ]
        case .croixGalactique:
            // Cross: Heart (center), West (left), East (right), South (bottom), North (top)
            return [
                SpreadPosition(x: 0, y: 0),
                SpreadPosition(x: -1, y: 0),
                SpreadPosition(x: 1, y: 0),
                SpreadPosition(x: 0, y: 1),
                SpreadPosition(x: 0, y: -1)
            ]
        }
    }
}
