import SwiftUI

// MARK: - Journal Section

enum JournalSection: String, CaseIterable {
    case tarot = "Tarot"
    case oracle = "Oracle"
}

struct JournalView: View {
    @ObservedObject var viewModel: AppViewModel
    @EnvironmentObject var storeManager: StoreManager
    @State private var showPaywall = false
    @State private var selectedSection: JournalSection = .tarot

    private var displayedTarotHistory: [ReadingHistoryEntry] {
        if storeManager.isPremium {
            return viewModel.history
        } else {
            return Array(viewModel.history.prefix(AppViewModel.freeJournalLimit))
        }
    }

    private var displayedOracleHistory: [OracleReadingHistoryEntry] {
        if storeManager.isPremium {
            return viewModel.oracleHistory
        } else {
            return Array(viewModel.oracleHistory.prefix(AppViewModel.freeJournalLimit))
        }
    }

    private var hasLockedTarotEntries: Bool {
        !storeManager.isPremium && viewModel.history.count > AppViewModel.freeJournalLimit
    }

    private var hasLockedOracleEntries: Bool {
        !storeManager.isPremium && viewModel.oracleHistory.count > AppViewModel.freeJournalLimit
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 6) {
                    Text("Journal")
                        .font(.cosmicTitle(28))
                        .foregroundStyle(Color.cosmicText)

                    Text("Tes lectures passées")
                        .font(.cosmicCaption())
                        .foregroundStyle(Color.cosmicTextSecondary)
                }
                .padding(.top, 16)

                // Section Picker
                sectionPicker

                // Content based on selected section
                switch selectedSection {
                case .tarot:
                    tarotSection
                case .oracle:
                    oracleSection
                }

                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            viewModel.loadHistory()
            viewModel.loadOracleHistory()
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(storeManager: storeManager)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Section Picker

    private var sectionPicker: some View {
        HStack(spacing: 0) {
            ForEach(JournalSection.allCases, id: \.self) { section in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        selectedSection = section
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: section == .tarot ? "sparkles" : "heart.fill")
                            .font(.system(size: 12))

                        Text(section.rawValue)
                            .font(.cosmicHeadline(14))
                    }
                    .foregroundStyle(
                        selectedSection == section
                            ? Color.cosmicBackground
                            : Color.cosmicTextSecondary
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(
                                selectedSection == section
                                    ? (section == .tarot
                                        ? LinearGradient(colors: [.cosmicPurple, .cosmicGold], startPoint: .leading, endPoint: .trailing)
                                        : LinearGradient(colors: [.cosmicRose, .cosmicPurple], startPoint: .leading, endPoint: .trailing))
                                    : LinearGradient(colors: [Color.clear, Color.clear], startPoint: .leading, endPoint: .trailing)
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(
            Capsule().fill(Color.cosmicCard)
        )
        .overlay(
            Capsule().strokeBorder(Color.white.opacity(0.06), lineWidth: 0.5)
        )
    }

    // MARK: - Tarot Section

    private var tarotSection: some View {
        Group {
            if viewModel.history.isEmpty {
                emptyState(
                    icon: "✦",
                    title: "Aucun tirage de Tarot",
                    subtitle: "Tes futures lectures de Tarot\napparaîtront ici.",
                    buttonLabel: "Faire un tirage",
                    buttonIcon: "sparkles",
                    action: { viewModel.selectedTab = .draw }
                )
            } else {
                LazyVStack(spacing: 14) {
                    ForEach(displayedTarotHistory) { entry in
                        JournalEntryRow(entry: entry, deck: viewModel.deck)
                    }
                }

                if hasLockedTarotEntries {
                    let lockedCount = viewModel.history.count - AppViewModel.freeJournalLimit
                    premiumUpsellCard(lockedCount: lockedCount)
                }
            }
        }
    }

    // MARK: - Oracle Section

    private var oracleSection: some View {
        Group {
            if viewModel.oracleHistory.isEmpty {
                emptyState(
                    icon: "♡",
                    title: "Aucun tirage d'Oracle",
                    subtitle: "Tes futures lectures d'Oracle\napparaîtront ici.",
                    buttonLabel: "Consulter l'Oracle",
                    buttonIcon: "heart.fill",
                    action: { viewModel.selectedTab = .oracle }
                )
            } else {
                LazyVStack(spacing: 14) {
                    ForEach(displayedOracleHistory) { entry in
                        OracleJournalEntryRow(entry: entry, deck: viewModel.oracleDeck)
                    }
                }

                if hasLockedOracleEntries {
                    let lockedCount = viewModel.oracleHistory.count - AppViewModel.freeJournalLimit
                    premiumUpsellCard(lockedCount: lockedCount)
                }
            }
        }
    }

    // MARK: - Premium Upsell

    private func premiumUpsellCard(lockedCount: Int) -> some View {
        VStack(spacing: 14) {
            Image(systemName: "lock.fill")
                .font(.system(size: 24))
                .foregroundStyle(Color.cosmicGold)

            Text("\(lockedCount) lecture\(lockedCount > 1 ? "s" : "") masquée\(lockedCount > 1 ? "s" : "")")
                .font(.cosmicHeadline(16))
                .foregroundStyle(Color.cosmicText)

            Text("Accède à tout ton historique\navec l'abonnement Premium")
                .font(.cosmicBody(13))
                .foregroundStyle(Color.cosmicTextSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(2)

            Button {
                showPaywall = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 12))
                    Text("Débloquer le journal")
                        .font(.cosmicHeadline(14))
                }
                .foregroundStyle(Color.cosmicBackground)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    Capsule().fill(LinearGradient.cosmicGoldGradient)
                )
            }
            .buttonStyle(.plain)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .cosmicCard(cornerRadius: 16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(Color.cosmicGold.opacity(0.3), lineWidth: 1)
        )
    }

