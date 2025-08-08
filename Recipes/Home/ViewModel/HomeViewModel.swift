import Foundation
import Observation

@Observable
final class HomeViewModel {
    enum State: Equatable {
        case loading
        case loaded
        case error(String)
    }
    
    var recipes: [HomeViewRecipe]?
    
    var errorMessage: String? {
        switch state {
        case .error(let error):
            return error
        default:
            return nil
        }
    }
    
    private var allRecipes: [HomeViewRecipe] = [] {
        didSet {
            self.applyFilters()
        }
    }

    var state = State.loading
    var selectedDifficulty: Difficulty = .all
    var selectedRating: Rating = .all
    
    private let apiService: APIServiceProtocol
    private let ratingFormatter: NumberFormatter
    
    init(apiService: APIServiceProtocol = APIService(),
         ratingFormatter: NumberFormatter = .ratingFormatter) {
        self.apiService = apiService
        self.ratingFormatter = ratingFormatter
    }
    
    @MainActor
    func loadRecipes() async {
        self.state = .loading
        do {
            let response = try await apiService.performRequest(Recipe.fetchAll())
            let homeViewRecipes = response.recipes.map {
                HomeViewRecipe(
                    recipe: $0,
                    ratingFormatter: self.ratingFormatter
                )
            }
            self.allRecipes = homeViewRecipes
            self.state = .loaded
        } catch let error as APIServiceError {
            self.state = .error(error.errorDescription)
        } catch {
            self.state = .error(error.localizedDescription)
        }
    }
    
    func applyFilters() {
        guard !allRecipes.isEmpty else { return }
            
        var filtered = allRecipes
        
        if selectedDifficulty != .all {
            filtered = filtered.filter { $0.difficulty == selectedDifficulty }
        }
        
        if selectedRating != .all {
            let minRating = self.minRating(for: selectedRating)
            filtered = filtered.filter { $0.rating >= minRating }
        }
                
        recipes = filtered
    }
    
    func clearFilters() {
        selectedDifficulty = .all
        selectedRating = .all
        recipes = allRecipes
    }
    
    private func minRating(for rating: Rating) -> Double {
        switch rating {
            case .fourPlus:
                return 4.0
            case .threePlus:
                return 3.0
            case .twoPlus:
                return 2.0
            case .onePlus:
                return 1.0
            default:
                return 0.0
        }
    }
}

extension HomeViewModel {
    var allDifficulties: [Difficulty] {
        return Difficulty.allCases
    }
    var allRatings: [Rating] {
        return Rating.allCases
    }
}

enum Difficulty: String, CaseIterable {
    case all = "All"
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}

enum Rating: String, CaseIterable {
    case all = "All"
    case onePlus = "1+"
    case twoPlus = "2+"
    case threePlus = "3+"
    case fourPlus = "4+"
}

extension NumberFormatter {
    static let ratingFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }()
}
