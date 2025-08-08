import SwiftUI

struct InfoItem: View {
    let title: String
    let value: String
    private let constants: InfoItemConstants
    
    init(
        title: String,
        value: String,
        constants: InfoItemConstants = InfoItemConstants()
    ) {
        self.title = title
        self.value = value
        self.constants = constants
    }
    
    var body: some View {
        VStack(spacing: self.constants.layout.infoItemVStackSpace) {
            Text(value)
                .font(self.constants.text.valueFont)
                .bold()
            Text(title)
                .font(self.constants.text.titleFont)
                .foregroundColor(self.constants.colors.title)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title) - \(value)")
    }
}

struct InfoItemConstants {
    struct Text {
        let valueFont: Font = .subheadline
        let titleFont: Font = .caption
    }
    
    struct Layout {
        let infoItemVStackSpace: CGFloat = 2
    }
    
    struct Colors {
        let title: Color = .secondary
    }

    let layout = Layout()
    let text = Text()
    let colors = Colors()
}
