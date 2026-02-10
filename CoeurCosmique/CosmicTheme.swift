import SwiftUI

// MARK: - Color Palette

extension Color {
    static let cosmicBackground = Color(red: 0.04, green: 0.04, blue: 0.10)
    static let cosmicSurface = Color(red: 0.08, green: 0.07, blue: 0.16)
    static let cosmicCard = Color(red: 0.12, green: 0.10, blue: 0.22)
    static let cosmicGold = Color(red: 0.79, green: 0.66, blue: 0.43)
    static let cosmicGoldLight = Color(red: 0.89, green: 0.78, blue: 0.56)
    static let cosmicPurple = Color(red: 0.55, green: 0.49, blue: 0.78)
    static let cosmicPurpleLight = Color(red: 0.70, green: 0.62, blue: 0.90)
    static let cosmicRose = Color(red: 0.83, green: 0.63, blue: 0.63)
    static let cosmicText = Color(red: 0.96, green: 0.94, blue: 0.91)
    static let cosmicTextSecondary = Color(red: 0.70, green: 0.67, blue: 0.72)
    static let cosmicDivider = Color.white.opacity(0.08)
}

// MARK: - Gradients

extension LinearGradient {
    static let cosmicGoldGradient = LinearGradient(
        colors: [.cosmicGold, .cosmicGoldLight, .cosmicGold],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cosmicPurpleGradient = LinearGradient(
        colors: [.cosmicPurple, .cosmicPurpleLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cosmicBackgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.06, green: 0.04, blue: 0.14),
            Color(red: 0.04, green: 0.04, blue: 0.10),
            Color(red: 0.02, green: 0.02, blue: 0.06)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let cosmicCardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.12),
            Color.white.opacity(0.04)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - View Modifiers

struct CosmicCardStyle: ViewModifier {
    var cornerRadius: CGFloat = 20

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.cosmicCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(LinearGradient.cosmicCardGradient)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5)
                    )
            )
    }
}

struct GlowEffect: ViewModifier {
    let color: Color
    let radius: CGFloat

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.4), radius: radius)
            .shadow(color: color.opacity(0.2), radius: radius * 2)
    }
}

extension View {
    func cosmicCard(cornerRadius: CGFloat = 20) -> some View {
        modifier(CosmicCardStyle(cornerRadius: cornerRadius))
    }

    func glow(_ color: Color = .cosmicGold, radius: CGFloat = 8) -> some View {
        modifier(GlowEffect(color: color, radius: radius))
    }
}

// MARK: - Custom Fonts

extension Font {
    static func cosmicTitle(_ size: CGFloat = 28) -> Font {
        .system(size: size, weight: .light, design: .serif)
    }

    static func cosmicHeadline(_ size: CGFloat = 20) -> Font {
        .system(size: size, weight: .medium, design: .serif)
    }

    static func cosmicBody(_ size: CGFloat = 16) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }

    static func cosmicCaption(_ size: CGFloat = 13) -> Font {
        .system(size: size, weight: .medium, design: .default)
    }

    static func cosmicNumber(_ size: CGFloat = 14) -> Font {
        .system(size: size, weight: .light, design: .serif)
    }
}
