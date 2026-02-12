import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @ObservedObject var storeManager: StoreManager
    @State private var currentPage = 0
    @State private var showPaywall = false

    // Animation states
    @State private var illustrationOpacity: Double = 0
    @State private var titleOffset: CGFloat = 30
    @State private var titleOpacity: Double = 0
    @State private var subtitleOffset: CGFloat = 20
    @State private var subtitleOpacity: Double = 0
    @State private var featuresOpacity: Double = 0

    private let pages = OnboardingPage.allPages

    var body: some View {
        ZStack {
            CosmicBackground()

            if showPaywall {
                PaywallView(
                    hasCompletedOnboarding: $hasCompletedOnboarding,
                    storeManager: storeManager
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
            } else {
                onboardingContent
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Onboarding Content

    private var onboardingContent: some View {
        GeometryReader { geo in
            let topHalf = geo.size.height * 0.48

            ZStack(alignment: .top) {
                // Full-width illustration in top half
                pageIllustration(height: topHalf)
                    .opacity(illustrationOpacity)

                // Gradient fade at bottom of illustration
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: topHalf - 80)

                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color(red: 0.04, green: 0.04, blue: 0.10).opacity(0.6),
                            Color(red: 0.04, green: 0.04, blue: 0.10)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 80)
                }
                .allowsHitTesting(false)

                // Text content in bottom half
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: topHalf - 16)

                    // Title
                    Text(pages[currentPage].title)
                        .font(.cosmicTitle(30))
                        .foregroundStyle(Color.cosmicText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .offset(y: titleOffset)
                        .opacity(titleOpacity)

                    Spacer().frame(height: 14)

                    // Subtitle
                    Text(pages[currentPage].subtitle)
                        .font(.cosmicBody(16))
                        .foregroundStyle(Color.cosmicTextSecondary)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 40)
                        .offset(y: subtitleOffset)
                        .opacity(subtitleOpacity)

                    Spacer().frame(height: 24)

                    // Feature bullets
                    if !pages[currentPage].features.isEmpty {
                        featureList
                            .opacity(featuresOpacity)
                    }

                    Spacer()

                    // Page indicators
                    pageIndicators
                        .padding(.bottom, 20)

                    // Next button
                    nextButton
                        .padding(.horizontal, 32)
                        .padding(.bottom, 50)
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .onAppear { animateIn() }
    }

    // MARK: - Page Illustration

    @ViewBuilder
    private func pageIllustration(height: CGFloat) -> some View {
        let page = pages[currentPage]

        if let videoName = page.videoFileName {
            LoopingVideoPlayer(fileName: videoName)
                .id(videoName)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .clipped()
        } else if let imageName = page.imageName {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .clipped()
        } else {
            // Fallback SF Symbol icon
            ZStack {
                Color.cosmicBackground

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [page.accentColor.opacity(0.3), Color.clear],
                            center: .center,
                            startRadius: 20,
                            endRadius: 120
                        )
                    )
                    .frame(width: 240, height: 240)

                Image(systemName: page.icon)
                    .font(.system(size: 80, weight: .thin))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [page.accentColor, page.accentColorLight],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .glow(page.accentColor, radius: 12)
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
        }
    }

    // MARK: - Feature List

    private var featureList: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(pages[currentPage].features, id: \.self) { feature in
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.cosmicGold)

                    Text(feature)
                        .font(.cosmicBody(15))
                        .foregroundStyle(Color.cosmicText)
                }
            }
        }
        .padding(.horizontal, 48)
    }

    // MARK: - Page Indicators

    private var pageIndicators: some View {
        HStack(spacing: 8) {
            ForEach(0..<pages.count, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? Color.cosmicGold : Color.cosmicTextSecondary.opacity(0.4))
                    .frame(width: index == currentPage ? 24 : 8, height: 8)
                    .animation(.spring(response: 0.4), value: currentPage)
            }
        }
    }

    // MARK: - Next Button

    private var nextButton: some View {
        Button {
            advancePage()
        } label: {
            Text(currentPage == pages.count - 1 ? "Continuer" : "Suivant")
                .font(.cosmicHeadline(18))
                .foregroundStyle(Color.cosmicBackground)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    Capsule()
                        .fill(LinearGradient.cosmicGoldGradient)
                )
                .glow(.cosmicGold, radius: 6)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Navigation

    private func advancePage() {
        if currentPage < pages.count - 1 {
            withAnimation(.easeOut(duration: 0.2)) {
                resetAnimations()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                currentPage += 1
                animateIn()
            }
        } else {
            withAnimation(.easeInOut(duration: 0.4)) {
                showPaywall = true
            }
        }
    }

    // MARK: - Animations

    private func resetAnimations() {
        illustrationOpacity = 0
        titleOffset = 30
        titleOpacity = 0
        subtitleOffset = 20
        subtitleOpacity = 0
        featuresOpacity = 0
    }

    private func animateIn() {
        withAnimation(.easeOut(duration: 0.5).delay(0.05)) {
            illustrationOpacity = 1
        }
        withAnimation(.easeOut(duration: 0.5).delay(0.15)) {
            titleOffset = 0
            titleOpacity = 1
        }
        withAnimation(.easeOut(duration: 0.5).delay(0.25)) {
            subtitleOffset = 0
            subtitleOpacity = 1
        }
        withAnimation(.easeOut(duration: 0.5).delay(0.4)) {
            featuresOpacity = 1
        }
    }
}

