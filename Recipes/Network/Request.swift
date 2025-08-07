import Foundation

struct Request<Value: Decodable> {
    enum Method: String {
        case get = "GET"
    }
    
    let method: Method
    let path: String
    let params: [String: String]
    
    init(
        method: Method = .get,
        path: String,
        params: [String: String] = [:]
    ) {
        self.method = method
        self.path = path
        self.params = params
    }
    
    func queryItems() -> [URLQueryItem] {
        return self.params.map(URLQueryItem.init)
    }
}

extension Recipe {
    static func fetchAll() -> Request<RecipeResponse> {
        Request<RecipeResponse>(path: "/recipes")
    }
}
