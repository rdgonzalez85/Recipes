import XCTest
@testable import Recipes

@MainActor
final class DetailViewModelTests: XCTestCase {
    var mockAPIService: MockAPIService!
    var viewModel: DetailViewModel!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = DetailViewModel(apiService: mockAPIService)
    }
    
    override func tearDown() {
        mockAPIService = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testLoadRecipe_Success() async {
        // Given
        let recipe = TestDataFactory.createRecipe(id: 1)
        mockAPIService.addMockResult(recipe)
        
        // When
        await viewModel.loadRecipe(id: 1)
        
        // Then
        let homeViewRecipe = HomeViewRecipe(recipe: recipe)
        XCTAssertNotNil(viewModel.recipe)
        XCTAssertEqual(viewModel.state, .loaded(homeViewRecipe))
        XCTAssertEqual(viewModel.recipe, homeViewRecipe)
    }
    
    func testLoadRecipe_Error() async {
        // Given
        let expectedError = APIServiceError.invalidURL
        mockAPIService.setMockError(expectedError)
        let expectedErrorMessage = expectedError.errorDescription
        
        // When
        await viewModel.loadRecipe(id: 1)
        
        // Then
        XCTAssertEqual(viewModel.state, .error(expectedErrorMessage))
        XCTAssertNil(viewModel.recipe)
        XCTAssertEqual(viewModel.error, expectedErrorMessage)
    }
}
