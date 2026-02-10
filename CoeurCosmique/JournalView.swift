import SwiftUI

struct JournalView: View {
    @ObservedObject var viewModel: AppViewModel

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

                if viewModel.history.isEmpty {
                    emptyState
                } else {
                    LazyVStack(spacing: 14) {
                        ForEach(viewModel.history) { entry in
                            JournalEntryRow(entry: entry, deck: viewModel.deck)
                        }
                    }
                }

                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            viewModel.loadHistory()
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 60)

            Text("✦")
                .font(.system(size: 40))
                .foregroundStyle(Color.cosmicGold.opacity(0.4))

            Text("Ton journal est vide")
                .font(.cosmicHeadline(18))
                .foregroundStyle(Color.cosmicText)

            Text("Tes futures lectures apparaîtront ici.\nCommence par un tirage pour écrire\nton histoire cosmique.")
                .font(.cosmicBody(14))
                .foregroundStyle(Color.cosmicTextSecondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)

            Button {
                viewModel.selectedTab = .draw
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 14))
                    Text("Faire un tirage")
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

// MARK: - Journal Entry Row

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
