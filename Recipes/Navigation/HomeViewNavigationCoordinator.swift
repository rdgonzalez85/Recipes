import SwiftUI
import Observation

@Observable
final class HomeViewNavigationCoordinator {
    var path = NavigationPath()
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
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
        let viewModel = DetailViewModel(apiService: apiService)
        return DetailView(recipe: recipe, viewModel: viewModel)
    }
}
