import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var isCardFlipped = false
    @State private var showMotivation = false
    @State private var appeared = false

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
                        size: .large
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
