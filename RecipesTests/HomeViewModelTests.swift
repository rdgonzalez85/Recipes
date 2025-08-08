import XCTest
@testable import Recipes

final class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!
    var mockAPIService: MockAPIService!
    var ratingFormatter: NumberFormatter!
    
    override func setUp() {
        super.setUp()
        ratingFormatter = NumberFormatter()
        mockAPIService = MockAPIService()
        viewModel = HomeViewModel(apiService: mockAPIService, ratingFormatter: ratingFormatter)
    }
    
    override func tearDown() {
        mockAPIService = nil
        viewModel = nil
        ratingFormatter = nil
        super.tearDown()
    }

    func testInitialState() {
        // Given
        
        // When
        
        // Then
        XCTAssertNil(viewModel.recipes)
        XCTAssertEqual(viewModel.state, .loading)
    }
    
    func testWhenLoadRecipes_ThenShouldCallAPIServiceOnce() async {
        // Given
        
        // When
        await viewModel.loadRecipes()
        
        // Then
        XCTAssertEqual(mockAPIService.receivedRequests.count, 1)
    }
    
    func testGivenRecipes_WhenLoadRecipes_ThenCorrectStateAndRecipesAreCreated() async {
        // Given
        let recipe1 = TestDataFactory.createRecipe(id: 1)
        let recipe2 = TestDataFactory.createRecipe(id: 2)
        let result = TestDataFactory.createRecipeResponse(recipes: [recipe1, recipe2])
        let expectedRecipes = [recipe1, recipe2].map {
            HomeViewRecipe(recipe: $0, ratingFormatter: ratingFormatter)
        }

        mockAPIService.addMockResult(result)
        
        // When
        await viewModel.loadRecipes()
        
        // Then
        XCTAssertEqual(viewModel.state, .loaded)
        XCTAssertEqual(viewModel.recipes, expectedRecipes)
    }
    
    func testGivenError_WhenLoadRecipes_ThenErrorStateAndMessageAreCreated() async {
        // Given
        let expectedError = APIServiceError.invalidURL
        mockAPIService.setMockError(expectedError)
        let expectedErrorMessage = expectedError.errorDescription
        
        // When
        await viewModel.loadRecipes()
        
        // Then
        XCTAssertEqual(viewModel.state, .error(expectedErrorMessage))
        XCTAssertEqual(viewModel.error, expectedErrorMessage)
    }
    
    func testGivenRecipesLoaded_WhenViewModelSelectedDifficultyIsHardAndViewModelAppliesFilter_ThenViewModelRecipesAreFiltered() async {
        // Given
        let recipe1 = TestDataFactory.createRecipe(id: 1, difficulty: "Easy")
        let recipe2 = TestDataFactory.createRecipe(id: 2, difficulty: "Hard")
        let result = TestDataFactory.createRecipeResponse(recipes: [recipe1, recipe2])

        mockAPIService.addMockResult(result)

        let expectedRecipes = [recipe2].map {
            HomeViewRecipe(recipe: $0, ratingFormatter: ratingFormatter)
        }
        
        await viewModel.loadRecipes()
        
        // When
        viewModel.selectedDifficulty = .hard
        viewModel.applyFilters()
        
        // Then
        XCTAssertEqual(viewModel.recipes, expectedRecipes)
    }
    
    func testGivenRecipesLoaded_WhenViewModelSelectedRatingIsHardAndViewModelAppliesFilter_ThenViewModelRecipesAreFiltered() async {
        // Given
        let recipe1 = TestDataFactory.createRecipe(id: 1, rating: 2.1)
        let recipe2 = TestDataFactory.createRecipe(id: 2, rating: 4.7)
        let recipe3 = TestDataFactory.createRecipe(id: 2, rating: 3.6)
        let result = TestDataFactory.createRecipeResponse(recipes: [recipe1, recipe2, recipe3])

        mockAPIService.addMockResult(result)

        let expectedRecipes = [recipe2, recipe3].map {
            HomeViewRecipe(recipe: $0, ratingFormatter: ratingFormatter)
        }
        
        await viewModel.loadRecipes()
        
        // When
        viewModel.selectedRating = .threePlus
        viewModel.applyFilters()
        
        // Then
        XCTAssertEqual(viewModel.recipes, expectedRecipes)
    }
}
