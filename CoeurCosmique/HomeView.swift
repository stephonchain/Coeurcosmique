import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: AppViewModel
    @EnvironmentObject var storeManager: StoreManager
    @EnvironmentObject var collectionManager: CardCollectionManager
    @EnvironmentObject var boosterManager: BoosterManager
    @StateObject private var gratitudeStore = GratitudeStore()
    @State private var isCardFlipped = false
    @State private var showMotivation = false
    @State private var appeared = false
    @State private var fullScreenCardContent: FullScreenCardView.CardContent? = nil
    @State private var showGratitudeSheet = false
    @State private var showBoosterOpening = false
    @State private var hasAutoOpened = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Header
                headerSection
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)

                // BOOSTER - Hero Section (bigger)
                boosterHeroSection
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 25)

                // Collection Progress (tappable)
                Button {
                    viewModel.selectedTab = .collection
                } label: {
                    collectionProgressSection
                }
                .buttonStyle(.plain)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 30)

                // Streak
                if boosterManager.streak > 1 {
                    streakSection
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 35)
                }

                // Motivational message
                motivationSection
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 40)

                // Daily card
                dailyCardSection
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

            // Auto-open booster if available
            if !hasAutoOpened && (boosterManager.canOpenBooster || boosterManager.hasPremiumBoosterAvailable(isPremium: storeManager.isPremium)) {
                hasAutoOpened = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    showBoosterOpening = true
                }
            }
        }
        .overlay {
            if let content = fullScreenCardContent {
                FullScreenCardView(content: content) {
                    fullScreenCardContent = nil
                }
            }
        }
        .fullScreenCover(isPresented: $showBoosterOpening) {
            BoosterOpeningView(
                collectionManager: collectionManager,
                boosterManager: boosterManager,
                onDismiss: { showBoosterOpening = false }
            )
            .environmentObject(storeManager)
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

    // MARK: - Booster Hero Section (BIGGER)

    private var boosterHeroSection: some View {
        VStack(spacing: 0) {
            if boosterManager.canOpenBooster || boosterManager.hasPremiumBoosterAvailable(isPremium: storeManager.isPremium) {
                // Available: big CTA
                boosterAvailableTile
            } else {
                // Not available: energy insufficient + countdown + shop link
                boosterUnavailableTile
            }
        }
    }

    private var boosterAvailableTile: some View {
        Button {
            showBoosterOpening = true
        } label: {
            VStack(spacing: 20) {
                // Large booster visual
                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(
                            LinearGradient(
                                colors: [.cosmicPurple, .cosmicRose, .cosmicGold.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 160)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .strokeBorder(Color.cosmicGold.opacity(0.5), lineWidth: 2)
                        )

                    HStack(spacing: 20) {
                        // Booster pack icon
                        ZStack {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(
                                    LinearGradient(
                                        colors: [.cosmicPurple.opacity(0.8), .cosmicRose.opacity(0.6)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 110)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .strokeBorder(Color.cosmicGold.opacity(0.6), lineWidth: 1.5)
                                )

                            VStack(spacing: 6) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 24))
                                    .foregroundStyle(.white)
                                Text("x5")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                        }
                        .shadow(color: .cosmicGold.opacity(0.5), radius: 12)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Booster Cosmique")
                                .font(.cosmicTitle(22))
                                .foregroundStyle(.white)

                            if boosterManager.hasPremiumBoosterAvailable(isPremium: storeManager.isPremium) && !boosterManager.canOpenBooster {
                                Text("Booster Premium disponible !")
                                    .font(.cosmicCaption(13))
                                    .foregroundStyle(Color.cosmicGold)
                            } else {
                                Text("Un booster t'attend !")
                                    .font(.cosmicCaption(13))
                                    .foregroundStyle(.green)
                            }

                            HStack(spacing: 8) {
                                Image(systemName: "hand.tap.fill")
                                    .font(.system(size: 14))
                                Text("Ouvrir maintenant")
                                    .font(.cosmicHeadline(14))
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.2))
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .cosmicCard(cornerRadius: 18)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .strokeBorder(Color.cosmicGold.opacity(0.5), lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }

    private var boosterUnavailableTile: some View {
        VStack(spacing: 16) {
            HStack(spacing: 14) {
                // Dimmed booster icon
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.cosmicCard)
                        .frame(width: 70, height: 95)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .strokeBorder(Color.cosmicTextSecondary.opacity(0.3), lineWidth: 1.5)
                        )

                    VStack(spacing: 4) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.cosmicTextSecondary.opacity(0.5))
                        Text("x5")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Color.cosmicTextSecondary.opacity(0.4))
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Energie Cosmique Insuffisante")
                        .font(.cosmicHeadline(15))
                        .foregroundStyle(Color.cosmicRose)

                    // Countdown
                    HStack(spacing: 6) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.cosmicTextSecondary)
                        Text("Prochain dans \(boosterManager.formattedTimeRemaining)")
                            .font(.system(size: 13, design: .monospaced))
                            .foregroundStyle(Color.cosmicTextSecondary)
                    }
                }

                Spacer()
            }

            // Shop link
            Button {
                viewModel.selectedTab = .boutique
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "bag.fill")
                        .font(.system(size: 14))
                    Text("Obtenir des Spheres Cosmiques")
                        .font(.cosmicHeadline(13))
                }
                .foregroundStyle(Color.cosmicGold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.cosmicGold.opacity(0.4), lineWidth: 1.5)
                )
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .cosmicCard(cornerRadius: 16)
    }

    // MARK: - Collection Progress

    private var collectionProgressSection: some View {
        VStack(spacing: 14) {
            HStack {
                Text("Ma Collection")
                    .font(.cosmicHeadline(16))
                    .foregroundStyle(Color.cosmicText)

                Spacer()

                HStack(spacing: 4) {
                    Text("\(collectionManager.totalOwned())/\(CardCollectionManager.totalCollectible)")
                        .font(.cosmicCaption(13))
                        .foregroundStyle(Color.cosmicGold)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Color.cosmicTextSecondary)
                }
            }

            ProgressView(value: Double(collectionManager.totalOwned()), total: Double(CardCollectionManager.totalCollectible))
                .tint(Color.cosmicGold)

            ForEach(CollectibleDeck.allCases, id: \.rawValue) { deck in
                deckProgressRow(deck: deck)
            }
        }
        .padding(16)
        .cosmicCard(cornerRadius: 16)
    }

    private func deckProgressRow(deck: CollectibleDeck) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(deck.accentColor)
                .frame(width: 8, height: 8)

            Text(deck.title)
                .font(.cosmicCaption(12))
                .foregroundStyle(Color.cosmicTextSecondary)
                .lineLimit(1)

            Spacer()

            Text("\(collectionManager.ownedCount(deck: deck))/\(deck.totalCards)")
                .font(.cosmicCaption(12))
                .foregroundStyle(deck.accentColor)

            if collectionManager.hasCompleteDeck(deck) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(.green)
            }
        }
    }

    // MARK: - Streak

    private var streakSection: some View {
        HStack(spacing: 12) {
            Image(systemName: "flame.fill")
                .font(.system(size: 22))
                .foregroundStyle(.orange)

            VStack(alignment: .leading, spacing: 2) {
                Text("Streak de \(boosterManager.streak) jours")
                    .font(.cosmicHeadline(14))
                    .foregroundStyle(Color.cosmicText)

                Text("+\(min(boosterManager.streak, 10))% de chance de carte doree")
                    .font(.cosmicCaption(11))
                    .foregroundStyle(Color.cosmicGold)
            }

            Spacer()

            HStack(spacing: 3) {
                ForEach(0..<min(boosterManager.streak, 7), id: \.self) { _ in
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 6, height: 6)
                }
            }
        }
        .padding(14)
        .cosmicCard(cornerRadius: 14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(Color.orange.opacity(0.3), lineWidth: 1)
        )
    }

    // MARK: - Motivation

    private var motivationSection: some View {
        VStack(spacing: 12) {
            Text(MotivationalMessages.messageForDate())
                .font(.cosmicBody(14))
                .foregroundStyle(Color.cosmicText.opacity(0.9))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .cosmicCard()
    }

    // MARK: - Daily Card

    private var dailyCardSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Ta carte du jour")
                    .font(.cosmicHeadline(16))
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
                VStack(spacing: 16) {
                    dailyFlippableCard(info)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    isCardFlipped = true
                                }
                            }
                        }

                    if isCardFlipped {
                        VStack(spacing: 10) {
                            Text(info.name)
                                .font(.cosmicHeadline(18))
                                .foregroundStyle(Color.cosmicText)

                            if case .tarot(_, let isReversed) = info, isReversed {
                                Text("Inversee")
                                    .font(.cosmicCaption(11))
                                    .foregroundStyle(Color.cosmicRose)
                            }

                            Text(info.message)
                                .font(.cosmicBody(14))
                                .foregroundStyle(Color.cosmicTextSecondary)
                                .multilineTextAlignment(.center)
                                .lineSpacing(3)

                            HStack(spacing: 6) {
                                ForEach(info.keywords, id: \.self) { keyword in
                                    Text(keyword)
                                        .font(.cosmicCaption(10))
                                        .foregroundStyle(Color.cosmicPurple)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(Capsule().fill(Color.cosmicPurple.opacity(0.12)))
                                }
                            }
                        }
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .padding(.vertical, 8)
            } else {
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
                        Text("Touche pour reveler ta carte")
                            .font(.cosmicCaption())
                            .foregroundStyle(Color.cosmicGold)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .cosmicCard()
    }

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
                    subtitle: "Tarot & Oracles",
                    color: .cosmicPurple
                ) {
                    viewModel.selectedTab = .oracle
                }

                QuickActionButton(
                    icon: "bag",
                    title: "Boutique",
                    subtitle: "Spheres & Plus",
                    color: .cosmicGold
                ) {
                    viewModel.selectedTab = .boutique
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