    // MARK: - Empty State

    private func emptyState(
        icon: String,
        title: String,
        subtitle: String,
        buttonLabel: String,
        buttonIcon: String,
        action: @escaping () -> Void
    ) -> some View {
        VStack(spacing: 20) {
            Spacer(minLength: 60)

            Text(icon)
                .font(.system(size: 40))
                .foregroundStyle(Color.cosmicGold.opacity(0.4))

            Text(title)
                .font(.cosmicHeadline(18))
                .foregroundStyle(Color.cosmicText)

            Text(subtitle)
                .font(.cosmicBody(14))
                .foregroundStyle(Color.cosmicTextSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)

            Button {
                action()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: buttonIcon)
                        .font(.system(size: 14))
                    Text(buttonLabel)
                        .font(.cosmicHeadline(14))
                }
                .foregroundStyle(Color.cosmicBackground)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    Capsule().fill(LinearGradient.cosmicGoldGradient)
                )
            }
            .buttonStyle(.plain)
            .padding(.top, 8)
        }
    }
}

// MARK: - Tarot Journal Entry Row

struct JournalEntryRow: View {
    let entry: ReadingHistoryEntry
    let deck: [TarotCard]
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.spread.title)
                        .font(.cosmicHeadline(15))
                        .foregroundStyle(Color.cosmicText)

                    Text(formattedDate)
                        .font(.cosmicCaption(11))
                        .foregroundStyle(Color.cosmicTextSecondary)
                }

                Spacer()

                Image(systemName: entry.spread.icon)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.cosmicPurple)
            }

            if !entry.question.isEmpty {
                Text("« \(entry.question) »")
                    .font(.cosmicBody(13))
                    .foregroundStyle(Color.cosmicTextSecondary)
                    .italic()
            }

            // Cards summary
            HStack(spacing: 8) {
                ForEach(Array(entry.cardNames.enumerated()), id: \.offset) { index, name in
                    HStack(spacing: 4) {
                        if index < entry.cardReversals.count && entry.cardReversals[index] {
                            Image(systemName: "arrow.uturn.down")
                                .font(.system(size: 8))
                                .foregroundStyle(Color.cosmicRose)
                        }

                        Text(name)
                            .font(.cosmicCaption(11))
                            .foregroundStyle(Color.cosmicText)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule().fill(Color.cosmicPurple.opacity(0.12))
                    )
                }
            }

            // Expanded details
            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(Array(entry.cardNames.enumerated()), id: \.offset) { index, name in
                        if let card = deck.first(where: { $0.name == name }) {
                            let isReversed = index < entry.cardReversals.count && entry.cardReversals[index]
                            let label = index < entry.spread.labels.count ? entry.spread.labels[index] : ""

                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 6) {
                                    Text(label)
                                        .font(.cosmicCaption(10))
                                        .foregroundStyle(Color.cosmicPurple)
                                        .textCase(.uppercase)
                                        .kerning(1)

                                    Spacer()
                                }

                                Text("\(card.name)\(isReversed ? " (inversée)" : "")")
                                    .font(.cosmicBody(14))
                                    .foregroundStyle(Color.cosmicText)

                                Text(isReversed ? card.reversedMeaning : card.uprightMeaning)
                                    .font(.cosmicBody(13))
                                    .foregroundStyle(Color.cosmicTextSecondary)
                                    .lineSpacing(2)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.cosmicBackground.opacity(0.5))
                            )
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .cosmicCard(cornerRadius: 16)
        .onTapGesture {
            withAnimation(.spring(response: 0.3)) {
                isExpanded.toggle()
            }
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: entry.createdAt)
    }
}

