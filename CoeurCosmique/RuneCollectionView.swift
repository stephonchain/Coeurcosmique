import SwiftUI

// MARK: - Rune Collection Content

struct RuneCollectionContent: View {
    @ObservedObject var viewModel: AppViewModel
    @EnvironmentObject var storeManager: StoreManager
    @State private var selectedAett: RuneAett? = nil
    @State private var searchText = ""
    @State private var selectedCard: RuneCard? = nil
    @State private var showPaywall = false

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        if !storeManager.isPremium {
            premiumLockedView
        } else {
            collectionContent
        }
    }

    // MARK: - Premium Locked View

    private var premiumLockedView: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "hexagon.fill")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.cosmicGold, .cosmicRose],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            VStack(spacing: 8) {
                Text("Runes Cosmiques")
                    .font(.cosmicTitle(24))
                    .foregroundStyle(Color.cosmicText)

                Text("Fonctionnalité Premium")
                    .font(.cosmicBody(14))
                    .foregroundStyle(Color.cosmicTextSecondary)
            }

            Text("Accède aux 24 runes cosmiques de l'Ancien Futhark et leurs visions cosmiques")
                .font(.cosmicBody(13))
                .foregroundStyle(Color.cosmicTextSecondary.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button {
                showPaywall = true
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 16, weight: .medium))
                    Text("Activer Premium")
                        .font(.cosmicHeadline(16))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [.cosmicGold, .cosmicRose],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
                .glow(.cosmicGold, radius: 8)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 40)

            Spacer()
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(storeManager: storeManager)
        }
    }

    // MARK: - Collection Content

    private var collectionContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // Subtitle
                Text("\(RuneDeck.allCards.count) runes")
                    .font(.cosmicCaption())
                    .foregroundStyle(Color.cosmicTextSecondary)
                    .padding(.top, 8)

                // Search
                searchBar

                // Aett filters
                aettFilterSection

                // Card grid
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredCards) { card in
                        Button {
                            selectedCard = card
                        } label: {
                            RuneCollectionCardView(card: card)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.bottom, 100)
            }
            .padding(.horizontal, 20)
        }
        .sheet(item: $selectedCard) { card in
            RuneDetailView(card: card)
        }
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14))
                .foregroundStyle(Color.cosmicTextSecondary)

            TextField("Rechercher une rune...", text: $searchText)
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

    // MARK: - Aett Filters

    private var aettFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(title: "Toutes", isSelected: selectedAett == nil) {
                    withAnimation(.spring(response: 0.3)) {
                        selectedAett = nil
                    }
                }

                ForEach(RuneAett.allCases, id: \.self) { aett in
                    FilterChip(
                        title: aett.title,
                        isSelected: selectedAett == aett
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            selectedAett = aett
                        }
                    }
                }
            }
        }
    }

    // MARK: - Filtered Cards

    private var filteredCards: [RuneCard] {
        var cards = RuneDeck.allCards

        if let aett = selectedAett {
            cards = cards.filter { $0.aett == aett }
        }

        if !searchText.isEmpty {
            let query = searchText.lowercased()
            cards = cards.filter {
                $0.name.lowercased().contains(query) ||
                $0.conceptTraditionnel.lowercased().contains(query) ||
                $0.visionCosmique.lowercased().contains(query) ||
                $0.message.lowercased().contains(query)
            }
        }

        return cards
    }
}

// MARK: - Rune Detail View

struct RuneDetailView: View {
    let card: RuneCard
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var storeManager: StoreManager

    var body: some View {
        ZStack {
            CosmicBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // Close button
                    HStack {
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(Color.cosmicTextSecondary)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                    // Card display
                    RuneCardFront(card: card, size: .large)
                        .padding(.vertical, 20)

                    // Card info
                    VStack(spacing: 16) {
                        // Aett
                        HStack(spacing: 8) {
                            Image(systemName: card.aett.icon)
                                .font(.system(size: 16))
                                .foregroundStyle(card.aett.color)
                            Text(card.aett.title)
                                .font(.cosmicCaption(12))
                                .foregroundStyle(card.aett.color)
                                .textCase(.uppercase)
                                .kerning(1.5)
                        }

                        // Vision Cosmique chip
                        Text(card.visionCosmique)
                            .font(.cosmicCaption(11))
                            .foregroundStyle(card.aett.color)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(
                                Capsule().fill(card.aett.color.opacity(0.12))
                            )

                        Divider()
                            .background(Color.white.opacity(0.1))

                        // Concept Traditionnel
                        VStack(spacing: 8) {
                            Text("Concept Traditionnel")
                                .font(.cosmicCaption(11))
                                .foregroundStyle(Color.cosmicTextSecondary)
                                .textCase(.uppercase)
                                .kerning(1.5)

                            Text(card.conceptTraditionnel)
                                .font(.cosmicBody(14))
                                .foregroundStyle(Color.cosmicText)
                                .multilineTextAlignment(.center)
                        }

                        Divider()
                            .background(Color.white.opacity(0.1))

                        // Vision Cosmique Description
                        VStack(spacing: 8) {
                            Text("Vision Cosmique")
                                .font(.cosmicCaption(11))
                                .foregroundStyle(Color.cosmicTextSecondary)
                                .textCase(.uppercase)
                                .kerning(1.5)

                            Text(card.visionCosmiqueDescription)
                                .font(.cosmicBody(14))
                                .foregroundStyle(Color.cosmicText)
                                .multilineTextAlignment(.center)
                                .lineSpacing(3)
                        }
                        .padding(.vertical, 8)

                        Divider()
                            .background(Color.white.opacity(0.1))

                        // Message
                        VStack(spacing: 8) {
                            Text("Message")
                                .font(.cosmicCaption(11))
                                .foregroundStyle(Color.cosmicTextSecondary)
                                .textCase(.uppercase)
                                .kerning(1.5)

                            Text(card.message)
                                .font(.cosmicBody(14))
                                .foregroundStyle(Color.cosmicText)
                                .multilineTextAlignment(.center)
                                .lineSpacing(3)
                                .italic()
                        }
                        .padding(.vertical, 8)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 100)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
