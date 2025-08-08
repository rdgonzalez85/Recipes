import SwiftUI

struct HomeView: View {
    private var viewModel: HomeViewModel
    @State private var coordinator = HomeViewNavigationCoordinator()
    @State private var showingFilters = false
    private let constants: HomeViewConstants
    
    init(viewModel: HomeViewModel,
         constants: HomeViewConstants = HomeViewConstants()) {
        self.viewModel = viewModel
        self.constants = constants
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VStack {
                switch viewModel.state {
                case .loading:
                    loadingView
                case .loaded:
                    listView
                case .error(_):
                    EmptyView() // handle errors later
                        
                }
            }
            .navigationTitle(constants.navigationTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(constants.filterButtonTitle) {
                        showingFilters = true
                    }
                }
            }
            .sheet(isPresented: $showingFilters) {
                FilterView(
                    viewModel: viewModel,
                    onApply: {
                        viewModel.applyFilters()
                        showingFilters = false
                    },
                    onClear: {
                        viewModel.clearFilters()
                        showingFilters = false
                    }
                )
            }
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
                Button(action: {
                    self.coordinator.navigateToRecipeDetail(recipe)
                }) {
                    RecipeRowView(recipe: recipe)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .navigationDestination(for: HomeViewRecipe.self) { recipe in
                coordinator.createDetailView(for: recipe)
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
