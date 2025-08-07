import SwiftUI

@main
struct RecipesApp: App {
    let homeViewModel = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: homeViewModel)
        }
    }
}
