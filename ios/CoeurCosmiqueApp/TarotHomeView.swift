import SwiftUI
import TarotCore

struct TarotHomeView: View {
    @StateObject var viewModel: TarotHomeViewModel

    var body: some View {
        TabView {
            readingTab
                .tabItem {
                    Label("Tirage", systemImage: "sparkles")
                }

            historyTab
                .tabItem {
                    Label("Journal", systemImage: "book")
                }

            cardsTab
                .tabItem {
                    Label("Cartes", systemImage: "square.grid.2x2")
                }
        }
        .onAppear {
            viewModel.loadDailyCardIfNeeded()
        }
    }

    private var readingTab: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Cœur Cosmique")
                        .font(.largeTitle.bold())

                    Text("Une guidance douce et claire pour ta journée.")
                        .foregroundStyle(.secondary)

                    Picker("Type de tirage", selection: $viewModel.selectedSpread) {
                        ForEach(TarotSpreadType.allCases, id: \.self) { spread in
                            Text(spread.title).tag(spread)
                        }
                    }
                    .pickerStyle(.menu)

                    TextField("Ta question (optionnel)", text: $viewModel.question, axis: .vertical)
                        .textFieldStyle(.roundedBorder)

                    Button("Tirer les cartes") {
                        viewModel.drawCards()
                    }
                    .buttonStyle(.borderedProminent)

                    if let reading = viewModel.currentReading {
                        readingSection(reading)
                    } else {
                        ContentUnavailableView(
                            "Aucun tirage",
                            systemImage: "sparkles.rectangle.stack",
                            description: Text("Tire les cartes pour recevoir ton message.")
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Tarot")
        }
    }

    private func readingSection(_ reading: TarotReading) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(reading.spread.title)
                .font(.headline)

            if let question = reading.question {
                Text("Question: \(question)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            ForEach(Array(reading.cards.enumerated()), id: \.element.id) { index, drawn in
                VStack(alignment: .leading, spacing: 6) {
                    Text(reading.spread.labels[index])
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(drawn.card.name + (drawn.isReversed ? " (renversée)" : ""))
                        .font(.title3.bold())
                    Text(drawn.interpretation)
                    Text("Mots-clés: \(drawn.card.keywords.joined(separator: ", "))")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Text("Amour: \(drawn.card.interpretation.love)")
                        .font(.footnote)
                    Text("Pro: \(drawn.card.interpretation.career)")
                        .font(.footnote)
                }
                .padding(12)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
    }

    private var historyTab: some View {
        NavigationStack {
            List {
                if viewModel.history.isEmpty {
                    ContentUnavailableView(
                        "Journal vide",
                        systemImage: "book.closed",
                        description: Text("Tes tirages apparaîtront ici.")
                    )
                } else {
                    ForEach(viewModel.history) { entry in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(entry.spread.title)
                                .font(.headline)
                            Text(entry.question)
                                .font(.subheadline)
                            Text(entry.cardNames.joined(separator: " · "))
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            Text(entry.createdAt.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Journal")
        }
    }

    private var cardsTab: some View {
        NavigationStack {
            List(TarotDeck.riderWaiteFR) { card in
                VStack(alignment: .leading, spacing: 4) {
                    Text(card.name)
                        .font(.headline)
                    Text(card.arcana.displayName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(card.uprightMeaning)
                        .font(.subheadline)
                    Text("Mots-clés: \(card.keywords.joined(separator: ", "))")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 2)
            }
            .navigationTitle("Les 78 cartes")
        }
    }
}

#Preview {
    TarotHomeView(viewModel: TarotHomeViewModel())
}
