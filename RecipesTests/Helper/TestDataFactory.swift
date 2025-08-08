import Foundation
@testable import Recipes

struct TestDataFactory {
    static func createHTTPResponse(statusCode: Int = 200) -> HTTPURLResponse {
        return HTTPURLResponse(
            url: URL(string: "https://dummyjson.com")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }
    
    static func createRecipeResponse(
        recipes: [Recipe],
        total: Int = 10,
        skip: Int = 1,
        limit: Int = 10
    ) -> RecipeResponse {
        RecipeResponse(
            recipes: recipes,
            total: total,
            skip: skip,
            limit: limit
        )
    }
    
    static func createRecipe(
        id: Int = 1,
        name: String = "name",
        ingredients: [String] = ["ingredient1", "ingredient2"],
        instructions: [String] = ["instructions1", "instructions2"],
        prepTimeMinutes: Int = 10,
        cookTimeMinutes: Int = 20,
        servings: Int = 2,
        difficulty: String = "Easy",
        cuisine: String = "Italian",
        caloriesPerServing: Int = 300,
        tags: [String] = ["Pizza"],
        userId: Int = 1,
        image: String = "image",
        rating: Double = 7.8,
        reviewCount: Int = 13,
        mealType: [String] = ["Dinner"]
    ) -> Recipe {
        Recipe(
            id: id,
            name: name,
            ingredients: ingredients,
            instructions: instructions,
            prepTimeMinutes: prepTimeMinutes,
            cookTimeMinutes: cookTimeMinutes,
            servings: servings,
            difficulty: difficulty,
            cuisine: cuisine,
            caloriesPerServing: caloriesPerServing,
            tags: tags,
            userId: userId,
            image: image,
            rating: rating,
            reviewCount: reviewCount,
            mealType: mealType
        )
    }
    
    static func createHomeViewRecipe(
        id: Int = 1,
        name: String = "name",
        ingredients: [String] = ["ingredient1", "ingredient2"],
        instructions: [String] = ["instructions1", "instructions2"],
        prepTimeMinutes: Int = 10,
        cookTimeMinutes: Int = 20,
        servings: Int = 2,
        difficulty: Difficulty = .easy,
        cuisine: String = "Italian",
        caloriesPerServing: Int = 300,
        tags: [String] = ["Pizza"],
        userId: Int = 1,
        image: String = "image",
        rating: Double = 7.8,
        ratingString: String = "7.8",
        reviewCount: Int = 13,
        mealType: [String] = ["Dinner"]
    ) -> HomeViewRecipe {
        HomeViewRecipe(
            id: id,
            name: name,
            ingredients: ingredients,
            instructions: instructions,
            prepTimeMinutes: prepTimeMinutes,
            cookTimeMinutes: cookTimeMinutes,
            servings: servings,
            difficulty: difficulty,
            cuisine: cuisine,
            caloriesPerServing: caloriesPerServing,
            tags: tags,
            userId: userId,
            image: image,
            rating: rating,
            ratingString: ratingString,
            reviewCount: reviewCount,
            mealType: mealType
        )
    }

}
