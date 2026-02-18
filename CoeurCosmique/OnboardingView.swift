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
        // Page 1 – Welcome (recentré oracles)
        OnboardingPage(
            icon: "sparkles",
            title: "Bienvenue dans\nCoeur Cosmique",
            subtitle: "Tes oracles personnels guidés par l'intelligence artificielle.\nDécouvre les messages que l'univers a pour toi.",
            features: [],
            accentColor: .cosmicGold,
            accentColorLight: .cosmicGoldLight,
            videoFileName: "onboarding-welcome",
            imageName: "onboarding-welcome"
        ),
        // Page 2 – Les Oracles (star feature)
        OnboardingPage(
            icon: "moon.stars.fill",
            title: "Deux Oracles\npuissants",
            subtitle: "Explore deux oracles uniques pour recevoir tes guidances cosmiques au quotidien.",
            features: [
                "Oracle Cœur Cosmique · 42 cartes",
                "Oracle Quantique · 44 cartes, 6 familles",
                "Tirages : Lien des Âmes, Chat de Schrödinger…",
                "Messages personnalisés à chaque tirage"
            ],
            accentColor: .cosmicPurple,
            accentColorLight: .cosmicPurpleLight,
            videoFileName: "onboarding-spreads",
            imageName: "onboarding-spreads"
        ),
        // Page 3 – Interprétation IA (nouvelle fonctionnalité)
        OnboardingPage(
            icon: "wand.and.stars",
            title: "L'IA interprète\ntes tirages",
            subtitle: "Une intelligence artificielle analyse tes cartes et te délivre une interprétation unique et personnalisée.",
            features: [
                "Interprétations unifiées par IA",
                "Analyse adaptée à ta question",
                "Vocabulaire quantique & spirituel",
                "Guidance profonde et sur mesure"
            ],
            accentColor: .cosmicRose,
            accentColorLight: Color(red: 0.93, green: 0.73, blue: 0.73),
            videoFileName: nil,
            imageName: "onboarding-collection"
        ),
        // Page 4 – Tarot & Journal (secondaire)
        OnboardingPage(
            icon: "book.fill",
            title: "Tarot & Journal\ncosmique",
            subtitle: "Explore aussi le Tarot classique et garde une trace de ton chemin spirituel.",
            features: [
                "78 cartes du Tarot à découvrir",
                "Tirages quotidien, amour, oui/non",
                "Journal de tous tes tirages",
                "Suivi de mood & gratitude"
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
