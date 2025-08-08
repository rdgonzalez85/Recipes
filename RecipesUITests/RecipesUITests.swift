import XCTest

final class RecipesUITests: XCTestCase {
    @MainActor
    func testGivenAppIsLaunched_ThenFirstRecipeIsEasyDifficulty_WhenTappingOnFiltersButtonAndSelectingMediumDifficultyAnd2PlusRatingAndTappingOnApplyButton_ThenFirstRecipeIsMediumDifficulty_WhenTappingOnTheFirstRecipe_ThenRepiceDetailsAreDisplayed() throws {
        // Given - launch App
        let app = XCUIApplication()
        app.launch()

        XCTAssert(app.buttons[Accessibility.Recipes.filterButton].waitForExistence(timeout: 2))
        
        // first element is an easy recipe
        let firstElement = app.staticTexts[Accessibility.Recipes.element]
        let easyText = "Easy"
        let easyPredicate = NSPredicate(format: "label CONTAINS[c] %@", easyText)
        let easyElementQuery = firstElement.staticTexts.containing(easyPredicate)
        XCTAssertTrue(easyElementQuery.count > 0)
        
        // tap on filter button
        let filterButton = app.buttons[Accessibility.Recipes.filterButton]
        filterButton.tap()
        
        // select medium difficulty
        let mediumDifficulty = app.buttons[Accessibility.Filter.difficultyMedium]
        mediumDifficulty.tap()
        
        // select 2+ rating
        let twoPlusRating = app.buttons[Accessibility.Filter.rating2Plus]
        twoPlusRating.tap()
        
        // tap on apply button
        let applybutton = app.buttons[Accessibility.Filter.applyButton]
        applybutton.tap()
        
        XCTAssertFalse(mediumDifficulty.exists)
        XCTAssertFalse(twoPlusRating.exists)
        
        // first element is a medium recipe now
        let mediumText = "Medium"
        let mediumPredicate = NSPredicate(format: "label CONTAINS[c] %@", mediumText)
        let mediumElementQuery = firstElement.staticTexts.containing(mediumPredicate)
        XCTAssertTrue(mediumElementQuery.count > 0)
        
        firstElement.tap()
        
        // details title is shown
        let detailTitle = app.staticTexts[Accessibility.Details.title]
        XCTAssert(detailTitle.waitForExistence(timeout: 2))
    }
}

private struct Accessibility {
    struct Recipes {
        static let element = "recipes_list.element_0"
        static let filterButton = "recipes_list.filter_button"
    }
    
    struct Filter {
        static let rating2Plus = "filter_view.rating_twoPlus"
        static let difficultyMedium = "filter_view.difficulty_medium"
        static let applyButton = "filter_view.apply_button"
    }
    
    struct Details {
        static let title = "details_view.title"
    }
}

extension XCUIApplication {
    func tapBackButton() {
        navigationBars.buttons.element(boundBy: 0).tap()
    }
}
