import SwiftUI

struct DetailView: View {
    private let recipe: HomeViewRecipe
    private let constants: DetailViewConstants
    
    init(recipe: HomeViewRecipe,
         constants: DetailViewConstants = DetailViewConstants()) {
        self.recipe = recipe
        self.constants = constants
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: self.constants.layout.vStackSpacing) {
                recipeImage
                VStack(alignment: .leading, spacing: self.constants.layout.innerVStackSpacing) {
                    titleRatingView
                    quickInfoView
                    Divider()
                    ingredientsView
                    Divider()
                    instructionsView
                    Divider()
                    additionalInfoView
                }
                .padding(self.constants.layout.defaultPadding)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var recipeImage: some View {
        AsyncImage(url: URL(string: recipe.image)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: self.constants.image.aspectRatio)
        } placeholder: {
            Rectangle()
                .foregroundColor(self.constants.image.placeholderColor)
        }
        .frame(height: self.constants.image.height)
        .clipShape(RoundedRectangle(cornerRadius: self.constants.image.cornerRadius))
    }
    
    private var titleRatingView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(self.constants.text.titleFont)
                    .bold()
                
                HStack {
                    Image(systemName: self.constants.icons.starFill)
                        .foregroundColor(self.constants.colors.starIcon)
                    Text(recipe.ratingString)
                    Text("(\(recipe.reviewCount) \(self.constants.text.reviews)")
                        .foregroundColor(self.constants.colors.secondaryText)
                }
                .font(self.constants.text.ratingFont)
            }
            
            Spacer()
            
            let difficultyColor = recipe.difficulty.color(colors: self.constants.colors)
            Text(recipe.difficulty.rawValue)
                .font(self.constants.text.tagsFont)
                .padding(.horizontal, self.constants.layout.difficultyHorizontalPadding)
                .padding(.vertical, self.constants.layout.difficultyVerticalPadding)
                .background(difficultyColor.opacity(self.constants.layout.difficultyOpacity))
                .foregroundColor(difficultyColor)
                .clipShape(Capsule())
        }
    }
    
    private var quickInfoView: some View {
        HStack(spacing: self.constants.layout.hStackSpacing) {
            InfoItem(title: self.constants.text.prepTimeTitle, value: "\(recipe.prepTimeMinutes) \(self.constants.text.minutesUnit)")
            InfoItem(title: self.constants.text.cookTimeTitle, value: "\(recipe.cookTimeMinutes) \(self.constants.text.minutesUnit)")
            InfoItem(title: self.constants.text.caloriesTitle, value: "\(recipe.caloriesPerServing) \(self.constants.text.caloriesUnit)")
            InfoItem(title: self.constants.text.servingsTitle, value: "\(recipe.servings)")
        }
    }

    private var ingredientsView: some View {
        VStack(alignment: .leading, spacing: self.constants.layout.instructionsVStackPadding) {
            Text(self.constants.text.ingredientsTitle)
                .font(self.constants.text.sectionTitleFont)
            
            ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { index, ingredient in
                HStack(alignment: .top) {
                    Text("\(index + 1).")
                        .foregroundColor(self.constants.colors.secondaryText)
                    Text(ingredient)
                    Spacer()
                }
            }
        }
    }
    
    private var instructionsView: some View {
        VStack(alignment: .leading, spacing: self.constants.layout.instructionsVStackPadding) {
            Text(self.constants.text.instructionsTitle)
                .font(self.constants.text.sectionTitleFont)
            
            ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { index, instruction in
                HStack(alignment: .top, spacing: self.constants.layout.instructionsHStackSpacing) {
                    Text("\(index + 1)")
                        .frame(width: self.constants.layout.instructionCircleSize, height: self.constants.layout.instructionCircleSize)
                        .background(self.constants.colors.instructionCircle.opacity(self.constants.layout.instructionCircleOpacity)) 
                        .foregroundColor(self.constants.colors.instructionCircle) 
                        .clipShape(Circle())
                        .font(self.constants.text.instructionsFont)
                        .bold()
                    
                    Text(instruction)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                }
                .padding(.vertical, self.constants.layout.instructionVerticalPadding)
            }
        }
    }
    
    private var additionalInfoView: some View {
        VStack(alignment: .leading, spacing: self.constants.layout.instructionsVStackPadding) {
            HStack {
                Text(self.constants.text.cuisineTitle)
                    .font(self.constants.text.additionalInfoFont)
                    .bold()
                Spacer()
                Text(recipe.cuisine)
                    .font(self.constants.text.additionalInfoFont)
                    .foregroundColor(self.constants.colors.secondaryText)
            }
            
            if !recipe.tags.isEmpty {
                VStack(alignment: .leading, spacing: self.constants.layout.instructionsVStackPadding) {
                    Text(self.constants.text.tagsTitle)
                        .font(self.constants.text.additionalInfoFont)
                        .bold()
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(recipe.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(self.constants.text.tagsFont)
                                    .padding(.horizontal, self.constants.layout.tagHorizontalPadding)
                                    .padding(.vertical, self.constants.layout.tagVerticalPadding)
                                    .background(self.constants.colors.tagBackground)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
        }
    }
}

struct DetailViewConstants {
    struct Image {
        let height: CGFloat = 250
        let aspectRatio: ContentMode = .fill
        let cornerRadius: CGFloat = 12
        let placeholderColor: Color = .gray.opacity(0.3)
    }

    struct Icons {
        let starFill: String = "star.fill"
    }

    struct Layout {
        let vStackSpacing: CGFloat = 16
        let innerVStackSpacing: CGFloat = 12
        let hStackSpacing: CGFloat = 20
        let instructionsHStackSpacing: CGFloat = 12
        let defaultPadding: CGFloat = 16
        let instructionsVStackPadding: CGFloat = 8
        let instructionCircleSize: CGFloat = 24
        let instructionCircleOpacity: Double = 0.1
        let instructionVerticalPadding: CGFloat = 2
        let difficultyHorizontalPadding: CGFloat = 12
        let difficultyVerticalPadding: CGFloat = 6
        let difficultyOpacity: Double = 0.2
        let tagHorizontalPadding: CGFloat = 8
        let tagVerticalPadding: CGFloat = 4
        let tagBackgroundOpacity: Double = 0.2
    }

    struct Text {
        let ingredientsTitle: String = "Ingredients"
        let instructionsTitle: String = "Instructions"
        let prepTimeTitle: String = "Prep Time"
        let cookTimeTitle: String = "Cook Time"
        let caloriesTitle: String = "Calories"
        let servingsTitle: String = "Servings"
        let cuisineTitle: String = "Cuisine"
        let tagsTitle: String = "Tags"
        let minutesUnit: String = "min"
        let caloriesUnit: String = "cal"
        let servingsUnit: String = "servings"
        let backButtonTitle: String = "Back"
        let shareButtonTitle: String = "Share"
        let reviews: String = "reviews"
        let titleFont: Font = .title
        let titleFontWeight: Font.Weight = .bold
        let ratingFont: Font = .subheadline
        let sectionTitleFont: Font = .headline
        let additionalInfoFont: Font = .subheadline
        let additionalInfoFontWeight: Font.Weight = .bold
        let tagsFont: Font = .caption
        let instructionsFont: Font = .caption
        let infoItemTitleFont: Font = .caption
    }
    
    struct Colors {
        let starIcon: Color = .yellow
        let difficultyEasy: Color = .green
        let difficultyMedium: Color = .orange
        let difficultyHard: Color = .red
        let difficultyDefault: Color = .gray
        let instructionCircle: Color = .blue
        let secondaryText: Color = .secondary
        let tagBackground: Color = .gray.opacity(0.2)
    }

    let image = Image()
    let icons = Icons()
    let layout = Layout()
    let text = Text()
    let colors = Colors()
}

extension DetailViewConstants.Colors: DifficultyColors { }
protocol DifficultyColors {
    var difficultyEasy: Color { get }
    var difficultyMedium: Color { get }
    var difficultyHard: Color { get }
    var difficultyDefault: Color { get }
}
extension Difficulty {
    func color(colors: DifficultyColors) -> Color {
        switch self {
            case .easy:
                return colors.difficultyEasy
            case .medium:
                return colors.difficultyMedium
            case .hard:
                return colors.difficultyHard
            default:
                return colors.difficultyDefault
        }
    }
}
