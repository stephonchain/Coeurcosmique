import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AppViewModel()

    var body: some View {
        ZStack {
            CosmicBackground()

            TabView(selection: $viewModel.selectedTab) {
                HomeView(viewModel: viewModel)
                    .tag(AppTab.home)

                DrawView(viewModel: viewModel)
                    .tag(AppTab.draw)

                OracleTabView(viewModel: viewModel)
                    .tag(AppTab.oracle)

                CollectionView(viewModel: viewModel)
                    .tag(AppTab.collection)

                JournalView(viewModel: viewModel)
                    .tag(AppTab.journal)
            }
            .tabViewStyle(.automatic)
            .overlay(alignment: .bottom) {
                cosmicTabBar
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Custom Tab Bar

    private var cosmicTabBar: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                tabButton(for: tab)
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 12)
        .padding(.bottom, 28)
        .background(
            Rectangle()
                .fill(Color.cosmicBackground.opacity(0.95))
                .overlay(
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.05), Color.clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 1),
                    alignment: .top
                )
                .ignoresSafeArea(edges: .bottom)
        )
    }

    private func tabButton(for tab: AppTab) -> some View {
        Button {
            withAnimation(.spring(response: 0.3)) {
                viewModel.selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: tabIcon(for: tab))
                    .font(.system(size: 20, weight: viewModel.selectedTab == tab ? .semibold : .regular))
                    .foregroundStyle(
                        viewModel.selectedTab == tab ? Color.cosmicGold : Color.cosmicTextSecondary
                    )

                Text(tabLabel(for: tab))
                    .font(.cosmicCaption(10))
                    .foregroundStyle(
                        viewModel.selectedTab == tab ? Color.cosmicGold : Color.cosmicTextSecondary
                    )
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }

    private func tabIcon(for tab: AppTab) -> String {
        switch tab {
        case .home: return viewModel.selectedTab == tab ? "sun.max.fill" : "sun.max"
        case .draw: return viewModel.selectedTab == tab ? "sparkles" : "sparkles"
        case .oracle: return viewModel.selectedTab == tab ? "heart.circle.fill" : "heart.circle"
        case .collection: return viewModel.selectedTab == tab ? "square.grid.2x2.fill" : "square.grid.2x2"
        case .journal: return viewModel.selectedTab == tab ? "book.fill" : "book"
        }
    }

    private func tabLabel(for tab: AppTab) -> String {
        switch tab {
        case .home: return "Accueil"
        case .draw: return "Tirage"
        case .oracle: return "Oracle"
        case .collection: return "Collection"
        case .journal: return "Journal"
        }
    }
}

#Preview {
    ContentView()
}
