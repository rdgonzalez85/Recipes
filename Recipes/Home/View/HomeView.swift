import SwiftUI

struct HomeView: View {
    private var viewModel: HomeViewModel
    @State private var showingFilters = false
    private let constants: HomeViewConstants
    
    init(viewModel: HomeViewModel,
         constants: HomeViewConstants = HomeViewConstants()) {
        self.viewModel = viewModel
        self.constants = constants
    }
    
    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.state {
                case .loading:
                    loadingView
                case .loaded(_):
                    listView
                case .error(_):
                    EmptyView() // handle errors later
                        
                }
            }
            .navigationTitle(constants.navigationTitle)            
        }
        .task {
            await viewModel.loadRecipes()
        }
    }
    
    private var loadingView: some View {
        ProgressView(constants.loadingText)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private var listView: some View {
        if let recipes = viewModel.recipes,
           !recipes.isEmpty {
            List(recipes) { recipe in
                NavigationLink(
                    destination: DetailView(
                        recipe: recipe,
                        viewModel: DetailViewModel()
                    )
                ) {
                    RecipeRowView(recipe: recipe)
                }
            }
        } else {
            Text(constants.emptyStateText)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
}

struct HomeViewConstants {
    let navigationTitle = "Recipes"
    let searchPlaceholder = "Search recipes..."
    let difficultyFilterTitle = "Difficulty"
    let ratingFilterTitle = "Rating"
    let allDifficulties = "All"
    let allRatings = "All"
    let errorAlertTitle = "Error"
    let okButtonTitle = "OK"
    let loadingText = "Loading recipes..."
    let emptyStateText = "No recipes found"
    let filterButtonTitle = "Filters"
    let clearFiltersTitle = "Clear Filters"
}
