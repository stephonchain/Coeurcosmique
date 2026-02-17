import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: AppViewModel
    @StateObject private var affirmationEngine = AffirmationEngine()
    @State private var isCardFlipped = false
    @State private var showMotivation = false
    @State private var appeared = false
    @State private var fullScreenTarotCard: TarotCard? = nil
    @State private var fullScreenIsReversed = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 28) {
                // Header
                headerSection
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)

                // Motivational message
                motivationSection
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 30)

                // Daily Affirmation (if daily card exists)
                if let _ = viewModel.dailyCard {
                    affirmationSection
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 35)
                }

                // Daily card
                dailyCardSection
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 40)

                // Quick actions
                quickActionsSection
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 50)

                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .onAppear {
            viewModel.loadDailyCard()
            withAnimation(.easeOut(duration: 0.8)) {
                appeared = true
            }
            withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                showMotivation = true
            }
        }
        .overlay {
            if let card = fullScreenTarotCard {
                FullScreenCardView(content: .tarot(card, isReversed: fullScreenIsReversed)) {
                    fullScreenTarotCard = nil
                }
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text(MotivationalMessages.greeting())
                .font(.cosmicTitle(26))
                .foregroundStyle(Color.cosmicText)

            Text(formattedDate)
                .font(.cosmicCaption())
                .foregroundStyle(Color.cosmicTextSecondary)
                .textCase(.uppercase)
                .kerning(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }

    // MARK: - Motivation

    private var motivationSection: some View {
        VStack(spacing: 12) {
            Text("✦")
                .font(.system(size: 14))
                .foregroundStyle(Color.cosmicGold)

            Text(MotivationalMessages.messageForDate())
                .font(.cosmicBody(15))
                .foregroundStyle(Color.cosmicText.opacity(0.9))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .cosmicCard()
    }

    // MARK: - Daily Affirmation

    private var affirmationSection: some View {
        VStack(spacing: 14) {
            HStack {
                Text("Affirmation du jour")
                    .font(.cosmicHeadline(16))
                    .foregroundStyle(Color.cosmicRose)
                
                Spacer()
                
                Button {
                    affirmationEngine.regenerateCurrentAffirmation()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.cosmicTextSecondary)
                }
            }
            
            if let affirmation = affirmationEngine.currentAffirmation {
                Text(affirmation.text)
                    .font(.cosmicBody(15))
                    .foregroundStyle(Color.cosmicText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.vertical, 8)
                
                Button {
                    affirmationEngine.toggleFavorite(affirmation)
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: affirmationEngine.isFavorite(affirmation) ? "heart.fill" : "heart")
                            .font(.system(size: 12))
                        Text(affirmationEngine.isFavorite(affirmation) ? "Favoris" : "Ajouter aux favoris")
                            .font(.cosmicCaption(12))
                    }
                    .foregroundStyle(Color.cosmicRose)
                }
            }
        }
        .padding(16)
        .cosmicCard(cornerRadius: 16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.cosmicRose.opacity(0.2), lineWidth: 1)
        )
        .onAppear {
            if let dailyCard = viewModel.dailyCard,
               let tarotCard = dailyCard.resolve(from: viewModel.deck) {
                _ = affirmationEngine.generateAffirmation(forCard: tarotCard.name)
            }
        }
    }

    // MARK: - Daily Card

    private var dailyCardSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Ta carte du jour")
                    .font(.cosmicHeadline(18))
                    .foregroundStyle(Color.cosmicGold)

                Spacer()

                if viewModel.dailyCard != nil {
                    Button {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            isCardFlipped = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            viewModel.drawNewDailyCard()
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3)) {
                                isCardFlipped = true
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.cosmicTextSecondary)
                    }
                }
            }

            if let drawn = viewModel.dailyCard,
               let card = drawn.resolve(from: viewModel.deck) {
                VStack(spacing: 20) {
                    FlippableTarotCard(
                        card: card,
                        isReversed: drawn.isReversed,
                        isFlipped: $isCardFlipped,
                        size: .large,
                        onFullScreen: {
                            fullScreenTarotCard = card
                            fullScreenIsReversed = drawn.isReversed
                        }
                    )
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                isCardFlipped = true
                            }
                        }
                    }

                    if isCardFlipped {
                        VStack(spacing: 12) {
                            Text(card.name)
                                .font(.cosmicHeadline(20))
                                .foregroundStyle(Color.cosmicText)

                            if drawn.isReversed {
                                Text("Inversée")
                                    .font(.cosmicCaption(12))
                                    .foregroundStyle(Color.cosmicRose)
                            }

                            Text(drawn.interpretation(from: viewModel.deck))
                                .font(.cosmicBody(15))
                                .foregroundStyle(Color.cosmicTextSecondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(3)

                            // Keywords
                            HStack(spacing: 8) {
                                ForEach(card.keywords, id: \.self) { keyword in
                                    Text(keyword)
                                        .font(.cosmicCaption(11))
                                        .foregroundStyle(Color.cosmicPurple)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(
                                            Capsule()
                                                .fill(Color.cosmicPurple.opacity(0.12))
                                        )
                                }
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .padding(.vertical, 8)
            } else {
                // No card yet - draw one
                Button {
                    viewModel.drawNewDailyCard()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            isCardFlipped = true
                        }
                    }
                } label: {
                    VStack(spacing: 16) {
                        TarotCardBack(size: .large)

                        Text("Touche pour révéler ta carte")
                            .font(.cosmicCaption())
                            .foregroundStyle(Color.cosmicGold)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(20)
        .cosmicCard()
    }

    // MARK: - Quick Actions

    private var quickActionsSection: some View {
        VStack(spacing: 12) {
            Text("Explorer")
                .font(.cosmicCaption())
                .foregroundStyle(Color.cosmicTextSecondary)
                .textCase(.uppercase)
                .kerning(2)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 12) {
                QuickActionButton(
                    icon: "sparkles",
                    title: "Tirage",
                    subtitle: "Nouvelle lecture",
                    color: .cosmicPurple
                ) {
                    viewModel.selectedTab = .draw
                }

                QuickActionButton(
                    icon: "heart.circle.fill",
                    title: "Oracle",
                    subtitle: "42 cartes",
                    color: .cosmicRose
                ) {
                    viewModel.selectedTab = .oracle
                }
            }

            HStack(spacing: 12) {
                QuickActionButton(
                    icon: "square.grid.2x2",
                    title: "Collection",
                    subtitle: "78 + 42 cartes",
                    color: .cosmicGold
                ) {
                    viewModel.selectedTab = .collection
                }
            }
        }
    }

    // MARK: - Helpers

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateFormat = "EEEE d MMMM"
        return formatter.string(from: Date())
    }
}

// MARK: - Quick Action Button

struct QuickActionButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(color)

                Text(title)
                    .font(.cosmicHeadline(15))
                    .foregroundStyle(Color.cosmicText)

                Text(subtitle)
                    .font(.cosmicCaption(11))
                    .foregroundStyle(Color.cosmicTextSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .cosmicCard(cornerRadius: 16)
        }
        .buttonStyle(.plain)
    }
}
