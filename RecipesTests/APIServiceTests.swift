import XCTest
@testable import Recipes

final class APIServiceTests: XCTestCase {

    var apiService: APIService!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        apiService = APIService(urlSession: mockURLSession)
    }
    
    override func tearDown() {
        apiService = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    func testFetchRecipes() async throws {
        let recipe1 = TestDataFactory.createRecipe(id: 1)
        let recipe2 = TestDataFactory.createRecipe(id: 2)

        let recipeResponse = TestDataFactory.createRecipeResponse(recipes: [recipe1, recipe2])
        let jsonData = try JSONEncoder().encode(recipeResponse)
        
        mockURLSession.mockData = jsonData
        mockURLSession.mockResponse = TestDataFactory.createHTTPResponse()
        let request = Recipe.fetchAll()
        
        let recipes = try await self.apiService.performRequest(request).recipes

        // Then
        XCTAssertEqual(recipes.count, 2)
        XCTAssertEqual(recipes[0], recipe1)
        XCTAssertEqual(recipes[1], recipe2)
        
        // Verify request
        XCTAssertNotNil(mockURLSession.lastRequest)
        XCTAssertEqual(mockURLSession.lastRequest?.httpMethod, "GET")
        
        let url = try XCTUnwrap(mockURLSession.lastRequest?.url)
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        XCTAssertEqual(components?.url?.lastPathComponent, "recipes")
    }
}
