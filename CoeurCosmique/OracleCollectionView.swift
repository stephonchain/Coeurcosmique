import SwiftUI

struct OracleCollectionView: View {
    @ObservedObject var viewModel: AppViewModel
    @EnvironmentObject var storeManager: StoreManager
    @State private var searchText = ""
    @State private var selectedCard: OracleCard?
    @State private var showAbout = false

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
                // Subtitle
                Text("\(viewModel.oracleDeck.count) cartes")
                    .font(.cosmicCaption())
                    .foregroundStyle(Color.cosmicTextSecondary)
                    .padding(.top, 8)

                // About button
                Button {
                    showAbout = true
                } label: {
                    HStack(spacing: 12) {
                        Text("♡")
                            .font(.system(size: 18))

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Découvrir l'Oracle Cœur Cosmique")
                                .font(.cosmicHeadline(14))
                                .foregroundStyle(Color.cosmicText)

                            Text("L'histoire, le sens et l'énergie des 42 cartes")
                                .font(.cosmicCaption(11))
                                .foregroundStyle(Color.cosmicTextSecondary)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Color.cosmicRose.opacity(0.6))
                    }
                    .padding(14)
                    .cosmicCard(cornerRadius: 14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        Color.cosmicRose.opacity(0.3),
                                        Color.cosmicPurple.opacity(0.15)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 1
                            )
                    )
                }
                .buttonStyle(.plain)

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
        .sheet(isPresented: $showAbout) {
            OracleAboutView()
        }
    }
}
