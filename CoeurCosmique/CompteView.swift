import SwiftUI

// MARK: - Compte (Account) View

struct CompteView: View {
    @ObservedObject var viewModel: AppViewModel
    @EnvironmentObject var storeManager: StoreManager
    @EnvironmentObject var collectionManager: CardCollectionManager
    @StateObject private var flashManager = FlashCardManager.shared
    @State private var showPaywall = false
    @State private var showJournal = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // Header
                Text("Mon Compte")
                    .font(.cosmicTitle(24))
                    .foregroundStyle(Color.cosmicText)
                    .padding(.top, 20)

                // Subscription status
                subscriptionSection

                // Quick links
                HStack(spacing: 12) {
                    boutiqueTile
                    journalTile
                }

                // Niveau Cosmique
                niveauCosmiqueSection

                // Legal links
                legalSection

                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(storeManager: storeManager)
        }
        .fullScreenCover(isPresented: $showJournal) {
            JournalView(viewModel: viewModel, onDismiss: { showJournal = false })
                .environmentObject(storeManager)
        }
    }

    // MARK: - Subscription Status

    private var subscriptionSection: some View {
        VStack(spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: storeManager.isPremium ? "crown.fill" : "crown")
                    .font(.system(size: 22))
                    .foregroundStyle(storeManager.isPremium ? Color.cosmicGold : Color.cosmicTextSecondary)

                VStack(alignment: .leading, spacing: 4) {
                    Text(storeManager.isPremium ? "Premium Actif" : "Gratuit")
                        .font(.cosmicHeadline(16))
                        .foregroundStyle(Color.cosmicText)

                    Text(storeManager.isPremium
                         ? "Acces illimite a toutes les fonctionnalites"
                         : "Passez Premium pour debloquer tout le contenu")
                        .font(.cosmicCaption(12))
                        .foregroundStyle(Color.cosmicTextSecondary)
                }

                Spacer()
            }

            if !storeManager.isPremium {
                Button {
                    showPaywall = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                        Text("Devenir Premium")
                            .font(.cosmicHeadline(14))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
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
            }
        }
        .padding(16)
        .cosmicCard(cornerRadius: 16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    storeManager.isPremium ? Color.cosmicGold.opacity(0.4) : Color.clear,
                    lineWidth: 1
                )
        )
    }

    // MARK: - Boutique Tile

    private var boutiqueTile: some View {
        Button {
            viewModel.selectedTab = .boutique
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: "bag.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color.cosmicGold)

                Text("Boutique")
                    .font(.cosmicHeadline(14))
                    .foregroundStyle(Color.cosmicText)

                Text("Spheres & Plus")
                    .font(.cosmicCaption(11))
                    .foregroundStyle(Color.cosmicTextSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .cosmicCard(cornerRadius: 14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(Color.cosmicGold.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Journal Tile

    private var journalTile: some View {
        Button {
            showJournal = true
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: "book.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color.cosmicPurple)

                Text("Journal")
                    .font(.cosmicHeadline(14))
                    .foregroundStyle(Color.cosmicText)

                Text("Historique")
                    .font(.cosmicCaption(11))
                    .foregroundStyle(Color.cosmicTextSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .cosmicCard(cornerRadius: 14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(Color.cosmicPurple.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Niveau Cosmique

    private var niveauCosmiqueSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.cosmicGold)
                Text("Niveau Cosmique")
                    .font(.cosmicHeadline(16))
                    .foregroundStyle(Color.cosmicText)
                Spacer()
            }

            // GOLD cards total
            HStack(spacing: 8) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.cosmicGold)
                Text("\(totalMastered()) cartes GOLD obtenues")
                    .font(.cosmicHeadline(14))
                    .foregroundStyle(Color.cosmicGold)
                Spacer()
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.cosmicGold.opacity(0.08))
            )

            // Per-deck mastery
            VStack(spacing: 10) {
                ForEach(CollectibleDeck.allCases, id: \.rawValue) { deck in
                    deckMasteryRow(deck: deck)
                }
            }

            // SRS level breakdown
            VStack(spacing: 10) {
                Text("REPARTITION PAR NIVEAU")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(Color.cosmicTextSecondary)
                    .kerning(2)
                    .frame(maxWidth: .infinity, alignment: .leading)

                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 8) {
                    srsStatCell(label: "Nouveau", count: countAtLevel(0), color: .cosmicTextSecondary)
                    srsStatCell(label: "J1", count: countAtLevel(1), color: .cyan)
                    srsStatCell(label: "J3", count: countAtLevel(2), color: .blue)
                    srsStatCell(label: "J7", count: countAtLevel(3), color: .cosmicPurple)
                    srsStatCell(label: "J31", count: countAtLevel(4), color: .cosmicGold)
                    srsStatCell(label: "Maitrise", count: totalMastered(), color: .green)
                }
            }
        }
        .padding(16)
        .cosmicCard(cornerRadius: 16)
    }

    // MARK: - Deck Mastery Row

    private func deckMasteryRow(deck: CollectibleDeck) -> some View {
        let memorized = flashManager.memorizedCount(deck: deck)
        let total = deck.totalCards
        let isMastered = memorized == total

        return VStack(spacing: 6) {
            HStack {
                Circle()
                    .fill(deck.accentColor)
                    .frame(width: 8, height: 8)

                Text(deck.title)
                    .font(.cosmicCaption(12))
                    .foregroundStyle(Color.cosmicText)

                Spacer()

                if isMastered {
                    HStack(spacing: 4) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 9))
                        Text("MAITRISE")
                            .font(.system(size: 9, weight: .bold))
                    }
                    .foregroundStyle(Color.cosmicGold)
                } else {
                    Text("\(memorized)/\(total)")
                        .font(.cosmicCaption(12))
                        .foregroundStyle(deck.accentColor)
                }
            }

            ProgressView(value: Double(memorized), total: Double(total))
                .tint(isMastered ? Color.cosmicGold : deck.accentColor)
        }
    }

    // MARK: - SRS Stat Cell

    private func srsStatCell(label: String, count: Int, color: Color) -> some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.cosmicHeadline(18))
                .foregroundStyle(color)
            Text(label)
                .font(.cosmicCaption(9))
                .foregroundStyle(Color.cosmicTextSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.08))
        )
    }

    // MARK: - Legal

    private var legalSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "doc.text")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.cosmicTextSecondary)
                Text("Informations legales")
                    .font(.cosmicHeadline(16))
                    .foregroundStyle(Color.cosmicText)
                Spacer()
            }

            Link(destination: URL(string: "https://stephonchain.github.io/Coeurcosmique/terms.html")!) {
                HStack {
                    Text("Conditions d'utilisation (EULA)")
                        .font(.cosmicBody(14))
                        .foregroundStyle(Color.cosmicText)
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.cosmicTextSecondary)
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.cosmicCard)
                )
            }

            Link(destination: URL(string: "https://stephonchain.github.io/Coeurcosmique/privacy.html")!) {
                HStack {
                    Text("Politique de confidentialite")
                        .font(.cosmicBody(14))
                        .foregroundStyle(Color.cosmicText)
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.cosmicTextSecondary)
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.cosmicCard)
                )
            }

            Button {
                Task { await storeManager.restorePurchases() }
            } label: {
                HStack {
                    Text("Restaurer mes achats")
                        .font(.cosmicBody(14))
                        .foregroundStyle(Color.cosmicText)
                    Spacer()
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.cosmicTextSecondary)
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.cosmicCard)
                )
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .cosmicCard(cornerRadius: 16)
    }

    // MARK: - Helpers

    private func countAtLevel(_ level: Int) -> Int {
        flashManager.entries.values.filter { $0.level == level }.count
    }

    private func totalMastered() -> Int {
        CollectibleDeck.allCases.reduce(0) { $0 + flashManager.memorizedCount(deck: $1) }
    }
}
