import SwiftUI
import SceneKit

// MARK: - Booster Opening View

struct BoosterOpeningView: View {
    @EnvironmentObject var storeManager: StoreManager
    @ObservedObject var collectionManager: CardCollectionManager
    @ObservedObject var boosterManager: BoosterManager
    let onDismiss: () -> Void
    var isSphereBooster: Bool = false

    @State private var phase: BoosterPhase = .ready
    @State private var cards: [BoosterCard] = []
    @State private var boosterType: BoosterType = .commun
    @State private var currentRevealIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var packScale: CGFloat = 0.9
    @State private var packGlow: Bool = false
    @State private var floatOffset: CGFloat = 0
    @State private var fullScreenCard: BoosterCard? = nil
    @State private var showShareSheet = false
    @State private var boosterScene: SCNScene?

    enum BoosterPhase {
        case ready
        case opening
        case revealing
        case allRevealed
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
                swipeRevealPhase
            case .allRevealed:
                crossLayoutPhase
            case .done:
                resultsPhase
            }

            // Fullscreen card overlay
            if let card = fullScreenCard {
                fullScreenCardOverlay(card)
            }
        }
        .onAppear {
            // Sphere boosters skip the ready phase and open immediately
            if isSphereBooster && phase == .ready {
                openBooster()
            }
        }
    }

    // MARK: - Ready Phase

    private var readyPhase: some View {
        VStack(spacing: 0) {
            Spacer()

            // Booster pack visual - 3D model or fallback
            boosterPackVisual

            Spacer()

            // Streak indicator
            if boosterManager.streak > 1 {
                HStack(spacing: 6) {
                    Image(systemName: "flame.fill")
                        .foregroundStyle(.orange)
                    Text("Streak \(boosterManager.streak) jours")
                        .font(.cosmicCaption(12))
                        .foregroundStyle(.orange)
                    Text("Chance doree +\(min(boosterManager.streak, 10))%")
                        .font(.cosmicCaption(10))
                        .foregroundStyle(Color.cosmicGold)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Capsule().fill(Color.orange.opacity(0.15)))
                .padding(.bottom, 16)
            }

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
                VStack(spacing: 12) {
                    Text("Prochain booster dans")
                        .font(.cosmicCaption(13))
                        .foregroundStyle(Color.cosmicTextSecondary)

                    Text(boosterManager.formattedTimeRemaining)
                        .font(.system(size: 36, weight: .light, design: .monospaced))
                        .foregroundStyle(Color.cosmicGold)
                }
            }

            Button {
                onDismiss()
            } label: {
                Text("Retour")
                    .font(.cosmicCaption(14))
                    .foregroundStyle(Color.cosmicTextSecondary)
            }
            .buttonStyle(.plain)
            .padding(.vertical, 20)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                packScale = 0.95
                packGlow = true
            }
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                floatOffset = -12
            }
        }
    }

    // MARK: - Booster 3D Visual

    private var boosterPackVisual: some View {
        Group {
            if let scene = boosterScene {
                SceneView(
                    scene: scene,
                    options: [.autoenablesDefaultLighting, .allowsCameraControl]
                )
                .frame(
                    width: UIScreen.main.bounds.width * 0.75,
                    height: UIScreen.main.bounds.height * 0.40
                )
                .background(Color.clear)
                .offset(y: floatOffset)
                .shadow(color: packGlow ? .cosmicGold.opacity(0.4) : .clear, radius: packGlow ? 20 : 0)
                .scaleEffect(packScale)
            } else {
                // Fallback: gradient rectangle
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            LinearGradient(
                                colors: [.cosmicPurple, .cosmicRose, .cosmicGold],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(
                            width: UIScreen.main.bounds.width * 0.65,
                            height: UIScreen.main.bounds.height * 0.40
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .strokeBorder(Color.cosmicGold.opacity(0.6), lineWidth: 2.5)
                        )
                        .shadow(color: packGlow ? .cosmicGold.opacity(0.6) : .clear, radius: packGlow ? 25 : 0)
                        .scaleEffect(packScale)

                    VStack(spacing: 20) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 50, weight: .light))
                            .foregroundStyle(Color.white.opacity(0.9))

                        Text("BOOSTER")
                            .font(.system(size: 32, weight: .bold, design: .serif))
                            .foregroundStyle(.white)
                            .kerning(6)

                        Text("COSMIQUE")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(.white.opacity(0.7))
                            .kerning(8)

                        Text("5 CARTES")
                            .font(.cosmicCaption(13))
                            .foregroundStyle(.white.opacity(0.5))
                            .padding(.top, 8)
                    }
                    .scaleEffect(packScale)
                }
                .offset(y: floatOffset)
            }
        }
        .onAppear {
            loadBoosterScene()
        }
    }

    private func loadBoosterScene() {
        guard boosterScene == nil else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = Bundle.main.url(forResource: "Cœur_Cosmique_Booster", withExtension: "usdz"),
               let scene = try? SCNScene(url: url) {
                scene.background.contents = UIColor.clear
                DispatchQueue.main.async {
                    boosterScene = scene
                }
            }
        }
    }

    // MARK: - Opening Animation

    private var openingAnimation: some View {
        ZStack {
            ForEach(0..<20, id: \.self) { i in
                Circle()
                    .fill([Color.cosmicGold, .cosmicPurple, .cosmicRose, .white].randomElement()!)
                    .frame(width: CGFloat.random(in: 3...8))
                    .offset(
                        x: CGFloat.random(in: -180...180),
                        y: CGFloat.random(in: -250...250)
                    )
                    .opacity(Double.random(in: 0.3...1))
            }

            VStack(spacing: 16) {
                ProgressView()
                    .tint(boosterType.color)
                    .scaleEffect(2)

                Text("Ouverture...")
                    .font(.cosmicCaption(14))
                    .foregroundStyle(boosterType.color)
            }
        }
    }

    // MARK: - Swipe Reveal Phase (stacked cards, swipe to reveal)

    private var swipeRevealPhase: some View {
        VStack(spacing: 0) {
            // Booster type badge
            if boosterType != .commun {
                Text(boosterType.label)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(
                        Capsule().fill(
                            LinearGradient(
                                colors: boosterType.gradientColors,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    )
                    .padding(.top, 50)
            }

            // Progress dots
            HStack(spacing: 8) {
                ForEach(0..<cards.count, id: \.self) { index in
                    Circle()
                        .fill(index <= currentRevealIndex ? boosterType.color : Color.cosmicTextSecondary.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.top, boosterType == .commun ? 60 : 12)

            Text("\(currentRevealIndex + 1)/\(cards.count)")
                .font(.cosmicCaption(12))
                .foregroundStyle(Color.cosmicTextSecondary)
                .padding(.top, 8)

            Spacer()

            // Stacked cards
            ZStack {
                // Background stack (remaining cards)
                ForEach(Array(cards.enumerated()).reversed(), id: \.element.id) { index, card in
                    if index > currentRevealIndex {
                        cardBackView()
                            .offset(y: CGFloat(index - currentRevealIndex) * -8)
                            .scaleEffect(1.0 - CGFloat(index - currentRevealIndex) * 0.03)
                            .opacity(index - currentRevealIndex <= 3 ? 1 : 0)
                    }
                }

                // Current card (front, swipeable)
                if currentRevealIndex < cards.count {
                    let card = cards[currentRevealIndex]
                    largeCardFrontView(card: card)
                        .offset(x: dragOffset)
                        .rotationEffect(.degrees(Double(dragOffset) / 20))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    dragOffset = value.translation.width
                                }
                                .onEnded { value in
                                    let threshold: CGFloat = 80
                                    if abs(value.translation.width) > threshold {
                                        // Swipe detected - reveal next
                                        let direction: CGFloat = value.translation.width > 0 ? 1 : -1
                                        withAnimation(.easeOut(duration: 0.3)) {
                                            dragOffset = direction * 400
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            dragOffset = 0
                                            advanceCard()
                                        }
                                    } else {
                                        withAnimation(.spring(response: 0.3)) {
                                            dragOffset = 0
                                        }
                                    }
                                }
                        )
                        .onTapGesture {
                            fullScreenCard = card
                        }
                }
            }

            Spacer()

            // Swipe hint
            HStack(spacing: 16) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 14))
                Text("Glisse pour reveler la suivante")
                    .font(.cosmicCaption(13))
                Image(systemName: "arrow.right")
                    .font(.system(size: 14))
            }
            .foregroundStyle(Color.cosmicTextSecondary)
            .padding(.bottom, 50)
        }
    }

    // MARK: - Cross Layout Phase (1-3-1)

    private var crossLayoutPhase: some View {
        VStack(spacing: 0) {
            VStack(spacing: 6) {
                if boosterType != .commun {
                    Text(boosterType.shortLabel)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                        .kerning(3)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 4)
                        .background(
                            Capsule().fill(
                                LinearGradient(
                                    colors: boosterType.gradientColors,
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        )
                }
                Text("Tes cartes !")
                    .font(.cosmicTitle(24))
                    .foregroundStyle(boosterType == .cosmique ? Color.cosmicGold : Color.cosmicGold)
            }
            .padding(.top, 40)

            Spacer()

            // Cross layout: 1-3-1
            if cards.count >= 5 {
                VStack(spacing: 12) {
                    // Top row: 1 card centered
                    HStack {
                        Spacer()
                        crossCard(cards[0])
                        Spacer()
                    }

                    // Middle row: 3 cards
                    HStack(spacing: 10) {
                        crossCard(cards[1])
                        crossCard(cards[2])
                        crossCard(cards[3])
                    }

                    // Bottom row: 1 card centered
                    HStack {
                        Spacer()
                        crossCard(cards[4])
                        Spacer()
                    }
                }
                .padding(.horizontal, 16)
            }

            Spacer()

            // Stats
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
            }
            .padding(.horizontal, 20)

            // Next button → Collection
            Button {
                withAnimation {
                    phase = .done
                }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "square.grid.2x2")
                        .font(.system(size: 16))
                    Text("Voir ma Collection")
                        .font(.cosmicHeadline(16))
                }
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
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
    }

    private func crossCard(_ card: BoosterCard) -> some View {
        let cardWidth = (UIScreen.main.bounds.width - 60) / 3.2

        return VStack(spacing: 4) {
            ZStack {
                cardImageView(card: card)
                    .frame(width: cardWidth, height: cardWidth * 1.4)
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                if card.isNew {
                    VStack {
                        HStack {
                            Spacer()
                            Text("NEW")
                                .font(.system(size: 8, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(Capsule().fill(.green))
                                .offset(x: 4, y: -4)
                        }
                        Spacer()
                    }
                }
            }
            .rarityGlow(card.rarity)

            Text(cardName(card))
                .font(.cosmicCaption(9))
                .foregroundStyle(Color.cosmicText)
                .lineLimit(1)

            HStack(spacing: 2) {
                Image(systemName: card.rarity.icon)
                    .font(.system(size: 8))
                    .foregroundStyle(card.rarity.color)
                Text(card.rarity.label)
                    .font(.system(size: 8))
                    .foregroundStyle(card.rarity.color)
            }
        }
        .onTapGesture {
            fullScreenCard = card
        }
    }

    // MARK: - Results / Done Phase

    private var resultsPhase: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    if boosterType != .commun {
                        Text(boosterType.shortLabel)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.white)
                            .kerning(4)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 5)
                            .background(
                                Capsule().fill(
                                    LinearGradient(
                                        colors: boosterType.gradientColors,
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            )
                    }
                    Text("Booster ouvert !")
                        .font(.cosmicTitle(26))
                        .foregroundStyle(Color.cosmicGold)
                }
                .padding(.top, 30)

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

                ForEach(cards) { card in
                    boosterResultRow(card: card)
                }

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

    // MARK: - Large Card Views

    private func largeCardFrontView(card: BoosterCard) -> some View {
        let cardWidth = UIScreen.main.bounds.width * 0.70
        let cardHeight = cardWidth * 1.45

        return VStack(spacing: 10) {
            ZStack {
                cardImageView(card: card)
                    .frame(width: cardWidth, height: cardHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                // Rarity + New badge overlay
                VStack {
                    HStack {
                        if card.isNew {
                            Text("NOUVELLE !")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Capsule().fill(.green))
                        }
                        Spacer()
                        HStack(spacing: 4) {
                            Image(systemName: card.rarity.icon)
                                .font(.system(size: 10))
                            Text(card.rarity.label)
                                .font(.system(size: 10, weight: .bold))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(card.rarity.color.opacity(0.8)))
                    }
                    .padding(12)

                    Spacer()
                }
            }
            .rarityGlow(card.rarity)

            Text(cardName(card))
                .font(.cosmicHeadline(18))
                .foregroundStyle(Color.cosmicText)

            Text(card.deck.title)
                .font(.cosmicCaption(12))
                .foregroundStyle(Color.cosmicTextSecondary)
        }
    }

    private func cardBackView() -> some View {
        let cardWidth = UIScreen.main.bounds.width * 0.70
        let cardHeight = cardWidth * 1.45

        return RoundedRectangle(cornerRadius: 16)
            .fill(
                LinearGradient(
                    colors: [.cosmicPurple.opacity(0.8), .cosmicRose.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: cardWidth, height: cardHeight)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(Color.cosmicGold.opacity(0.4), lineWidth: 2)
            )
            .overlay(
                VStack(spacing: 12) {
                    Image(systemName: "sparkle")
                        .font(.system(size: 30))
                        .foregroundStyle(Color.cosmicGold.opacity(0.4))
                    Text("?")
                        .font(.system(size: 24, weight: .bold, design: .serif))
                        .foregroundStyle(Color.cosmicGold.opacity(0.3))
                }
            )
    }

    // MARK: - Fullscreen Card Overlay

    private func fullScreenCardOverlay(_ card: BoosterCard) -> some View {
        ZStack {
            Color.black.opacity(0.85)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation { fullScreenCard = nil }
                }

            VStack(spacing: 16) {
                cardImageView(card: card)
                    .frame(
                        width: UIScreen.main.bounds.width * 0.85,
                        height: UIScreen.main.bounds.width * 0.85 * 1.45
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .rarityGlow(card.rarity)

                Text(cardName(card))
                    .font(.cosmicTitle(22))
                    .foregroundStyle(Color.cosmicText)

                HStack(spacing: 8) {
                    Image(systemName: card.rarity.icon)
                        .foregroundStyle(card.rarity.color)
                    Text(card.rarity.label)
                        .font(.cosmicHeadline(14))
                        .foregroundStyle(card.rarity.color)
                    Text("·")
                        .foregroundStyle(Color.cosmicTextSecondary)
                    Text(card.deck.title)
                        .font(.cosmicCaption(12))
                        .foregroundStyle(Color.cosmicTextSecondary)
                }

                if card.isNew {
                    Text("NOUVELLE CARTE !")
                        .font(.cosmicHeadline(14))
                        .foregroundStyle(.green)
                }
            }
        }
        .transition(.opacity)
    }

    // MARK: - Shared Card Views

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
                VStack(spacing: 8) {
                    Text(cardSymbol(card))
                        .font(.system(size: 36, weight: .bold, design: .serif))
                        .foregroundStyle(card.deck.accentColor.opacity(0.6))
                    Text(cardName(card))
                        .font(.cosmicCaption(11))
                        .foregroundStyle(Color.cosmicTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }
            }
        }
    }

    private func boosterResultRow(card: BoosterCard) -> some View {
        HStack(spacing: 14) {
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

        let isSphere = isSphereBooster
        let isPremiumBooster = !isSphere && !boosterManager.canOpenBooster && boosterManager.hasPremiumBoosterAvailable(isPremium: storeManager.isPremium)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            if isSphere {
                cards = boosterManager.openSphereBooster(collectionManager: collectionManager)
            } else if isPremiumBooster {
                cards = boosterManager.openPremiumBooster(collectionManager: collectionManager)
            } else {
                cards = boosterManager.openBooster(collectionManager: collectionManager)
            }
            boosterType = boosterManager.lastBoosterType
            currentRevealIndex = 0
            withAnimation {
                phase = .revealing
            }
        }
    }

    private func advanceCard() {
        if currentRevealIndex < cards.count - 1 {
            currentRevealIndex += 1
        } else {
            // All cards revealed → cross layout
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                phase = .allRevealed
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

        var text = "Je viens d'ouvrir un \(boosterType.label) !\n\n"
        for card in cards {
            let emoji = card.isNew ? " (NOUVELLE)" : ""
            let rarity = card.rarity == .common ? "" : " \(card.rarity.label)"
            text += "· \(cardName(card))\(rarity)\(emoji)\n"
        }
        text += "\n\(newCount) nouvelle\(newCount > 1 ? "s" : "") · \(rareCount) rare\(rareCount > 1 ? "s" : "")+\nCollection : \(total)/\(max)\n\n#CoeurCosmique"

        return [text]
    }
}
