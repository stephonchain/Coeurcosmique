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
            } else {
                OnboardingView(
                    hasCompletedOnboarding: $hasCompletedOnboarding,
                    storeManager: storeManager
                )
            }
        }
    }
}
