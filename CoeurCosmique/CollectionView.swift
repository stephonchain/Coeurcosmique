import SwiftUI

// MARK: - Deck Picker Enum

enum CollectionDeck: String, CaseIterable {
    case oracle
    case quantumOracle
    case runes
    case tarot

    var label: String {
        switch self {
        case .oracle: return "Oracle"
        case .quantumOracle: return "Quantique"
        case .runes: return "Runes"
        case .tarot: return "Tarot"
        }
    }

    var collectibleDeck: CollectibleDeck? {
        switch self {
        case .oracle: return .oracle
        case .quantumOracle: return .quantum
        case .runes: return .rune
        case .tarot: return nil // Tarot is not collectible
        }
    }
}

// MARK: - Collection Container

struct CollectionView: View {
    @ObservedObject var viewModel: AppViewModel
    @EnvironmentObject var collectionManager: CardCollectionManager
    @State private var selectedDeck: CollectionDeck = .oracle
    @State private var showAllRarities = false

    var body: some View {
        VStack(spacing: 0) {
            // Header + stats
            VStack(spacing: 12) {
                Text("Collection")
                    .font(.cosmicTitle(28))
                    .foregroundStyle(Color.cosmicText)
                    .padding(.top, 16)

                // Global progress
                collectionStatsBar

                // Deck picker
                deckPicker
                    .padding(.horizontal, 20)

                // Rarity filter toggle (for collectible decks)
                if selectedDeck != .tarot {
                    rarityToggle
                        .padding(.horizontal, 20)
                }
            }

            // Deck content
            switch selectedDeck {
            case .oracle:
                CollectibleDeckGrid(
                    deck: .oracle,
                    cards: viewModel.oracleDeck.map { CollectibleCardData(number: $0.number, name: $0.name, imageName: $0.imageName) },
                    showAllRarities: showAllRarities,
                    viewModel: viewModel
                )
                .transition(.opacity)
            case .quantumOracle:
                CollectibleDeckGrid(
                    deck: .quantum,
                    cards: viewModel.quantumOracleDeck.map { CollectibleCardData(number: $0.number, name: $0.name, imageName: $0.imageName) },
                    showAllRarities: showAllRarities,
                    viewModel: viewModel
                )
                .transition(.opacity)
            case .runes:
                CollectibleDeckGrid(
                    deck: .rune,
                    cards: RuneDeck.allCards.map { CollectibleCardData(number: $0.number, name: $0.name, imageName: $0.imageName) },
                    showAllRarities: showAllRarities,
                    viewModel: viewModel
                )
                .transition(.opacity)
            case .tarot:
                TarotCollectionContent(viewModel: viewModel)
                    .transition(.opacity)
            }
        }
    }

    // MARK: - Collection Stats Bar

    private var collectionStatsBar: some View {
        VStack(spacing: 8) {
            HStack {
                Text("\(collectionManager.totalOwned())/\(CardCollectionManager.totalCollectible) cartes")
                    .font(.cosmicHeadline(14))
                    .foregroundStyle(Color.cosmicGold)

                Spacer()

                ForEach(CollectibleDeck.allCases, id: \.rawValue) { deck in
                    HStack(spacing: 4) {
                        Circle()
                            .fill(deck.accentColor)
                            .frame(width: 6, height: 6)
                        Text("\(collectionManager.ownedCount(deck: deck))/\(deck.totalCards)")
                            .font(.cosmicCaption(10))
                            .foregroundStyle(Color.cosmicTextSecondary)
                    }
                }
            }
            .padding(.horizontal, 20)

            ProgressView(value: Double(collectionManager.totalOwned()), total: Double(CardCollectionManager.totalCollectible))
                .tint(Color.cosmicGold)
                .padding(.horizontal, 20)
        }
    }

    // MARK: - Deck Picker

