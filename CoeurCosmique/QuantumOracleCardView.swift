import SwiftUI

// MARK: - Quantum Oracle Card Front

struct QuantumOracleCardFront: View {
    let card: QuantumOracleCard
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
                                    card.family.color.opacity(0.6),
                                    card.family.color.opacity(0.3),
                                    Color.cosmicPurple.opacity(0.2)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1.5
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
            quantumFallback
                .clipShape(RoundedRectangle(cornerRadius: size == .large ? 12 : 8))
                .padding(size == .large ? 8 : 5)
                .opacity(UIImage(named: card.imageName) == nil ? 1 : 0)
            
            // Bottom name overlay
            VStack {
                Spacer()
                
                Text("\(card.number). \(card.name)")
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
        .shadow(color: card.family.color.opacity(0.3), radius: 12)
    }
    
    private var quantumFallback: some View {
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
            .overlay(
                VStack(spacing: 6) {
                    Image(systemName: card.family.icon)
                        .font(.system(size: size == .large ? 40 : size == .medium ? 28 : 18))
                        .foregroundStyle(card.family.color.opacity(0.5))
                    Text("\(card.number)")
                        .font(.cosmicNumber(size == .large ? 16 : 11))
                        .foregroundStyle(Color.cosmicTextSecondary.opacity(0.4))
                }
            )
    }
}

// MARK: - Quantum Oracle Card Back

struct QuantumOracleCardBack: View {
    var size: QuantumOracleCardFront.CardSize = .medium

    var body: some View {
        Image("card-back")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width, height: size.height)
            .clipShape(RoundedRectangle(cornerRadius: size == .large ? 16 : 12))
            .overlay(
                RoundedRectangle(cornerRadius: size == .large ? 16 : 12)
                    .strokeBorder(
                        LinearGradient.cosmicGoldGradient,
                        lineWidth: 1.5
                    )
            )
            .shadow(color: Color.cosmicPurple.opacity(0.3), radius: 8)
    }
}

// MARK: - Flippable Quantum Oracle Card

struct FlippableQuantumOracleCard: View {
    let card: QuantumOracleCard
    @Binding var isFlipped: Bool
    var size: QuantumOracleCardFront.CardSize = .medium
    var onFullScreen: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            QuantumOracleCardBack(size: size)
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(
                    .degrees(isFlipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )
            
            QuantumOracleCardFront(card: card, size: size)
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

// MARK: - Quantum Oracle Collection Card

struct QuantumOracleCollectionCardView: View {
    let card: QuantumOracleCard
    
    var body: some View {
        QuantumOracleCardFront(card: card, size: .small)
    }
}

// MARK: - Quantum Family Extension for Colors

extension QuantumFamily {
    var color: Color {
        switch self {
        case .loisFondamentales:
            return Color(red: 0.5, green: 0.4, blue: 0.9) // Deep purple
        case .cosmologieAme:
            return Color(red: 0.9, green: 0.3, blue: 0.6) // Rose-pink
        case .paradoxesTemporels:
            return Color(red: 0.3, green: 0.7, blue: 0.9) // Cyan-blue
        case .conscienceMulti:
            return Color(red: 0.9, green: 0.7, blue: 0.3) // Golden
        case .anomaliesCosmiques:
            return Color(red: 0.7, green: 0.3, blue: 0.9) // Magenta
        case .forcesLiaison:
            return Color(red: 0.3, green: 0.9, blue: 0.6) // Turquoise-green
        }
    }
}
