import SwiftUI

struct CardDetailView: View {
    let card: TarotCard
    let deck: [TarotCard]
    @Environment(\.dismiss) private var dismiss
    @State private var appeared = false

    var body: some View {
        ZStack {
            CosmicBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Drag indicator
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 40, height: 5)
                        .padding(.top, 12)

                    // Large card image
                    if let urlString = card.imageURL, let url = URL(string: urlString) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 260)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(
                                                LinearGradient.cosmicGoldGradient,
                                                lineWidth: 1.5
                                            )
                                    )
                                    .shadow(color: Color.cosmicGold.opacity(0.3), radius: 20)
                            case .failure:
                                TarotCardFront(card: card, isReversed: false, size: .large)
                            case .empty:
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.cosmicCard)
                                    .frame(width: 220, height: 352)
                                    .overlay(ProgressView().tint(Color.cosmicGold))
                            @unknown default:
                                TarotCardFront(card: card, isReversed: false, size: .large)
                            }
                        }
                        .scaleEffect(appeared ? 1 : 0.8)
                        .opacity(appeared ? 1 : 0)
                    } else {
                        TarotCardFront(card: card, isReversed: false, size: .large)
                            .scaleEffect(appeared ? 1 : 0.8)
                            .opacity(appeared ? 1 : 0)
                    }

                    // Card name and arcana
                    VStack(spacing: 8) {
                        Text(card.name)
                            .font(.cosmicTitle(26))
                            .foregroundStyle(Color.cosmicText)

                        HStack(spacing: 8) {
                            Text(card.arcana.symbol)
                            Text(card.arcana.displayName)
                                .font(.cosmicCaption())
                                .foregroundStyle(Color.cosmicTextSecondary)
                            if card.arcana == .major {
                                Text("· \(card.romanNumeral)")
                                    .font(.cosmicCaption())
                                    .foregroundStyle(Color.cosmicGold)
                            }
                        }
                    }
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)

                    // Keywords
                    HStack(spacing: 8) {
                        ForEach(card.keywords, id: \.self) { keyword in
                            Text(keyword)
                                .font(.cosmicCaption(12))
                                .foregroundStyle(Color.cosmicPurple)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule().fill(Color.cosmicPurple.opacity(0.12))
                                )
                        }
                    }
                    .opacity(appeared ? 1 : 0)

                    // Meanings
                    VStack(spacing: 16) {
                        meaningSection(
                            title: "Sens droit",
                            icon: "arrow.up.circle.fill",
                            color: .cosmicGold,
                            text: card.uprightMeaning
                        )

                        meaningSection(
                            title: "Sens inversé",
                            icon: "arrow.down.circle.fill",
                            color: .cosmicRose,
                            text: card.reversedMeaning
                        )
                    }
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 30)

                    // Divider
                    HStack(spacing: 12) {
                        Rectangle().fill(Color.cosmicDivider).frame(height: 1)
                        Text("✦").font(.system(size: 10)).foregroundStyle(Color.cosmicGold)
                        Rectangle().fill(Color.cosmicDivider).frame(height: 1)
                    }
                    .padding(.horizontal)

                    // Context interpretations
                    VStack(spacing: 14) {
                        Text("Interprétations")
                            .font(.cosmicHeadline(18))
                            .foregroundStyle(Color.cosmicGold)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        contextRow(icon: "sparkles", label: "Général", text: card.interpretation.general)
                        contextRow(icon: "heart.fill", label: "Amour", text: card.interpretation.love)
                        contextRow(icon: "briefcase.fill", label: "Carrière", text: card.interpretation.career)
                        contextRow(icon: "leaf.fill", label: "Spirituel", text: card.interpretation.spiritual)
                    }
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 40)

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                appeared = true
            }
        }
    }

    // MARK: - Meaning Section

    private func meaningSection(title: String, icon: String, color: Color, text: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(color)

                Text(title)
                    .font(.cosmicHeadline(15))
                    .foregroundStyle(color)
            }

            Text(text)
                .font(.cosmicBody(15))
                .foregroundStyle(Color.cosmicText.opacity(0.85))
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .cosmicCard(cornerRadius: 14)
    }

    // MARK: - Context Row

    private func contextRow(icon: String, label: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundStyle(Color.cosmicGold)
                .frame(width: 20, height: 20)

            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.cosmicCaption(12))
                    .foregroundStyle(Color.cosmicTextSecondary)
                    .textCase(.uppercase)
                    .kerning(1)

                Text(text)
                    .font(.cosmicBody(14))
                    .foregroundStyle(Color.cosmicText.opacity(0.85))
                    .lineSpacing(3)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .cosmicCard(cornerRadius: 12)
    }
}