    private var deckPicker: some View {
        HStack(spacing: 0) {
            ForEach(CollectionDeck.allCases, id: \.self) { deck in
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        selectedDeck = deck
                    }
                } label: {
                    Text(deck.label)
                        .font(.cosmicCaption(12))
                        .foregroundStyle(
                            selectedDeck == deck ? Color.cosmicBackground : Color.cosmicTextSecondary
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(selectedDeck == deck ? Color.cosmicGold : Color.clear)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .background(
            Capsule()
                .fill(Color.cosmicCard)
                .overlay(
                    Capsule()
                        .strokeBorder(Color.white.opacity(0.08), lineWidth: 0.5)
                )
        )
    }

    // MARK: - Rarity Toggle

    private var rarityToggle: some View {
        HStack {
            Text(showAllRarities ? "Toutes les raretes" : "Cartes normales")
                .font(.cosmicCaption(12))
                .foregroundStyle(Color.cosmicTextSecondary)

            Spacer()

            Button {
                withAnimation(.spring(response: 0.3)) {
                    showAllRarities.toggle()
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: showAllRarities ? "sparkles" : "circle.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(showAllRarities ? Color.cosmicGold : Color.cosmicTextSecondary)

                    Text(showAllRarities ? "Toutes" : "Normales")
                        .font(.cosmicCaption(11))
                        .foregroundStyle(showAllRarities ? Color.cosmicGold : Color.cosmicTextSecondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(showAllRarities ? Color.cosmicGold.opacity(0.15) : Color.cosmicCard)
                        .overlay(
                            Capsule()
                                .strokeBorder(
                                    showAllRarities ? Color.cosmicGold.opacity(0.3) : Color.white.opacity(0.08),
                                    lineWidth: 0.5
                                )
                        )
                )
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Card Data for Collectible Grid

struct CollectibleCardData {
    let number: Int
    let name: String
    let imageName: String
}

// MARK: - Collectible Deck Grid

struct CollectibleDeckGrid: View {
    let deck: CollectibleDeck
    let cards: [CollectibleCardData]
    let showAllRarities: Bool
    @ObservedObject var viewModel: AppViewModel
    @EnvironmentObject var collectionManager: CardCollectionManager
    @State private var selectedCardNumber: Int?

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                // Deck progress
                HStack {
                    Text(deck.title)
                        .font(.cosmicCaption(12))
                        .foregroundStyle(Color.cosmicTextSecondary)

                    Spacer()

                    if collectionManager.hasCompleteDeck(deck) {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(.green)
                            Text("Complete !")
                                .font(.cosmicCaption(11))
                                .foregroundStyle(.green)
                        }
                    } else {
                        Text("\(collectionManager.ownedCount(deck: deck))/\(deck.totalCards)")
                            .font(.cosmicCaption(12))
                            .foregroundStyle(deck.accentColor)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                // Card grid
                LazyVGrid(columns: columns, spacing: 14) {
                    if showAllRarities {
                        // Show each rarity variant separately
                        ForEach(cards, id: \.number) { card in
                            ForEach(CardRarity.allCases, id: \.self) { rarity in
                                let owned = ownsWithRarity(number: card.number, rarity: rarity)
                                CollectibleCardCell(
                                    imageName: card.imageName,
                                    name: card.name,
                                    number: card.number,
                                    isOwned: owned,
                                    rarity: rarity,
                                    count: countForRarity(number: card.number, rarity: rarity),
                                    accentColor: deck.accentColor
                                )
                                .onTapGesture {
                                    if owned {
                                        selectedCardNumber = card.number
                                    }
                                }
                            }
                        }
                    } else {
                        // Show base cards only
                        ForEach(cards, id: \.number) { card in
                            let isOwned = collectionManager.owns(deck: deck, number: card.number)
                            let bestRarity = collectionManager.bestRarity(deck: deck, number: card.number)
                            let count = totalCount(number: card.number)

                            CollectibleCardCell(
                                imageName: card.imageName,
                                name: card.name,
                                number: card.number,
                                isOwned: isOwned,
                                rarity: bestRarity ?? .common,
                                count: count,
                                accentColor: deck.accentColor
                            )
                            .onTapGesture {
                                if isOwned {
                                    selectedCardNumber = card.number
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }
        }
    }

    private func ownsWithRarity(number: Int, rarity: CardRarity) -> Bool {
        if rarity == .golden {
            return collectionManager.ownsGolden(deck: deck, number: number)
        }
        let key = "\(deck.rawValue)_\(number)"
        guard let entry = collectionManager.collection[key] else { return false }
        return entry.rarity == rarity || entry.rarity > rarity
    }

    private func countForRarity(number: Int, rarity: CardRarity) -> Int {
        let key: String
        if rarity == .golden {
            key = "\(deck.rawValue)_\(number)_golden"
        } else {
            key = "\(deck.rawValue)_\(number)"
        }
        return collectionManager.collection[key]?.count ?? 0
    }

    private func totalCount(number: Int) -> Int {
        let baseKey = "\(deck.rawValue)_\(number)"
        let goldenKey = "\(deck.rawValue)_\(number)_golden"
        let base = collectionManager.collection[baseKey]?.count ?? 0
        let golden = collectionManager.collection[goldenKey]?.count ?? 0
        return base + golden
    }
}

// MARK: - Collectible Card Cell

struct CollectibleCardCell: View {
    let imageName: String
    let name: String
    let number: Int
    let isOwned: Bool
    let rarity: CardRarity
    let count: Int
    let accentColor: Color

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 6) {
                // Card image
                ZStack {
                    if !imageName.isEmpty, UIImage(named: imageName) != nil {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 140)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .saturation(isOwned ? 1.0 : 0.0)
                            .opacity(isOwned ? 1.0 : 0.4)
                    } else {
                        // Placeholder
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.cosmicCard)
                            .frame(width: 100, height: 140)
                            .overlay(
                                VStack(spacing: 4) {
                                    Text("#\(number)")
                                        .font(.cosmicCaption(14))
                                        .foregroundStyle(Color.cosmicTextSecondary.opacity(0.5))
                                    Text("?")
                                        .font(.system(size: 30))
                                        .foregroundStyle(Color.cosmicTextSecondary.opacity(0.3))
                                }
                            )
                            .saturation(isOwned ? 1.0 : 0.0)
                            .opacity(isOwned ? 1.0 : 0.4)
                    }
                }
                .rarityGlow(isOwned ? rarity : .common)

                // Card name
                Text(isOwned ? name : "???")
                    .font(.cosmicCaption(10))
                    .foregroundStyle(isOwned ? Color.cosmicText : Color.cosmicTextSecondary.opacity(0.5))
                    .lineLimit(1)
            }

            // Count badge
            if isOwned && count > 0 {
                Text("x\(count)")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(rarity == .common ? accentColor : rarity.color)
                    )
                    .offset(x: 4, y: -4)
            }
        }
    }
}

// MARK: - Tarot Collection Content

struct TarotCollectionContent: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var selectedFilter: TarotCard.Arcana? = nil
    @State private var searchText = ""
    @State private var selectedCard: TarotCard? = nil

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // Subtitle
                Text("\(viewModel.deck.count) cartes - Toujours disponibles")
                    .font(.cosmicCaption())
                    .foregroundStyle(Color.cosmicTextSecondary)
                    .padding(.top, 8)

                // Search
                searchBar

                // Filters
                filterSection

                // Card grid
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredCards) { card in
                        Button {
                            selectedCard = card
                        } label: {
                            CollectionCardView(card: card)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.bottom, 100)
            }
            .padding(.horizontal, 20)
        }
        .sheet(item: $selectedCard) { card in
            CardDetailView(card: card, deck: viewModel.deck)
        }
    }

