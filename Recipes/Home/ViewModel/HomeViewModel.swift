import Foundation
import Observation

@Observable
final class HomeViewModel {
    enum State: Equatable {
        case loading
        case loaded([HomeViewRecipe])
        case error(String)
    }
    
    var recipes: [HomeViewRecipe]? {
        switch state {
        case .loaded(let recipes):
            return recipes
        default:
            return nil
        }
    }
    
    var error: String? {
        switch state {
        case .error(let error):
            return error
        default:
            return nil
        }
    }
    
    var state = State.loading
    
    private let apiService: APIServiceProtocol
        
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    @MainActor
    func loadRecipes() async {
        self.state = .loading
        do {
            let response = try await apiService.performRequest(Recipe.fetchAll())
            let homeViewRecipes = response.recipes.map(HomeViewRecipe.init)
            self.state = .loaded(homeViewRecipes)
        } catch let error as APIServiceError {
            self.state = .error(error.errorDescription)
        } catch {
            self.state = .error(error.localizedDescription)
        }
    }
}
