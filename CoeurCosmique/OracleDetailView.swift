import SwiftUI

struct OracleDetailView: View {
    let card: OracleCard
    @EnvironmentObject var storeManager: StoreManager
    @State private var showPaywall = false
    @State private var showFullScreen = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Card image
                OracleCardFront(card: card, size: .large)
                    .padding(.top, 16)
                    .onTapGesture { showFullScreen = true }

                // Card info
                VStack(spacing: 12) {
                    Text("N° \(card.number)")
                        .font(.cosmicCaption())
                        .foregroundStyle(Color.cosmicRose)
                        .textCase(.uppercase)
                        .kerning(2)

                    Text(card.name)
                        .font(.cosmicTitle(26))
                        .foregroundStyle(Color.cosmicText)
                        .multilineTextAlignment(.center)
                }

                // Keywords
                HStack(spacing: 8) {
                    ForEach(card.keywords, id: \.self) { keyword in
                        Text(keyword)
                            .font(.cosmicCaption(12))
                            .foregroundStyle(Color.cosmicRose)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule().fill(Color.cosmicRose.opacity(0.12))
                            )
                    }
                }

                // Message
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Rectangle()
                            .fill(Color.cosmicDivider)
                            .frame(height: 1)
                        Text("♡")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.cosmicRose)
                        Rectangle()
                            .fill(Color.cosmicDivider)
                            .frame(height: 1)
                    }

                    Text(card.message)
                        .font(.cosmicBody(16))
                        .foregroundStyle(Color.cosmicText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .italic()
                        .padding(.horizontal, 8)
                }
                .padding(20)
                .cosmicCard()

                // Extended meaning (premium)
                if storeManager.isPremium {
                    VStack(spacing: 12) {
                        Text("Guidance approfondie")
                            .font(.cosmicHeadline(16))
                            .foregroundStyle(Color.cosmicRose)

                        Text(card.extendedMeaning)
                            .font(.cosmicBody(15))
                            .foregroundStyle(Color.cosmicTextSecondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }
                    .padding(20)
                    .cosmicCard()
                } else {
                    // Premium upsell
                    VStack(spacing: 12) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.cosmicGold)

                        Text("Guidance approfondie")
                            .font(.cosmicHeadline(16))
                            .foregroundStyle(Color.cosmicText)

                        Text(card.extendedMeaning)
                            .font(.cosmicBody(14))
                            .foregroundStyle(Color.cosmicTextSecondary)
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                            .lineLimit(3)
                            .blur(radius: 4)
                            .padding(.horizontal, 8)

                        Button {
                            showPaywall = true
                        } label: {
                            Text("Débloquer la guidance complète")
                                .font(.cosmicHeadline(14))
                                .foregroundStyle(Color.cosmicBackground)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule().fill(LinearGradient.cosmicGoldGradient)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(20)
                    .cosmicCard()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color.cosmicGold.opacity(0.2), lineWidth: 1)
                    )
                }

                Spacer(minLength: 40)
            }
            .padding(.horizontal, 20)
        }
        .background(Color.cosmicBackground)
        .sheet(isPresented: $showPaywall) {
            PaywallView(storeManager: storeManager)
        }
        .overlay {
            if showFullScreen {
                FullScreenCardView(content: .oracle(card)) {
                    showFullScreen = false
                }
            }
        }
    }
}
