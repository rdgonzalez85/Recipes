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
                    errorView
                }
            }
            .navigationTitle(constants.navigation.navigationTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(constants.navigation.filterButtonTitle) {
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
        ProgressView(constants.statusView.loadingText)
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
            Text(constants.statusView.emptyStateText)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    var errorView: some View {
        VStack {
            if let error = viewModel.errorMessage {
                Text(error)
            } else {
                Text(self.constants.errorView.unknownError)
            }
            
            Button(constants.errorView.retryButtonTitle) {
                Task { [viewModel] in
                    await viewModel.loadRecipes()
                }
            }
            .buttonStyle(self.constants.errorView.buttonStyle)
        }
    }
}

struct HomeViewConstants {
    struct StatusView {
        let loadingText: String = "Loading recipes..."
        let emptyStateText: String = "No recipes found"
    }

    struct ErrorView {
        let unknownError: String = "Unknown error"
        let retryButtonTitle: String = "Try Again"
        let buttonStyle: BorderedProminentButtonStyle = .borderedProminent
    }

    struct Navigation {
        let navigationTitle: String = "Recipes"
        let filterButtonTitle: String = "Filters"
    }

    let statusView = StatusView()
    let errorView = ErrorView()
    let navigation = Navigation()
}
