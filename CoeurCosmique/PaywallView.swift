import SwiftUI
import StoreKit

struct PaywallView: View {
    @Binding var hasCompletedOnboarding: Bool
    @ObservedObject var storeManager: StoreManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: String = StoreManager.yearlyID
    @State private var headerOpacity: Double = 0
    @State private var featuresOpacity: Double = 0
    @State private var plansOpacity: Double = 0
    @State private var buttonOpacity: Double = 0

    private let isSheet: Bool

    // Onboarding mode
    init(hasCompletedOnboarding: Binding<Bool>, storeManager: StoreManager) {
        self._hasCompletedOnboarding = hasCompletedOnboarding
        self.storeManager = storeManager
        self.isSheet = false
    }

    // Sheet mode (in-app upsell)
    init(storeManager: StoreManager) {
        self._hasCompletedOnboarding = .constant(false)
        self.storeManager = storeManager
        self.isSheet = true
    }

    var body: some View {
        ZStack {
            CosmicBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Full-width header image with gradient
                    paywallHeader
                        .opacity(headerOpacity)

                    Spacer().frame(height: 20)

                    // Title
                    Text("Accès Premium")
                        .font(.cosmicTitle(32))
                        .foregroundStyle(
                            LinearGradient.cosmicGoldGradient
                        )
                        .opacity(headerOpacity)

                    Spacer().frame(height: 8)

                    Text("Déverrouille tout le potentiel cosmique")
                        .font(.cosmicBody(15))
                        .foregroundStyle(Color.cosmicTextSecondary)
                        .opacity(headerOpacity)

                    Spacer().frame(height: 28)

                    // Premium features
                    premiumFeatures
                        .opacity(featuresOpacity)

                    Spacer().frame(height: 28)

                    // Subscription plans
                    subscriptionPlans
                        .opacity(plansOpacity)

                    Spacer().frame(height: 24)

                    // Subscribe button
                    subscribeButton
                        .opacity(buttonOpacity)
                        .padding(.horizontal, 32)

                    Spacer().frame(height: 16)

                    // Restore + legal
                    footerLinks
                        .opacity(buttonOpacity)

                    Spacer().frame(height: 40)
                }
            }

