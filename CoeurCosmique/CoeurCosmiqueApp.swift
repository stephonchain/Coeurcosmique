import SwiftUI

@main
struct CoeurCosmiqueApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var storeManager = StoreManager()
    @StateObject private var creditManager = CreditManager()
    @StateObject private var collectionManager = CardCollectionManager()
    @StateObject private var boosterManager = BoosterManager()

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
                    .environmentObject(storeManager)
                    .environmentObject(creditManager)
                    .environmentObject(collectionManager)
                    .environmentObject(boosterManager)
                    .onReceive(storeManager.$isPremium) { isPremium in
                        collectionManager.isPremium = isPremium
                    }
                    .onAppear {
                        // Grant 100 spheres when premium is first activated
                        storeManager.onPremiumActivated = {
                            let sphereManager = CosmicSphereManager.shared
                            // Only grant once per activation (check a flag)
                            let key = "premiumSpheresBonusGranted"
                            if !UserDefaults.standard.bool(forKey: key) {
                                sphereManager.add(100)
                                UserDefaults.standard.set(true, forKey: key)
                            }
                        }
                    }
            } else {
                OnboardingView(
                    hasCompletedOnboarding: $hasCompletedOnboarding,
                    storeManager: storeManager
                )
            }
        }
    }
}
