import SwiftUI
import Observation

@Observable
final class HomeViewNavigationCoordinator {
    var path = NavigationPath()
    
    func navigateToRecipeDetail(_ recipe: HomeViewRecipe) {
        path.append(recipe)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func createDetailView(for recipe: HomeViewRecipe) -> DetailView {
        return DetailView(recipe: recipe)
    }
}
