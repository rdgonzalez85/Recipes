import SwiftUI

@main
struct RecipesApp: App {
    private let homeViewModel = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: homeViewModel)
        }
    }
}
