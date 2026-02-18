import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: AppViewModel
    @StateObject private var gratitudeStore = GratitudeStore()
    @State private var isCardFlipped = false
    @State private var showMotivation = false
    @State private var appeared = false
    @State private var fullScreenCardContent: FullScreenCardView.CardContent? = nil
    @State private var showGratitudeSheet = false

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
                
                // Gratitude Quick-Add
                gratitudeSection
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 45)

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
            if let content = fullScreenCardContent {
                FullScreenCardView(content: content) {
                    fullScreenCardContent = nil
                }
            }
        }
        .sheet(isPresented: $showGratitudeSheet) {
            GratitudeQuickView(isPresented: $showGratitudeSheet)
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

    // MARK: - Gratitude Quick-Add
    
    private var gratitudeSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.cosmicGold)
                
                Text("Gratitude")
                    .font(.cosmicHeadline(16))
                    .foregroundStyle(Color.cosmicText)
                
                Spacer()
                
                Button {
                    showGratitudeSheet = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.cosmicGold)
                }
                .buttonStyle(.plain)
            }
            
            if !gratitudeStore.entries.isEmpty {
                VStack(spacing: 8) {
                    ForEach(gratitudeStore.entries.prefix(3)) { entry in
                        HStack(spacing: 10) {
                            Text("✨")
                                .font(.system(size: 14))
                            
                            Text(entry.text)
                                .font(.cosmicBody(13))
                                .foregroundStyle(Color.cosmicTextSecondary)
                                .lineLimit(1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.cosmicGold.opacity(0.06))
                        )
                    }
                }
            } else {
                VStack(spacing: 6) {
                    Text("Ajoute tes premières gratitudes")
                        .font(.cosmicCaption(13))
                        .foregroundStyle(Color.cosmicTextSecondary.opacity(0.7))
                    
                    Text("Cultive un état d'esprit positif ✨")
                        .font(.cosmicCaption(11))
                        .foregroundStyle(Color.cosmicTextSecondary.opacity(0.5))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            }
        }
        .padding(16)
        .cosmicCard(cornerRadius: 16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.cosmicGold.opacity(0.15), lineWidth: 1)
        )
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

            if let info = viewModel.dailyCard {
                VStack(spacing: 20) {
                    dailyFlippableCard(info)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    isCardFlipped = true
                                }
                            }
                        }

                    if isCardFlipped {
                        VStack(spacing: 12) {
                            Text(info.name)
                                .font(.cosmicHeadline(20))
                                .foregroundStyle(Color.cosmicText)

                            if case .tarot(_, let isReversed) = info, isReversed {
                                Text("Inversée")
                                    .font(.cosmicCaption(12))
                                    .foregroundStyle(Color.cosmicRose)
                            }

                            Text(info.message)
                                .font(.cosmicBody(15))
                                .foregroundStyle(Color.cosmicTextSecondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(3)

                            // Keywords
                            HStack(spacing: 8) {
                                ForEach(info.keywords, id: \.self) { keyword in
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

    // MARK: - Flippable Card per Deck Type

    @ViewBuilder
    private func dailyFlippableCard(_ info: DailyCardInfo) -> some View {
        switch info {
        case .tarot(let card, let isReversed):
            FlippableTarotCard(
                card: card,
                isReversed: isReversed,
                isFlipped: $isCardFlipped,
                size: .large,
                onFullScreen: { fullScreenCardContent = info.fullScreenContent }
            )
        case .oracle(let card):
            FlippableOracleCard(
                card: card,
                isFlipped: $isCardFlipped,
                size: .large,
                onFullScreen: { fullScreenCardContent = info.fullScreenContent }
            )
        case .quantumOracle(let card):
            FlippableQuantumOracleCard(
                card: card,
                isFlipped: $isCardFlipped,
                size: .large,
                onFullScreen: { fullScreenCardContent = info.fullScreenContent }
            )
        }
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