// MARK: - Oracle Journal Entry Row

struct OracleJournalEntryRow: View {
    let entry: OracleReadingHistoryEntry
    let deck: [OracleCard]
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.spread.title)
                        .font(.cosmicHeadline(15))
                        .foregroundStyle(Color.cosmicText)

                    Text(formattedDate)
                        .font(.cosmicCaption(11))
                        .foregroundStyle(Color.cosmicTextSecondary)
                }

                Spacer()

                Image(systemName: entry.spread.icon)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.cosmicRose)
            }

            if !entry.question.isEmpty {
                Text("« \(entry.question) »")
                    .font(.cosmicBody(13))
                    .foregroundStyle(Color.cosmicTextSecondary)
                    .italic()
            }

            // Cards summary
            FlowLayout(spacing: 8) {
                ForEach(entry.cardNames, id: \.self) { name in
                    Text(name)
                        .font(.cosmicCaption(11))
                        .foregroundStyle(Color.cosmicText)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule().fill(Color.cosmicRose.opacity(0.12))
                        )
                }
            }

            // Expanded details
            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(Array(entry.cardNames.enumerated()), id: \.offset) { index, name in
                        if let card = deck.first(where: { $0.name == name }) {
                            let label = index < entry.spread.labels.count ? entry.spread.labels[index] : ""

                            VStack(alignment: .leading, spacing: 6) {
                                HStack(spacing: 6) {
                                    Text(label)
                                        .font(.cosmicCaption(10))
                                        .foregroundStyle(Color.cosmicRose)
                                        .textCase(.uppercase)
                                        .kerning(1)

                                    Spacer()
                                }

                                Text(card.name)
                                    .font(.cosmicBody(14))
                                    .foregroundStyle(Color.cosmicText)

                                Text(card.message)
                                    .font(.cosmicBody(13))
                                    .foregroundStyle(Color.cosmicTextSecondary)
                                    .italic()
                                    .lineSpacing(2)

                                HStack(spacing: 6) {
                                    ForEach(card.keywords, id: \.self) { keyword in
                                        Text(keyword)
                                            .font(.cosmicCaption(10))
                                            .foregroundStyle(Color.cosmicRose)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 3)
                                            .background(
                                                Capsule().fill(Color.cosmicRose.opacity(0.12))
                                            )
                                    }
                                }
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.cosmicBackground.opacity(0.5))
                            )
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .cosmicCard(cornerRadius: 16)
        .onTapGesture {
            withAnimation(.spring(response: 0.3)) {
                isExpanded.toggle()
            }
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: entry.createdAt)
    }
}

// MARK: - Flow Layout (for wrapping oracle card names)

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var totalHeight: CGFloat = 0
        var totalWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
            totalWidth = max(totalWidth, x - spacing)
            totalHeight = y + rowHeight
        }
        return (CGSize(width: totalWidth, height: totalHeight), positions)
    }
}
