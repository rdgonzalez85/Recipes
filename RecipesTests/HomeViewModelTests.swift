import XCTest
@testable import Recipes

final class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!
    var mockAPIService: MockAPIService!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = HomeViewModel(apiService: mockAPIService)
    }
    
    override func tearDown() {
        mockAPIService = nil
        viewModel = nil
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
        let expectedRecipes = [recipe1, recipe2].map( HomeViewRecipe.init)

        mockAPIService.addMockResult(result)
        
        // When
        await viewModel.loadRecipes()
        
        // Then
        XCTAssertEqual(viewModel.state, .loaded(expectedRecipes))
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
}
