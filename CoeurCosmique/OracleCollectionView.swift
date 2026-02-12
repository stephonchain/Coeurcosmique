import SwiftUI

struct OracleCollectionView: View {
    @ObservedObject var viewModel: AppViewModel
    @EnvironmentObject var storeManager: StoreManager
    @State private var searchText = ""
    @State private var selectedCard: OracleCard?

    private var filteredCards: [OracleCard] {
        if searchText.isEmpty {
            return viewModel.oracleDeck
        }
        let query = searchText.lowercased()
        return viewModel.oracleDeck.filter { card in
            card.name.lowercased().contains(query) ||
            card.keywords.contains { $0.lowercased().contains(query) }
        }
    }

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
                    Text("Oracle")
                        .font(.cosmicTitle(28))
                        .foregroundStyle(Color.cosmicText)

                    Text("36 cartes · Cœur Cosmique")
                        .font(.cosmicCaption())
                        .foregroundStyle(Color.cosmicTextSecondary)
                }
                .padding(.top, 16)

                // Search
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.cosmicTextSecondary)

                    TextField("Rechercher une carte...", text: $searchText)
                        .font(.cosmicBody(14))
                        .foregroundStyle(Color.cosmicText)
                        .tint(Color.cosmicRose)
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

                // Card count
                HStack {
                    Text("\(filteredCards.count) carte\(filteredCards.count > 1 ? "s" : "")")
                        .font(.cosmicCaption(12))
                        .foregroundStyle(Color.cosmicTextSecondary)
                    Spacer()
                }

                // Grid
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredCards) { card in
                        Button {
                            selectedCard = card
                        } label: {
                            OracleCollectionCardView(card: card)
                        }
                        .buttonStyle(.plain)
                    }
                }

                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
        .sheet(item: $selectedCard) { card in
            OracleDetailView(card: card)
                .environmentObject(storeManager)
        }
    }
}
