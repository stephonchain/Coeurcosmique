import SwiftUI

struct CollectionView: View {
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
                // Header
                VStack(spacing: 6) {
                    Text("Collection")
                        .font(.cosmicTitle(28))
                        .foregroundStyle(Color.cosmicText)

                    Text("\(viewModel.deck.count) cartes du Tarot de Marseille")
                        .font(.cosmicCaption())
                        .foregroundStyle(Color.cosmicTextSecondary)
                }
                .padding(.top, 16)

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
