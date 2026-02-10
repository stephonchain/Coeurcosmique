import SwiftUI
import TarotCore

@main
struct CoeurCosmiqueApp: App {
    var body: some Scene {
        WindowGroup {
            TarotHomeView(viewModel: TarotHomeViewModel())
        }
    }
}
