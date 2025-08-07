import XCTest
@testable import Recipes

@MainActor
final class HomeViewNavigationCoordinatorTests: XCTestCase {
    var mockAPIService: MockAPIService!
    var coordinator: HomeViewNavigationCoordinator!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        coordinator = HomeViewNavigationCoordinator(apiService: mockAPIService)
    }
    
    override func tearDown() {
        mockAPIService = nil
        coordinator = nil
        super.tearDown()
    }
    
    func testNavigateToRecipeDetail() {
        // Given
        
        let recipe = TestDataFactory.createHomeViewRecipe()
        XCTAssertEqual(coordinator.path.count, 0)
        
        // When
        coordinator.navigateToRecipeDetail(recipe)
        
        // Then
        XCTAssertEqual(coordinator.path.count, 1)
    }
    
    func testNavigateBack() {
        // Given
        let testRecipe1 = TestDataFactory.createHomeViewRecipe(id: 1)
        let testRecipe2 = TestDataFactory.createHomeViewRecipe(id: 2)
        coordinator.navigateToRecipeDetail(testRecipe1)
        coordinator.navigateToRecipeDetail(testRecipe2)
        XCTAssertEqual(coordinator.path.count, 2)
        
        // When
        coordinator.navigateBack()
        
        // Then
        XCTAssertEqual(coordinator.path.count, 1)
    }
    
    func testPopToRoot() {
        // Given
        let testRecipe1 = TestDataFactory.createHomeViewRecipe(id: 1)
        let testRecipe2 = TestDataFactory.createHomeViewRecipe(id: 2)
        let testRecipe3 = TestDataFactory.createHomeViewRecipe(id: 3)
        coordinator.navigateToRecipeDetail(testRecipe1)
        coordinator.navigateToRecipeDetail(testRecipe2)
        coordinator.navigateToRecipeDetail(testRecipe3)
        XCTAssertEqual(coordinator.path.count, 3)
        
        // When
        coordinator.popToRoot()
        
        // Then
        XCTAssertEqual(coordinator.path.count, 0)
    }
}
