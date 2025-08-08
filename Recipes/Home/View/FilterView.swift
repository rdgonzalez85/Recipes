import SwiftUI

struct FilterView: View {
    @Bindable var viewModel: HomeViewModel
    let onApply: () -> Void
    let onClear: () -> Void
    
    private let constants: FilterViewConstants
    
    init(
        viewModel: HomeViewModel,
        onApply: @escaping () -> Void,
        onClear: @escaping () -> Void,
        constants: FilterViewConstants = FilterViewConstants()
    ) {
        self.viewModel = viewModel
        self.onApply = onApply
        self.onClear = onClear
        self.constants = constants
    }
    
    
    var body: some View {
            NavigationView {
            VStack(spacing: self.constants.layout.vStackSpacing) {
                VStack(alignment: .leading, spacing: self.constants.layout.innerVStackSpacing) {
                    Text(self.constants.text.difficultyFilterTitle)
                        .font(self.constants.text.sectionTitleFont)
                    
                    Picker(self.constants.text.difficultyFilterTitle, selection: $viewModel.selectedDifficulty) {
                        ForEach(viewModel.allDifficulties, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                VStack(alignment: .leading, spacing: self.constants.layout.innerVStackSpacing) {
                    Text(self.constants.text.ratingFilterTitle)
                        .font(self.constants.text.sectionTitleFont)
                    
                    Picker(self.constants.text.ratingFilterTitle, selection: $viewModel.selectedRating) {
                        ForEach(viewModel.allRatings, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Spacer()
            }
            .padding(self.constants.layout.padding)
            .navigationTitle(self.constants.text.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(self.constants.text.clearButtonTitle) {
                        onClear()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(self.constants.text.applyButtonTitle) {
                        onApply()
                    }
                }
            }
        }
    }
}


struct FilterViewConstants {
    struct Layout {
        let vStackSpacing: CGFloat = 20
        let innerVStackSpacing: CGFloat = 8
        let padding: CGFloat = 16
    }

    struct Text {
        let difficultyFilterTitle: String = "Difficulty"
        let ratingFilterTitle: String = "Rating"
        let navigationTitle: String = "Filters"
        let applyButtonTitle: String = "Apply"
        let clearButtonTitle: String = "Clear"
        let sectionTitleFont: Font = .headline
    }
    
    let layout = Layout()
    let text = Text()
}
