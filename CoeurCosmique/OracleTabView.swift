import SwiftUI

// MARK: - Oracle Tab Coordinator

struct OracleTabView: View {
    @ObservedObject var viewModel: AppViewModel
    @EnvironmentObject var storeManager: StoreManager
    @State private var selectedOracle: OracleType? = nil
    
    var body: some View {
        Group {
            if let oracle = selectedOracle {
                // Show the selected oracle
                oracleView(for: oracle)
                    .transition(.opacity)
            } else {
                // Show oracle selection carousel
                OracleSelectionView(
                    viewModel: viewModel,
                    selectedOracle: $selectedOracle
                )
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: selectedOracle)
    }
    
    @ViewBuilder
    private func oracleView(for oracle: OracleType) -> some View {
        VStack(spacing: 0) {
            // Back button
            HStack {
                Button {
                    withAnimation {
                        selectedOracle = nil
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Oracles")
                            .font(.cosmicBody(15))
                    }
                    .foregroundStyle(Color.cosmicTextSecondary)
                }
                .buttonStyle(.plain)
                .padding(.leading, 20)
                .padding(.top, 12)
                
                Spacer()
            }
            
            // Oracle content
            switch oracle {
            case .cosmicHeart:
                OracleDrawView(viewModel: viewModel)
            case .quantumEntanglement:
                if storeManager.isPremium {
                    QuantumOracleDrawView(viewModel: viewModel)
                } else {
                    PaywallView(storeManager: storeManager)
                }
            case .runesCosmiques:
                if storeManager.isPremium {
                    RuneDrawView(viewModel: viewModel)
                } else {
                    PaywallView(storeManager: storeManager)
                }
            }
        }
    }
}