// MARK: - Onboarding Page Data

struct OnboardingPage {
    let icon: String
    let title: String
    let subtitle: String
    let features: [String]
    let accentColor: Color
    let accentColorLight: Color
    let videoFileName: String?
    let imageName: String?

    static let allPages: [OnboardingPage] = [
        OnboardingPage(
            icon: "sparkles",
            title: "Bienvenue dans\nCoeur Cosmique",
            subtitle: "Ton guide de Tarot personnel.\nDécouvre les messages que l'univers a pour toi.",
            features: [],
            accentColor: .cosmicGold,
            accentColorLight: .cosmicGoldLight,
            videoFileName: "onboarding-welcome",
            imageName: "onboarding-welcome"
        ),
        OnboardingPage(
            icon: "suit.heart.fill",
            title: "Tirages guidés",
            subtitle: "Choisis parmi plusieurs types de tirages et pose tes questions au Tarot.",
            features: [
                "Guidance quotidienne",
                "Passé · Présent · Futur",
                "Relations & Amour",
                "Oui / Non instantané"
            ],
            accentColor: .cosmicRose,
            accentColorLight: Color(red: 0.93, green: 0.73, blue: 0.73),
            videoFileName: "onboarding-spreads",
            imageName: "onboarding-spreads"
        ),
        OnboardingPage(
            icon: "square.grid.2x2.fill",
            title: "78 cartes à explorer",
            subtitle: "Plonge dans la signification de chaque carte du Tarot de Marseille.",
            features: [
                "Arcanes Majeurs & Mineurs",
                "Significations à l'endroit & renversé",
                "Interprétations : Amour, Carrière, Spirituel",
                "Mots-clés pour chaque carte"
            ],
            accentColor: .cosmicPurple,
            accentColorLight: .cosmicPurpleLight,
            videoFileName: nil,
            imageName: "onboarding-collection"
        ),
        OnboardingPage(
            icon: "book.fill",
            title: "Ton journal cosmique",
            subtitle: "Garde une trace de chacune de tes lectures et observe ton évolution.",
            features: [
                "Historique de tous tes tirages",
                "Retrouve tes questions passées",
                "Suis ton chemin spirituel",
                "Relis tes interprétations"
            ],
            accentColor: .cosmicGold,
            accentColorLight: .cosmicGoldLight,
            videoFileName: nil,
            imageName: "onboarding-journal"
        )
    ]
}

#Preview {
    OnboardingView(
        hasCompletedOnboarding: .constant(false),
        storeManager: StoreManager()
    )
}
