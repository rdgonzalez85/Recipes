# Recipes App
A SwiftUI-based recipe discovery app that allows users to browse, filter, and view detailed recipe information. The app fetches recipe data from the DummyJSON API and provides an intuitive interface for exploring culinary content.

## Features
- **Recipe Browsing**: View a list of recipes with images, ratings, and difficulty levels
- **Smart Filtering**: Filter recipes by difficulty (Easy, Medium, Hard) and rating (1+, 2+, 3+, 4+)
- **Detailed View**: Access comprehensive recipe information including ingredients, instructions, and nutritional data
- **Rating System**: Visual star ratings with review counts
- **Modern UI**: Clean, responsive SwiftUI interface with proper accessibility support
- **MVVM Architecture**: Well-structured codebase following MVVM design pattern

## Screenshots
The app features a clean, modern interface with:
- Recipe list with thumbnails and quick info
- Filter interface with segmented controls
- Detailed recipe view with step-by-step instructions
- Responsive design supporting both iOS and macOS


<table>
  <tr>
    <th> Home </th>
    <th> Details </th>
    <th> Filters </th>
  </tr>
  <tr>
    <td> <img src="https://github.com/rdgonzalez85/Recipes/blob/main/Home.png" width = 393px height = 852px>  </td>
    <td> <img src="https://github.com/rdgonzalez85/Recipes/blob/main/Details.png" width = 393px height = 852px> </td>
    <td> <img src="https://github.com/rdgonzalez85/Recipes/blob/main/Filters.png" width = 393px height = 852px> </td>
  </tr>
</table>



## Architecture
The app follows the MVVM (Model-View-ViewModel) architecture pattern:
### Core Components
- **Views**: SwiftUI views handling the user interface
  - `HomeView`: Main recipe list screen
  - `DetailView`: Recipe detail screen
  - `FilterView`: Filter selection interface
  - `RecipeRowView`: Individual recipe list item
  - `InfoItem`: Reusable info display component
- **ViewModels**: Business logic and state management
  - `HomeViewModel`: Manages recipe data, filtering, and API communication
  - `HomeViewRecipe`: View-specific recipe model
- **Models**: Data structures
  - `Recipe`: Core recipe data model
  - `RecipeResponse`: API response wrapper
- Network Layer: API communication
  - `APIService`: HTTP client with protocol-based design
  - `Request`: Generic request builder
- **Navigation**: Coordinator pattern
  - `HomeViewNavigationCoordinator`: Handles navigation flow

## Requirements
- iOS: 17.0+
- macOS: 14.0+
- Xcode: 15.0+
- Swift: 5.9+

### Installation

1. Clone the repository:

``` bash
git clone https://github.com/rdgonzalez85/Recipes.git
cd Recipes
```
2. Open `Recipes.xcodeproj` in Xcode
3. Build and run the project (⌘+R)
No additional dependencies or package manager setup required - the app uses only native iOS frameworks.

## API Integration
The app integrates with the [DummyJSON Recipes API](https://dummyjson.com/recipes) to fetch recipe data. The API provides:

- Recipe metadata (name, cuisine, difficulty)
- Ingredients and instructions
- Nutritional information
- User ratings and reviews
- Recipe images

### API Service Features
- Protocol-based design for easy testing and mocking
- Generic request handling with type safety
- Comprehensive error handling with user-friendly messages
- Async/await support for modern Swift concurrency

## Testing
The project includes comprehensive test coverage:

### Unit Tests (`RecipesTests`)
- **APIServiceTests**: Network layer testing with mocks
- **HomeViewModelTests**: Business logic and state management
- **HomeViewNavigationCoordinatorTests**: Navigation flow testing
- **Mock implementations** for reliable, fast testing

### UI Tests (`RecipesUITests`)
- **End-to-end testing** of critical user journeys
- **Filter functionality** testing
- **Navigation flow** verification

```bash
# Unit tests
⌘+U in Xcode
# Or via command line:
xcodebuild test -project Recipes.xcodeproj -scheme Recipes -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Key Features Implementation
### Filtering System
- **Real-time filtering** by difficulty and rating
- **Persistent filter state** during app session
- **Clear filters** functionality
- **Automatic filter application** when data loads

### Accessibility
- **VoiceOver support** with proper labels
- **Accessibility identifiers** for UI testing
- **Semantic grouping** of related elements
- **Screen reader friendly** content structure

### Configuration
#### Constants Pattern
The app uses a constants-based approach for:
- **Layout values** (spacing, padding, sizes)
- **Text content** (labels, titles, units)
- **Colors** (themes, semantic colors)
- **Typography** (fonts, weights)

This makes the app:
- Easy to maintain and update
- Consistent in design
- Localizable (ready for internationalization)

#### Dependency Injection
- **Protocol-based services** for testability
- **Constructor injection** pattern
- **Default parameter values** for convenience
- **Mock implementations** for testing

## Code Quality
### Architecture Patterns
- **MVVM** with ObservableObject
- **Coordinator Pattern** for navigation
- **Protocol-Oriented Programming**
- **Dependency Injection**
- **Repository Pattern** (API Service)

### Best Practices
- **Swift Concurrency** (async/await)
- **Error Handling** with custom error types
- **Type Safety** with generics
- **Code Reusability** with components
- **Testability** with mocks and protocols

## Roadmap
Potential future enhancements:
- **Search functionality** with text-based filtering
- **Favorites system** with local persistence
- **Shopping list** generation from recipes
- **iPad optimization** with multi-column layout
- **Offline support** with Core Data
- **Theming support** (Dark/Light mode customization)
- **Recipe sharing** via system share sheet
- **Cooking timer** integration
- **Replace AsyncImage** with a library for loading images (e.g. [Nuke](https://github.com/kean/Nuke)) and implement caching
