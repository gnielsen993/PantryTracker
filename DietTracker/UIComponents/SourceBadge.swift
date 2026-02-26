import SwiftUI
import DesignKit

struct SourceBadge: View {
    let sourceType: GrocerySourceType
    let theme: Theme

    var body: some View {
        switch sourceType {
        case .manual:
            EmptyView()
        case .pantryLow:
            DKBadge("Pantry", theme: theme)
        case .mealGenerated:
            DKBadge("Meal Plan", theme: theme)
        }
    }
}
