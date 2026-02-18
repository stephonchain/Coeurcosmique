import SwiftUI

// MARK: - Quantum Oracle Collection Content

struct QuantumOracleCollectionContent: View {
    @ObservedObject var viewModel: AppViewModel
    @EnvironmentObject var storeManager: StoreManager
    @State private var selectedFamily: QuantumFamily? = nil
    @State private var searchText = ""
    @State private var selectedCard: QuantumOracleCard? = nil
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
            
            Text("∞")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.cosmicPurple, .cosmicRose],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            VStack(spacing: 8) {
                Text("Oracle du Lien Quantique")
                    .font(.cosmicTitle(24))
                    .foregroundStyle(Color.cosmicText)
                
                Text("Fonctionnalité Premium")
                    .font(.cosmicBody(14))
                    .foregroundStyle(Color.cosmicTextSecondary)
            }
            
            Text("Accède aux 42 cartes quantiques et leurs interprétations complètes")
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
                                colors: [.cosmicPurple, .cosmicRose],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
                .glow(.cosmicPurple, radius: 8)
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
                Text("\(viewModel.quantumOracleDeck.count) cartes")
                    .font(.cosmicCaption())
                    .foregroundStyle(Color.cosmicTextSecondary)
                    .padding(.top, 8)
                
                // Search
                searchBar
                
                // Family filters
                familyFilterSection
                
                // Card grid
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredCards) { card in
                        Button {
                            selectedCard = card
                        } label: {
                            QuantumOracleCollectionCardView(card: card)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.bottom, 100)
            }
            .padding(.horizontal, 20)
        }
        .sheet(item: $selectedCard) { card in
            QuantumCardDetailView(card: card, deck: viewModel.quantumOracleDeck)
        }
    }
    
    // MARK: - Search Bar
    
    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14))
                .foregroundStyle(Color.cosmicTextSecondary)
            
            TextField("Rechercher une carte...", text: $searchText)
                .font(.cosmicBody(14))
                .foregroundStyle(Color.cosmicText)
                .tint(Color.cosmicPurple)
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
    
    // MARK: - Family Filters
    
    private var familyFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(title: "Toutes", isSelected: selectedFamily == nil) {
                    withAnimation(.spring(response: 0.3)) {
                        selectedFamily = nil
                    }
                }
                
                ForEach(QuantumFamily.allCases, id: \.self) { family in
                    FilterChip(
                        title: family.title,
                        isSelected: selectedFamily == family
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            selectedFamily = family
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Filtered Cards
    
    private var filteredCards: [QuantumOracleCard] {
        var cards = viewModel.quantumOracleDeck
        
        if let family = selectedFamily {
            cards = cards.filter { $0.family == family }
        }
        
        if !searchText.isEmpty {
            let query = searchText.lowercased()
            cards = cards.filter {
                $0.name.lowercased().contains(query) ||
                $0.essence.contains { $0.lowercased().contains(query) } ||
                $0.messageProfond.lowercased().contains(query)
            }
        }
        
        return cards
    }
}

// MARK: - Quantum Card Detail View

struct QuantumCardDetailView: View {
    let card: QuantumOracleCard
    let deck: [QuantumOracleCard]
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
                    QuantumOracleCardFront(card: card, size: .large)
                        .padding(.vertical, 20)
                    
                    // Card info
                    VStack(spacing: 16) {
                        // Family
                        HStack(spacing: 8) {
                            Image(systemName: card.family.icon)
                                .font(.system(size: 16))
                            Text(card.family.title)
                                .font(.cosmicCaption(12))
                                .foregroundStyle(card.family.color)
                                .textCase(.uppercase)
                                .kerning(1.5)
                        }
                        
                        // Essence keywords
                        HStack(spacing: 6) {
                            ForEach(card.essence, id: \.self) { keyword in
                                Text(keyword)
                                    .font(.cosmicCaption(10))
                                    .foregroundStyle(card.family.color)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(
                                        Capsule().fill(card.family.color.opacity(0.12))
                                    )
                            }
                        }
                        
                        Divider()
                            .background(Color.white.opacity(0.1))
                        
                        // Deep message
                        VStack(spacing: 8) {
                            Text("Message Profond")
                                .font(.cosmicCaption(11))
                                .foregroundStyle(Color.cosmicTextSecondary)
                                .textCase(.uppercase)
                                .kerning(1.5)
                            
                            Text(card.messageProfond)
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