    // MARK: - Search

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14))
                .foregroundStyle(Color.cosmicTextSecondary)

            TextField("Rechercher une carte...", text: $searchText)
                .font(.cosmicBody(14))
                .foregroundStyle(Color.cosmicText)
                .tint(Color.cosmicGold)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cosmicCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.white.opacity(0.06), lineWidth: 0.5)
                )
        )
    }

    // MARK: - Filters

    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(title: "Toutes", isSelected: selectedFilter == nil) {
                    withAnimation(.spring(response: 0.3)) { selectedFilter = nil }
                }

                ForEach(TarotCard.Arcana.allCases, id: \.self) { arcana in
                    FilterChip(
                        title: arcana.displayName,
                        isSelected: selectedFilter == arcana
                    ) {
                        withAnimation(.spring(response: 0.3)) { selectedFilter = arcana }
                    }
                }
            }
        }
    }

    // MARK: - Filtered Cards

    private var filteredCards: [TarotCard] {
        var cards = viewModel.deck

        if let filter = selectedFilter {
            cards = cards.filter { $0.arcana == filter }
        }

        if !searchText.isEmpty {
            let query = searchText.lowercased()
            cards = cards.filter {
                $0.name.lowercased().contains(query) ||
                $0.keywords.contains { $0.lowercased().contains(query) }
            }
        }

        return cards
    }
}

// MARK: - Filter Chip

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.cosmicCaption(12))
                .foregroundStyle(isSelected ? Color.cosmicBackground : Color.cosmicTextSecondary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.cosmicGold : Color.cosmicCard)
                )
                .overlay(
                    Capsule()
                        .strokeBorder(
                            isSelected ? Color.clear : Color.white.opacity(0.08),
                            lineWidth: 0.5
                        )
                )
        }
        .buttonStyle(.plain)
    }
}
