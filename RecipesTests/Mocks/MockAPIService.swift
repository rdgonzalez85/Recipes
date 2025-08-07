import Foundation
@testable import Recipes

final class MockAPIService: APIServiceProtocol {
    
    var mockResults: [Any] = []

    var mockError: Error?

    var receivedRequests: [Any] = []

    init() {}

    func performRequest<Value: Decodable>(_ request: Request<Value>) async throws -> Value {
        receivedRequests.append(request)

        if let error = mockError {
            throw error
        }

        guard !mockResults.isEmpty else {
            throw MockError.noMoreMockResults(expectedType: String(describing: Value.self), path: request.path)
        }

        let mockResult = mockResults.first { $0 is Value }

        guard let result = mockResult as? Value else {
            fatalError("Mock result type mismatch for \(Value.self). Ensure mockResult provides the correct type.")
        }
        
        return result
    }

    func addMockResult<T: Decodable>(_ result: T) {
        self.mockResults.append(result)
    }

    func setMockError(_ error: Error) {
        self.mockError = error
        self.mockResults.removeAll()
    }

    func reset() {
        mockResults.removeAll()
        mockError = nil
        receivedRequests = []
    }
}

enum MockError: Error, Equatable {
    case noMoreMockResults(expectedType: String, path: String)
    case networkError
    case decodingError
}