            // Close button overlay (always visible)
            VStack {
                closeButton
                    .padding(.top, 8)
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            Task { await storeManager.loadProducts() }
            animateIn()
        }
    }

    // MARK: - Dismiss Helper

    private func handleDismiss() {
        if isSheet {
            dismiss()
        } else {
            hasCompletedOnboarding = true
        }
    }

    // MARK: - Close Button

    private var closeButton: some View {
        HStack {
            Spacer()
            Button {
                handleDismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.cosmicTextSecondary)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.08))
                    )
            }
            .buttonStyle(.plain)
            .padding(.trailing, 20)
        }
    }

    // MARK: - Header Illustration

    private var paywallHeader: some View {
        ZStack(alignment: .bottom) {
            Image("paywall-header")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity)
                .frame(height: 320)
                .clipped()

            // Bottom gradient fade
            LinearGradient(
                colors: [
                    Color.clear,
                    Color(red: 0.04, green: 0.04, blue: 0.10).opacity(0.7),
                    Color(red: 0.04, green: 0.04, blue: 0.10)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 100)
        }
    }

    // MARK: - Premium Features

    private var premiumFeatures: some View {
        VStack(spacing: 18) {
            premiumFeatureRow(
                icon: "infinity",
                title: "Tirages illimités",
                subtitle: "Consulte le Tarot autant que tu veux"
            )
            premiumFeatureRow(
                icon: "book.closed.fill",
                title: "Journal complet",
                subtitle: "Retrouve toutes tes lectures passées"
            )
            premiumFeatureRow(
                icon: "sparkles.rectangle.stack.fill",
                title: "Descriptions détaillées",
                subtitle: "Accède aux interprétations de chaque carte"
            )
            premiumFeatureRow(
                icon: "books.vertical.fill",
                title: "Bibliothèque du Tarot",
                subtitle: "Approfondis tes connaissances"
            )
        }
        .padding(.horizontal, 32)
    }

    private func premiumFeatureRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundStyle(Color.cosmicGold)
                .frame(width: 40, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.cosmicGold.opacity(0.12))
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.cosmicHeadline(16))
                    .foregroundStyle(Color.cosmicText)

                Text(subtitle)
                    .font(.cosmicCaption(13))
                    .foregroundStyle(Color.cosmicTextSecondary)
            }

            Spacer()
        }
    }

    // MARK: - Subscription Plans

    private var subscriptionPlans: some View {
        VStack(spacing: 12) {
            planCard(
                id: StoreManager.yearlyID,
                label: "Annuel",
                price: priceText(for: StoreManager.yearlyID, fallback: "9,99 €"),
                period: "/ an",
                badge: "7 jours d'essai gratuit",
                highlight: true
            )
            planCard(
                id: StoreManager.monthlyID,
                label: "Mensuel",
                price: priceText(for: StoreManager.monthlyID, fallback: "1,99 €"),
                period: "/ mois",
                badge: nil,
                highlight: false
            )
            planCard(
                id: StoreManager.weeklyID,
                label: "Hebdomadaire",
                price: priceText(for: StoreManager.weeklyID, fallback: "0,99 €"),
                period: "/ semaine",
                badge: nil,
                highlight: false
            )
        }
        .padding(.horizontal, 24)
    }

    private func planCard(
        id: String,
        label: String,
        price: String,
        period: String,
        badge: String?,
        highlight: Bool
    ) -> some View {
        let isSelected = selectedPlan == id

        return Button {
            withAnimation(.spring(response: 0.3)) {
                selectedPlan = id
            }
        } label: {
            VStack(spacing: 0) {
                // Badge
                if let badge = badge {
                    Text(badge)
                        .font(.cosmicCaption(11))
                        .foregroundStyle(Color.cosmicBackground)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient.cosmicGoldGradient
                        )
                }

                HStack {
                    // Radio indicator
                    ZStack {
                        Circle()
                            .strokeBorder(
                                isSelected ? Color.cosmicGold : Color.cosmicTextSecondary.opacity(0.4),
                                lineWidth: 2
                            )
                            .frame(width: 22, height: 22)

                        if isSelected {
                            Circle()
                                .fill(Color.cosmicGold)
                                .frame(width: 12, height: 12)
                        }
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(label)
                            .font(.cosmicHeadline(16))
                            .foregroundStyle(Color.cosmicText)
                    }

                    Spacer()

                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text(price)
                            .font(.cosmicHeadline(20))
                            .foregroundStyle(isSelected ? Color.cosmicGold : Color.cosmicText)

                        Text(period)
                            .font(.cosmicCaption(13))
                            .foregroundStyle(Color.cosmicTextSecondary)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cosmicCard)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        isSelected ? Color.cosmicGold : Color.white.opacity(0.08),
                        lineWidth: isSelected ? 1.5 : 0.5
                    )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Subscribe Button

    private var subscribeButton: some View {
        Button {
            Task {
                if let product = storeManager.product(for: selectedPlan) {
                    await storeManager.purchase(product)
                    if storeManager.isPremium {
                        handleDismiss()
                    }
                }
            }
        } label: {
            Group {
                if storeManager.purchaseInProgress {
                    ProgressView()
                        .tint(Color.cosmicBackground)
                } else {
                    Text(selectedPlan == StoreManager.yearlyID
                         ? "Essayer gratuitement"
                         : "S'abonner")
                        .font(.cosmicHeadline(18))
                        .foregroundStyle(Color.cosmicBackground)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                Capsule()
                    .fill(LinearGradient.cosmicGoldGradient)
            )
            .glow(.cosmicGold, radius: 6)
        }
        .buttonStyle(.plain)
        .disabled(storeManager.purchaseInProgress)
    }

    // MARK: - Footer Links

    private var footerLinks: some View {
        VStack(spacing: 8) {
            Button {
                Task {
                    await storeManager.restorePurchases()
                    if storeManager.isPremium {
                        handleDismiss()
                    }
                }
            } label: {
                Text("Restaurer mes achats")
                    .font(.cosmicCaption(13))
                    .foregroundStyle(Color.cosmicTextSecondary)
            }
            .buttonStyle(.plain)

            HStack(spacing: 16) {
                Link("Conditions d'utilisation",
                     destination: URL(string: "https://oracle.marutea.fr/terms")!)
                    .font(.cosmicCaption(11))
                    .foregroundStyle(Color.cosmicTextSecondary.opacity(0.7))

                Text("·")
                    .foregroundStyle(Color.cosmicTextSecondary.opacity(0.4))

                Link("Politique de confidentialité",
                     destination: URL(string: "https://oracle.marutea.fr/privacy")!)
                    .font(.cosmicCaption(11))
                    .foregroundStyle(Color.cosmicTextSecondary.opacity(0.7))
            }

            if let error = storeManager.errorMessage {
                Text(error)
                    .font(.cosmicCaption(12))
                    .foregroundStyle(Color.cosmicRose)
                    .padding(.top, 4)
            }

            Text("L'abonnement se renouvelle automatiquement. Tu peux l'annuler à tout moment depuis les réglages de ton compte.")
                .font(.cosmicCaption(10))
                .foregroundStyle(Color.cosmicTextSecondary.opacity(0.5))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.top, 4)
        }
    }

    // MARK: - Helpers

    private func priceText(for productID: String, fallback: String) -> String {
        guard let product = storeManager.product(for: productID) else {
            return fallback
        }
        return product.displayPrice
    }

    // MARK: - Animations

    private func animateIn() {
        withAnimation(.easeOut(duration: 0.5).delay(0.1)) {
            headerOpacity = 1
        }
        withAnimation(.easeOut(duration: 0.5).delay(0.25)) {
            featuresOpacity = 1
        }
        withAnimation(.easeOut(duration: 0.5).delay(0.4)) {
            plansOpacity = 1
        }
        withAnimation(.easeOut(duration: 0.5).delay(0.55)) {
            buttonOpacity = 1
        }
    }
}

#Preview {
    PaywallView(
        hasCompletedOnboarding: .constant(false),
        storeManager: StoreManager()
    )
}
