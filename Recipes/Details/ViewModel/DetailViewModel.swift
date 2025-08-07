import Foundation
import Observation

@Observable
final class DetailViewModel {
    enum State: Equatable {
        case loading
        case loaded(HomeViewRecipe)
        case error(String)
    }
    
    var state = State.loading
    
    var recipe: HomeViewRecipe? {
        switch state {
        case .loaded(let recipe):
            return recipe
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
    
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    @MainActor
    func loadRecipe(id: Int) async {
        self.state = .loading
        do {
            let request = Recipe.fetch(id: id)
            let recipe = try await apiService.performRequest(request)
            self.state = .loaded(HomeViewRecipe(recipe: recipe))
        } catch let error as APIServiceError {
            self.state = .error(error.errorDescription)
        } catch {
            self.state = .error(error.localizedDescription)
        }
    }
}
