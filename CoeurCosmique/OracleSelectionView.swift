import SwiftUI

// MARK: - Oracle Type

enum OracleType: String, CaseIterable, Identifiable {
    case cosmicHeart
    case quantumEntanglement
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .cosmicHeart:
            return "Oracle Cœur Cosmique"
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
    
    // Sample cards to display in preview
    var previewCards: [PreviewCardData] {
        switch self {
        case .cosmicHeart:
            return [
                PreviewCardData(imageName: "oracle-heart-01", color: .cosmicRose),
                PreviewCardData(imageName: "oracle-heart-15", color: .cosmicRose),
                PreviewCardData(imageName: "oracle-heart-28", color: .cosmicRose)
            ]
        case .quantumEntanglement:
            return [
                PreviewCardData(imageName: "quantum-oracle-01", color: .cosmicPurple),
                PreviewCardData(imageName: "quantum-oracle-21", color: .cosmicPurple),
                PreviewCardData(imageName: "quantum-oracle-42", color: .cosmicPurple)
            ]
        }
    }
}

struct PreviewCardData {
    let imageName: String
    let color: Color
}

// MARK: - Oracle Selection View

struct OracleSelectionView: View {
    @ObservedObject var viewModel: AppViewModel
    @EnvironmentObject var storeManager: StoreManager
    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGFloat = 0
    @State private var showPremiumAlert = false
    @Binding var selectedOracle: OracleType?
    
    private let oracles = OracleType.allCases
    private var selection: OracleType {
        oracles[currentIndex]
    }
    
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
            .padding(.bottom, 32)
            
            // iPod-style Carousel
            ZStack {
                ForEach(Array(oracles.enumerated()), id: \.element) { index, oracle in
                    oracleCarouselItem(oracle, at: index)
                }
            }
            .frame(height: 450)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation.width
                    }
                    .onEnded { value in
                        let threshold: CGFloat = 50
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            if value.translation.width > threshold && currentIndex > 0 {
                                currentIndex -= 1
                            } else if value.translation.width < -threshold && currentIndex < oracles.count - 1 {
                                currentIndex += 1
                            }
                            dragOffset = 0
                        }
                    }
            )
            
            // Carousel Indicators
            HStack(spacing: 8) {
                ForEach(Array(oracles.enumerated()), id: \.element) { index, oracle in
                    Circle()
                        .fill(currentIndex == index ? oracle.color : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .animation(.spring(response: 0.3), value: currentIndex)
                }
            }
            .padding(.top, 24)
            
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
    
    // MARK: - iPod Carousel Item
    
    private func oracleCarouselItem(_ oracle: OracleType, at index: Int) -> some View {
        let offset = CGFloat(index - currentIndex)
        let screenWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = screenWidth * 0.85
        
        return VStack(spacing: 20) {
            // Visual card preview (3 cards fanned out)
            cardFanPreview(oracle)
                .frame(height: 280)
            
            // Oracle info
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Text(oracle.title)
                        .font(.cosmicTitle(20))
                        .foregroundStyle(Color.cosmicText)
                    
                    if oracle.isPremium && !storeManager.isPremium {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.cosmicGold)
                    }
                }
                
                Text(oracle.subtitle)
                    .font(.cosmicBody(13))
                    .foregroundStyle(Color.cosmicTextSecondary)
                    .multilineTextAlignment(.center)
            }
            
            // Features
            VStack(alignment: .leading, spacing: 10) {
                switch oracle {
                case .cosmicHeart:
                    featureItem(icon: "heart.fill", text: "Messages guidants", color: oracle.color)
                    featureItem(icon: "sparkles", text: "3 tirages uniques", color: oracle.color)
                    featureItem(icon: "star.fill", text: "42 cartes cosmiques", color: oracle.color)
                    
                case .quantumEntanglement:
                    featureItem(icon: "infinity", text: "Lois quantiques", color: oracle.color)
                    featureItem(icon: "waveform.path", text: "3 tirages spéciaux", color: oracle.color)
                    featureItem(icon: "sparkle.magnifyingglass", text: "42 cartes quantiques", color: oracle.color)
                }
            }
            .padding(.horizontal, 40)
        }
        .offset(x: (offset * spacing) + dragOffset)
        .scaleEffect(offset == 0 ? 1.0 : 0.75)
        .opacity(offset == 0 ? 1.0 : 0.4)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentIndex)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: dragOffset)
    }
    
    // MARK: - Card Fan Preview
    
    private func cardFanPreview(_ oracle: OracleType) -> some View {
        ZStack {
            // Back card (left)
            previewCard(oracle.previewCards[0], color: oracle.color)
                .rotationEffect(.degrees(-8))
                .offset(x: -60, y: 10)
                .scaleEffect(0.85)
                .zIndex(1)
            
            // Back card (right)
            previewCard(oracle.previewCards[2], color: oracle.color)
                .rotationEffect(.degrees(8))
                .offset(x: 60, y: 10)
                .scaleEffect(0.85)
                .zIndex(1)
            
            // Front card (center)
            previewCard(oracle.previewCards[1], color: oracle.color)
                .zIndex(2)
                .glow(oracle.color.opacity(0.4), radius: 20)
        }
    }
    
    private func previewCard(_ cardData: PreviewCardData, color: Color) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(
                LinearGradient(
                    colors: [
                        Color.cosmicCard,
                        color.opacity(0.15)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        LinearGradient(
                            colors: [color.opacity(0.6), color.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
            .overlay(
                // Card back pattern
                VStack(spacing: 12) {
                    Text(cardData.color == .cosmicRose ? "♡" : "∞")
                        .font(.system(size: 50))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [color, color.opacity(0.5)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
                    // Geometric pattern
                    ZStack {
                        Circle()
                            .strokeBorder(color.opacity(0.3), lineWidth: 1)
                            .frame(width: 60, height: 60)
                        
                        Circle()
                            .strokeBorder(color.opacity(0.2), lineWidth: 1)
                            .frame(width: 40, height: 40)
                        
                        Circle()
                            .fill(color.opacity(0.1))
                            .frame(width: 20, height: 20)
                    }
                }
            )
            .frame(width: 140, height: 220)
            .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
    }
    
    private func featureItem(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundStyle(color)
                .frame(width: 18)
            
            Text(text)
                .font(.cosmicBody(12))
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
            selectedOracle = selection
        }
    }
}

// MARK: - Preview

#Preview {
    OracleSelectionView(viewModel: AppViewModel(), selectedOracle: .constant(nil))
        .environmentObject(StoreManager())
}
