import SwiftUI

struct RecipeRowView: View {
    private let recipe: HomeViewRecipe
    private let constants: RecipeRowConstants
    
    init(recipe: HomeViewRecipe,
         constants: RecipeRowConstants = RecipeRowConstants()) {
        self.recipe = recipe
        self.constants = constants
    }
    
    var body: some View {
        HStack {
            // it may be worth using a 3rd party library instead of asyncImage, such as https://github.com/kean/Nuke
            AsyncImage(url: URL(string: recipe.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: self.constants.image.aspectRatio)
            } placeholder: {
                Rectangle()
                    .foregroundColor(self.constants.image.placeholderColor)
            }
            .frame(width: self.constants.image.size, height: self.constants.image.size)
            .clipShape(RoundedRectangle(cornerRadius: self.constants.image.cornerRadius))
            
            VStack(alignment: .leading, spacing: self.constants.layout.spacing) {
                Text(recipe.name)
                    .font(self.constants.text.nameFont)
                    .lineLimit(self.constants.text.recipeLineLimit)
                
                HStack {
                    Image(systemName: self.constants.icon.starFill)
                        .foregroundColor(self.constants.icon.foregroundColor)
                        .font(self.constants.text.starRatingFont)
                    
                    Text(recipe.rating)
                        .font(self.constants.text.starRatingFont)
                        .foregroundColor(self.constants.rating.foregroundColor)
                    
                    Spacer()
                    
                    Text(recipe.difficulty)
                        .font(self.constants.text.difficultyFont)
                        .padding(.horizontal, self.constants.layout.horizontalPadding)
                        .padding(.vertical, self.constants.layout.verticalDifficultyPadding)
                        .background(difficultyColor.opacity(self.constants.layout.difficultyOpacity))
                        .foregroundColor(difficultyColor)
                        .clipShape(Capsule())
                }
            }
            
            Spacer()
        }
        .padding(.vertical, self.constants.layout.verticalPadding)
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

struct RecipeRowConstants {
    
    struct Image {
        let size: CGFloat = 80
        let cornerRadius: CGFloat = 8
        let aspectRatio: ContentMode = .fill
        let placeholderColor: Color = .gray.opacity(0.3)
    }
    
    struct Icon {
        let starFill: String = "star.fill"
        let foregroundColor: Color = .yellow
    }
    
    struct Rating {
        let foregroundColor: Color = .secondary
    }
    
    struct Layout {
        let spacing: CGFloat = 4
        let verticalPadding: CGFloat = 4
        let horizontalPadding: CGFloat = 8
        let verticalDifficultyPadding: CGFloat = 2
        let difficultyOpacity: Double = 0.2
    }
    
    struct Text {
        let recipeLineLimit: Int = 2
        let starRatingFont: Font = .caption
        let difficultyFont: Font = .caption
        let nameFont: Font = .headline
    }
    
    let image = Image()
    let icon = Icon()
    let layout = Layout()
    let text = Text()
    let rating = Rating()
}
