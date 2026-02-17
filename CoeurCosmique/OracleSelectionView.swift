import SwiftUI

// MARK: - Oracle Type

enum OracleType: String, CaseIterable, Identifiable {
    case cosmicHeart
    case quantumEntanglement
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .cosmicHeart:
            return "Cosmic Heart Oracle"
        case .quantumEntanglement:
            return "Oracle Quantique"
        }
    }
    
    var subtitle: String {
        switch self {
        case .cosmicHeart:
            return "Messages du cœur cosmique"
        case .quantumEntanglement:
            return "Intrication quantique de l'âme"
        }
    }
    
    var icon: String {
        switch self {
        case .cosmicHeart:
            return "♡"
        case .quantumEntanglement:
            return "∞"
        }
    }
    
    var color: Color {
        switch self {
        case .cosmicHeart:
            return .cosmicRose
        case .quantumEntanglement:
            return .cosmicPurple
        }
    }
    
    var isPremium: Bool {
        switch self {
        case .cosmicHeart:
            return false
        case .quantumEntanglement:
            return true
        }
    }
}

// MARK: - Oracle Selection View

struct OracleSelectionView: View {
    @ObservedObject var viewModel: AppViewModel
    @EnvironmentObject var storeManager: StoreManager
    @State private var selection: OracleType = .cosmicHeart
    @State private var showPremiumAlert = false
    @Binding var selectedOracle: OracleType?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                Text("Oracles")
                    .font(.cosmicTitle(28))
                    .foregroundStyle(Color.cosmicText)
                
                Text("Choisis ton chemin divinatoire")
                    .font(.cosmicCaption())
                    .foregroundStyle(Color.cosmicTextSecondary)
            }
            .padding(.top, 16)
            .padding(.bottom, 24)
            
            // Oracle Cards Carousel
            TabView(selection: $selection) {
                ForEach(OracleType.allCases) { oracle in
                    oracleCard(oracle)
                        .padding(.horizontal, 30)
                        .tag(oracle)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 380)
            
            // Carousel Indicators
            HStack(spacing: 8) {
                ForEach(OracleType.allCases) { oracle in
                    Circle()
                        .fill(selection == oracle ? oracle.color : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .animation(.spring(response: 0.3), value: selection)
                }
            }
            .padding(.top, 16)
            
            Spacer()
            
            // Selection Button
            oracleSelectionButton
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
        }
        .sheet(isPresented: $showPremiumAlert) {
            PaywallView(storeManager: storeManager)
        }
    }
    
    // MARK: - Oracle Card
    
    private func oracleCard(_ oracle: OracleType) -> some View {
        VStack(spacing: 20) {
            // Icon
            VStack(spacing: 16) {
                Text(oracle.icon)
                    .font(.system(size: 60))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [oracle.color, oracle.color.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        Text(oracle.title)
                            .font(.cosmicTitle(24))
                            .foregroundStyle(Color.cosmicText)
                        
                        if oracle.isPremium && !storeManager.isPremium {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.cosmicGold)
                        }
                    }
                    
                    Text(oracle.subtitle)
                        .font(.cosmicBody(14))
                        .foregroundStyle(Color.cosmicTextSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.cosmicCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .strokeBorder(
                                oracle.color.opacity(0.3),
                                lineWidth: 1.5
                            )
                    )
            )
            .glow(oracle.color.opacity(selection == oracle ? 0.3 : 0), radius: 20)
            .scaleEffect(selection == oracle ? 1.0 : 0.92)
            .animation(.spring(response: 0.4, dampingFraction: 0.75), value: selection)
            
            // Description
            VStack(alignment: .leading, spacing: 12) {
                switch oracle {
                case .cosmicHeart:
                    descriptionItem(icon: "heart.fill", text: "Messages guidants")
                    descriptionItem(icon: "sparkles", text: "3 tirages uniques")
                    descriptionItem(icon: "star.fill", text: "42 cartes cosmiques")
                    
                case .quantumEntanglement:
                    descriptionItem(icon: "infinity", text: "Lois quantiques")
                    descriptionItem(icon: "waveform.path", text: "3 tirages spéciaux")
                    descriptionItem(icon: "sparkle.magnifyingglass", text: "42 cartes quantiques")
                }
            }
            .padding(.horizontal, 8)
        }
    }
    
    private func descriptionItem(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(selection.color)
                .frame(width: 20)
            
            Text(text)
                .font(.cosmicBody(13))
                .foregroundStyle(Color.cosmicTextSecondary)
            
            Spacer()
        }
    }
    
    // MARK: - Selection Button
    
    private var oracleSelectionButton: some View {
        Button {
            selectOracle()
        } label: {
            HStack(spacing: 10) {
                if selection.isPremium && !storeManager.isPremium {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 16, weight: .medium))
                } else {
                    Text(selection.icon)
                        .font(.system(size: 18, weight: .medium))
                }
                
                Text(selection.isPremium && !storeManager.isPremium
                     ? "Activer Premium"
                     : "Ouvrir \(selection.title)")
                    .font(.cosmicHeadline(16))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [selection.color, selection.color.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .glow(selection.color, radius: 8)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Actions
    
    private func selectOracle() {
        if selection.isPremium && !storeManager.isPremium {
            showPremiumAlert = true
        } else {
            // Navigate to the selected oracle
            selectedOracle = selection
        }
    }
}

// MARK: - Preview

#Preview {
    OracleSelectionView(viewModel: AppViewModel(), selectedOracle: .constant(nil))
        .environmentObject(StoreManager())
}
