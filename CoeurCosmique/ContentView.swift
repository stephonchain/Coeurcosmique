import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AppViewModel()

    var body: some View {
        ZStack {
            CosmicBackground()

            // Manual tab switching (avoids iOS 18 TabView "More"/"Autre" bug with 6+ tabs)
            Group {
                switch viewModel.selectedTab {
                case .home:
                    HomeView(viewModel: viewModel)
                case .oracle:
                    OracleTabView(viewModel: viewModel)
                case .collection:
                    CollectionView(viewModel: viewModel)
                case .boutique:
                    BoutiqueView(viewModel: viewModel)
                case .compte:
                    CompteView(viewModel: viewModel)
                }
            }
            .animation(.easeInOut(duration: 0.15), value: viewModel.selectedTab)

            // Custom tab bar
            VStack {
                Spacer()
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
        case .oracle: return viewModel.selectedTab == tab ? "sparkles" : "sparkles"
        case .collection: return viewModel.selectedTab == tab ? "square.grid.2x2.fill" : "square.grid.2x2"
        case .boutique: return viewModel.selectedTab == tab ? "bag.fill" : "bag"
        case .compte: return viewModel.selectedTab == tab ? "person.fill" : "person"
        }
    }

    private func tabLabel(for tab: AppTab) -> String {
        switch tab {
        case .home: return "Accueil"
        case .oracle: return "Oracle"
        case .collection: return "Collection"
        case .boutique: return "Boutique"
        case .compte: return "Compte"
        }
    }
}

#Preview {
    ContentView()
}
