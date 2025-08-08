import Foundation

struct HomeViewRecipe: Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let ingredients: [String]
    let instructions: [String]
    let prepTimeMinutes: Int
    let cookTimeMinutes: Int
    let servings: Int
    let difficulty: Difficulty
    let cuisine: String
    let caloriesPerServing: Int
    let tags: [String]
    let userId: Int
    let image: String
    let rating: Double
    let ratingString: String
    let reviewCount: Int
    let mealType: [String]
}

extension HomeViewRecipe {
    init(
        recipe: Recipe,
        ratingFormatter: NumberFormatter = NumberFormatter()
    ) {
        self.id = recipe.id
        self.name = recipe.name
        self.ingredients = recipe.ingredients
        self.instructions = recipe.instructions
        self.prepTimeMinutes = recipe.prepTimeMinutes
        self.cookTimeMinutes = recipe.cookTimeMinutes
        self.servings = recipe.servings
        self.difficulty = Difficulty(rawValue: recipe.difficulty) ?? .all
        self.cuisine = recipe.cuisine
        self.caloriesPerServing = recipe.caloriesPerServing
        self.tags = recipe.tags
        self.userId = recipe.userId
        self.image = recipe.image
        self.rating = recipe.rating
        self.ratingString = ratingFormatter.string(from: NSNumber(value: rating)) ?? ""
        self.reviewCount = recipe.reviewCount
        self.mealType = recipe.mealType
    }
}


