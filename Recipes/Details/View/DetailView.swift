import SwiftUI

struct DetailView: View {
    private var viewModel: DetailViewModel
    private let recipe: HomeViewRecipe
    private let constants = DetailViewConstants()
    
    init(recipe: HomeViewRecipe,
         viewModel: DetailViewModel) {
        self.recipe = recipe
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                recipeImage
                VStack(alignment: .leading, spacing: 12) {
                    titleRatingView
                    quickInfoView
                    Divider()
                    ingredientsView
                    Divider()
                    instructionsView
                    Divider()
                    additionalInfoView
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var recipeImage: some View {
        AsyncImage(url: URL(string: recipe.image)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Rectangle()
                .foregroundColor(.gray.opacity(0.3))
        }
        .frame(height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var titleRatingView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.title)
                    .bold()
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(recipe.rating)
                    Text("(\(recipe.reviewCount) reviews)")
                        .foregroundColor(.secondary)
                }
                .font(.subheadline)
            }
            
            Spacer()
            
            Text(recipe.difficulty)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(difficultyColor.opacity(0.2))
                .foregroundColor(difficultyColor)
                .clipShape(Capsule())
        }
    }
    
    private var quickInfoView: some View {
        HStack(spacing: 20) {
            InfoItem(title: constants.prepTimeTitle, value: "\(recipe.prepTimeMinutes) \(constants.minutesUnit)")
            InfoItem(title: constants.cookTimeTitle, value: "\(recipe.cookTimeMinutes) \(constants.minutesUnit)")
            InfoItem(title: constants.caloriesTitle, value: "\(recipe.caloriesPerServing) \(constants.caloriesUnit)")
            InfoItem(title: constants.servingsTitle, value: "\(recipe.servings)")
        }
    }

    private var ingredientsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(constants.ingredientsTitle)
                .font(.headline)
            
            ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { index, ingredient in
                HStack(alignment: .top) {
                    Text("\(index + 1).")
                        .foregroundColor(.secondary)
                    Text(ingredient)
                    Spacer()
                }
            }
        }
    }
    
    private var instructionsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(constants.instructionsTitle)
                .font(.headline)
            
            ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { index, instruction in
                HStack(alignment: .top, spacing: 12) {
                    Text("\(index + 1)")
                        .frame(width: 24, height: 24)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .clipShape(Circle())
                        .font(.caption)
                        .bold()
                    
                    Text(instruction)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                }
                .padding(.vertical, 2)
            }
        }
    }
    
    private var additionalInfoView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(constants.cuisineTitle)
                    .font(.subheadline)
                    .bold()
                Spacer()
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if !recipe.tags.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text(constants.tagsTitle)
                        .font(.subheadline)
                        .bold()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(recipe.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var difficultyColor: Color {
        switch recipe.difficulty.lowercased() {
        case "easy": return .green
        case "medium": return .orange
        case "hard": return .red
        default: return .gray
        }
    }
}


struct DetailViewConstants {
    let ingredientsTitle = "Ingredients"
    let instructionsTitle = "Instructions"
    let prepTimeTitle = "Prep Time"
    let cookTimeTitle = "Cook Time"
    let caloriesTitle = "Calories"
    let servingsTitle = "Servings"
    let cuisineTitle = "Cuisine"
    let tagsTitle = "Tags"
    let minutesUnit = "min"
    let caloriesUnit = "cal"
    let servingsUnit = "servings"
    let backButtonTitle = "Back"
    let shareButtonTitle = "Share"
}
