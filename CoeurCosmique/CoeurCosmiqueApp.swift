import SwiftUI

@main
struct CoeurCosmiqueApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @StateObject private var storeManager = StoreManager()

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
                    .environmentObject(storeManager)
            } else {
                OnboardingView(
                    hasCompletedOnboarding: $hasCompletedOnboarding,
                    storeManager: storeManager
                )
            }
        }
    }
}
