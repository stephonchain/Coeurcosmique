import SwiftUI

// MARK: - Booster Opening View

struct BoosterOpeningView: View {
    @EnvironmentObject var storeManager: StoreManager
    @ObservedObject var collectionManager: CardCollectionManager
    @ObservedObject var boosterManager: BoosterManager
    let onDismiss: () -> Void

    @State private var phase: BoosterPhase = .ready
    @State private var cards: [BoosterCard] = []
    @State private var revealedIndex: Int = -1
    @State private var packScale: CGFloat = 0.8
    @State private var packRotation: Double = 0
    @State private var packGlow: Bool = false
    @State private var showShareSheet = false

    enum BoosterPhase {
        case ready
        case opening
        case revealing
        case done
    }

    var body: some View {
        ZStack {
            Color.cosmicBackground.ignoresSafeArea()

            switch phase {
            case .ready:
                readyPhase
            case .opening:
                openingAnimation
            case .revealing:
                revealingPhase
            case .done:
                resultsPhase
            }
        }
    }

    // MARK: - Ready Phase

    private var readyPhase: some View {
        VStack(spacing: 30) {
            Spacer()

            // Booster pack visual
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [.cosmicPurple, .cosmicRose, .cosmicGold],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 200, height: 300)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color.cosmicGold.opacity(0.6), lineWidth: 2)
                    )
                    .shadow(color: packGlow ? .cosmicGold.opacity(0.6) : .clear, radius: packGlow ? 20 : 0)
                    .scaleEffect(packScale)
                    .rotation3DEffect(.degrees(packRotation), axis: (x: 0, y: 1, z: 0))

                VStack(spacing: 16) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 40, weight: .light))
                        .foregroundStyle(Color.white.opacity(0.9))

                    Text("BOOSTER")
                        .font(.system(size: 24, weight: .bold, design: .serif))
                        .foregroundStyle(.white)
                        .kerning(4)

                    Text("COSMIQUE")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                        .kerning(6)

                    Text("5 CARTES")
                        .font(.cosmicCaption(11))
                        .foregroundStyle(.white.opacity(0.5))
                        .padding(.top, 8)
                }
                .scaleEffect(packScale)
            }

            // Streak indicator
            if boosterManager.streak > 1 {
                HStack(spacing: 6) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(.orange)
                    Text("Streak \(boosterManager.streak) jours")
                        .font(.cosmicCaption(12))
                        .foregroundStyle(.orange)
                    Text("Chance dorée +\(min(boosterManager.streak, 10))%")
                        .font(.cosmicCaption(10))
                        .foregroundStyle(Color.cosmicGold)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Capsule().fill(Color.orange.opacity(0.15)))
            }

            Spacer()

            // Open button
            if boosterManager.canOpenBooster || boosterManager.hasPremiumBoosterAvailable(isPremium: storeManager.isPremium) {
                Button {
                    openBooster()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "gift.fill")
                            .font(.system(size: 18))
                        Text("Ouvrir le Booster")
                            .font(.cosmicHeadline(18))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(
                                LinearGradient(
                                    colors: [.cosmicPurple, .cosmicRose],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                    .glow(.cosmicPurple, radius: 12)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 40)
            } else {
                // Countdown
                VStack(spacing: 12) {
                    Text("Prochain booster dans")
                        .font(.cosmicCaption(13))
                        .foregroundStyle(Color.cosmicTextSecondary)

                    Text(boosterManager.formattedTimeRemaining)
                        .font(.system(size: 36, weight: .light, design: .monospaced))
                        .foregroundStyle(Color.cosmicGold)
                }
            }

            // Close button
            Button {
                onDismiss()
            } label: {
                Text("Retour")
                    .font(.cosmicCaption(14))
                    .foregroundStyle(Color.cosmicTextSecondary)
            }
            .buttonStyle(.plain)
            .padding(.bottom, 20)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                packScale = 0.85
                packGlow = true
            }
        }
    }

    // MARK: - Opening Animation

    private var openingAnimation: some View {
        ZStack {
            // Particles
            ForEach(0..<20, id: \.self) { i in
                Circle()
                    .fill(Color.cosmicGold)
                    .frame(width: 4, height: 4)
                    .offset(
                        x: CGFloat.random(in: -150...150),
                        y: CGFloat.random(in: -200...200)
                    )
                    .opacity(Double.random(in: 0.3...1))
                    .animation(
                        .easeOut(duration: 1.0).delay(Double(i) * 0.05),
                        value: phase
                    )
            }

            ProgressView()
                .tint(.cosmicGold)
                .scaleEffect(2)
        }
    }

    // MARK: - Revealing Phase

    private var revealingPhase: some View {
        VStack(spacing: 20) {
            Text("Tes cartes")
                .font(.cosmicTitle(22))
                .foregroundStyle(Color.cosmicGold)
                .padding(.top, 40)

            Spacer()

            // Cards in a row
            HStack(spacing: -20) {
                ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                    let isRevealed = index <= revealedIndex

                    boosterCardView(card: card, isRevealed: isRevealed, index: index)
                        .zIndex(Double(index <= revealedIndex ? 10 + index : 5 - index))
                        .offset(y: isRevealed ? -20 : 0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: revealedIndex)
                }
            }
            .padding(.horizontal, 20)

            Spacer()

            // Tap to continue
            if revealedIndex < cards.count - 1 {
                Text("Touche pour révéler")
                    .font(.cosmicCaption(13))
                    .foregroundStyle(Color.cosmicTextSecondary)
                    .padding(.bottom, 40)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            revealNext()
        }
    }

    // MARK: - Results Phase

    private var resultsPhase: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                Text("Booster ouvert !")
                    .font(.cosmicTitle(26))
                    .foregroundStyle(Color.cosmicGold)
                    .padding(.top, 30)

                // Summary stats
                HStack(spacing: 20) {
                    statBadge(
                        value: "\(cards.filter(\.isNew).count)",
                        label: "Nouvelles",
                        color: .green
                    )
                    statBadge(
                        value: "\(cards.filter { $0.rarity >= .rare }.count)",
                        label: "Rares+",
                        color: .cosmicPurple
                    )
                    statBadge(
                        value: "\(collectionManager.totalOwned())/\(CardCollectionManager.totalCollectible)",
                        label: "Collection",
                        color: .cosmicGold
                    )
                }

                // Card results
                ForEach(cards) { card in
                    boosterResultRow(card: card)
                }

                // Share button
                Button {
                    showShareSheet = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "square.and.arrow.up")
                        Text("Partager mon booster")
                            .font(.cosmicHeadline(14))
                    }
                    .foregroundStyle(Color.cosmicGold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(Color.cosmicGold.opacity(0.5), lineWidth: 1.5)
                    )
                }
                .buttonStyle(.plain)

                // Close
                Button {
                    onDismiss()
                } label: {
                    Text("Continuer")
                        .font(.cosmicHeadline(16))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [.cosmicPurple, .cosmicRose],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                }
                .buttonStyle(.plain)

                Spacer(minLength: 40)
            }
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: $showShareSheet) {
            ActivityViewController(activityItems: boosterShareItems())
        }
    }

    // MARK: - Card Views

    private func boosterCardView(card: BoosterCard, isRevealed: Bool, index: Int) -> some View {
        ZStack {
            // Back
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [.cosmicPurple.opacity(0.8), .cosmicRose.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.cosmicGold.opacity(0.4), lineWidth: 1.5)
                )
                .overlay(
                    Image(systemName: "sparkle")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.cosmicGold.opacity(0.3))
                )
                .opacity(isRevealed ? 0 : 1)
                .rotation3DEffect(.degrees(isRevealed ? 180 : 0), axis: (x: 0, y: 1, z: 0))

            // Front
            VStack(spacing: 4) {
                // Card image or fallback
                cardImageView(card: card)
                    .frame(width: 54, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 6))

                Text(cardName(card))
                    .font(.system(size: 8, weight: .medium))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)

                // Rarity + New badge
                HStack(spacing: 2) {
                    Image(systemName: card.rarity.icon)
                        .font(.system(size: 7))
                        .foregroundStyle(card.rarity.color)

                    if card.isNew {
                        Text("NEW")
                            .font(.system(size: 6, weight: .bold))
                            .foregroundStyle(.green)
                    }
                }
            }
            .frame(width: 70, height: 110)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cosmicCard)
            )
            .rarityGlow(card.rarity)
            .opacity(isRevealed ? 1 : 0)
            .rotation3DEffect(.degrees(isRevealed ? 0 : -180), axis: (x: 0, y: 1, z: 0))
        }
        .frame(width: 70, height: 110)
    }

    @ViewBuilder
    private func cardImageView(card: BoosterCard) -> some View {
        let imageName = resolveImageName(card: card)
        if UIImage(named: imageName) != nil {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            ZStack {
                Color.cosmicCard
                Text(cardSymbol(card))
                    .font(.system(size: 20, weight: .bold, design: .serif))
                    .foregroundStyle(card.deck.accentColor.opacity(0.5))
            }
        }
    }

    private func boosterResultRow(card: BoosterCard) -> some View {
        HStack(spacing: 14) {
            // Mini image
            cardImageView(card: card)
                .frame(width: 44, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .rarityGlow(card.rarity)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(cardName(card))
                        .font(.cosmicBody(14))
                        .foregroundStyle(Color.cosmicText)

                    if card.isNew {
                        Text("NOUVELLE")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(.green)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(Color.green.opacity(0.2)))
                    }
                }

                HStack(spacing: 6) {
                    Image(systemName: card.rarity.icon)
                        .font(.system(size: 10))
                        .foregroundStyle(card.rarity.color)

                    Text(card.rarity.label)
                        .font(.cosmicCaption(11))
                        .foregroundStyle(card.rarity.color)

                    Text("·")
                        .foregroundStyle(Color.cosmicTextSecondary)

                    Text(card.deck.title)
                        .font(.cosmicCaption(10))
                        .foregroundStyle(Color.cosmicTextSecondary)
                        .lineLimit(1)
                }
            }

            Spacer()
        }
        .padding(12)
        .cosmicCard(cornerRadius: 12)
    }

    private func statBadge(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.cosmicHeadline(18))
                .foregroundStyle(color)
            Text(label)
                .font(.cosmicCaption(10))
                .foregroundStyle(Color.cosmicTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .cosmicCard(cornerRadius: 12)
    }

    // MARK: - Actions

    private func openBooster() {
        withAnimation(.easeIn(duration: 0.3)) {
            phase = .opening
        }

        // Determine which booster to open
        let isPremiumBooster = !boosterManager.canOpenBooster && boosterManager.hasPremiumBoosterAvailable(isPremium: storeManager.isPremium)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            if isPremiumBooster {
                cards = boosterManager.openPremiumBooster(collectionManager: collectionManager)
            } else {
                cards = boosterManager.openBooster(collectionManager: collectionManager)
            }
            withAnimation {
                phase = .revealing
            }
        }
    }

    private func revealNext() {
        if revealedIndex < cards.count - 1 {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                revealedIndex += 1
            }

            // Auto-transition to done after last card
            if revealedIndex == cards.count - 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation {
                        phase = .done
                    }
                }
            }
        }
    }

    // MARK: - Helpers

    private func cardName(_ card: BoosterCard) -> String {
        switch card.deck {
        case .oracle:
            return OracleDeck.allCards.first(where: { $0.number == card.number })?.name ?? "Carte \(card.number)"
        case .quantum:
            return QuantumOracleDeck.allCards.first(where: { $0.number == card.number })?.name ?? "Carte \(card.number)"
        case .rune:
            return RuneDeck.allCards.first(where: { $0.number == card.number })?.name ?? "Rune \(card.number)"
        }
    }

    private func cardSymbol(_ card: BoosterCard) -> String {
        switch card.deck {
        case .oracle: return "\(card.number)"
        case .quantum: return "∞"
        case .rune:
            return RuneDeck.allCards.first(where: { $0.number == card.number })?.letter ?? "ᚱ"
        }
    }

    private func resolveImageName(card: BoosterCard) -> String {
        switch card.deck {
        case .oracle:
            return OracleDeck.allCards.first(where: { $0.number == card.number })?.imageName ?? ""
        case .quantum:
            return QuantumOracleDeck.allCards.first(where: { $0.number == card.number })?.imageName ?? ""
        case .rune:
            return RuneDeck.allCards.first(where: { $0.number == card.number })?.imageName ?? ""
        }
    }

    private func boosterShareItems() -> [Any] {
        let newCount = cards.filter(\.isNew).count
        let rareCount = cards.filter { $0.rarity >= .rare }.count
        let total = collectionManager.totalOwned()
        let max = CardCollectionManager.totalCollectible

        var text = "Je viens d'ouvrir un Booster Cosmique !\n\n"
        for card in cards {
            let emoji = card.isNew ? " (NOUVELLE)" : ""
            let rarity = card.rarity == .common ? "" : " \(card.rarity.label)"
            text += "\(card.rarity.icon == "crown.fill" ? "👑" : card.rarity.icon == "sparkle" ? "✨" : card.rarity.icon == "star.fill" ? "⭐" : "·") \(cardName(card))\(rarity)\(emoji)\n"
        }
        text += "\n\(newCount) nouvelle\(newCount > 1 ? "s" : "") · \(rareCount) rare\(rareCount > 1 ? "s" : "")+\nCollection : \(total)/\(max)\n\n#CoeurCosmique"

        return [text]
    }
}
