import SwiftUI

struct HomeView: View {
    private var viewModel: HomeViewModel
    @State private var coordinator = HomeViewNavigationCoordinator()
    @State private var showingFilters = false
    private let constants: HomeViewConstants
    private let accessibility: Accessibility
    
    init(viewModel: HomeViewModel,
         constants: HomeViewConstants = HomeViewConstants(),
         accessibility: Accessibility = Accessibility()) {
        self.viewModel = viewModel
        self.constants = constants
        self.accessibility = accessibility
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
                    .accessibilityIdentifier(accessibility.filterButton)
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
            List(recipes.enumerated().map { $0 }, id: \.element) { index, recipe in
                RecipeRowView(recipe: recipe)
                    .onTapGesture {
                        self.coordinator.navigateToRecipeDetail(recipe)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityIdentifier("\(self.accessibility.element)_\(index)")
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
    struct Accessibility {
        let element: String = "recipes_list.element"
        let filterButton: String = "recipes_list.filter_button"
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
