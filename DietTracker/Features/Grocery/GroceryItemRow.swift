import SwiftUI
import DesignKit

struct GroceryItemRow: View {
    @Bindable var item: GroceryItem
    let theme: Theme

    var body: some View {
        DKCard(theme: theme) {
            HStack(spacing: theme.spacing.m) {
                Button {
                    item.isChecked.toggle()
                } label: {
                    Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(item.isChecked ? theme.colors.success : theme.colors.textTertiary)
                        .font(.title2)
                }
                .buttonStyle(.plain)

                VStack(alignment: .leading, spacing: theme.spacing.xs) {
                    Text(item.name)
                        .font(theme.typography.headline)
                        .foregroundStyle(item.isChecked ? theme.colors.textTertiary : theme.colors.textPrimary)
                        .strikethrough(item.isChecked, color: theme.colors.textTertiary)

                    HStack(spacing: theme.spacing.s) {
                        let unitDisplay = UnitType(rawValue: item.unitType)?.displayName ?? item.unitType
                        Text("\(item.quantityNeeded.formatted()) \(unitDisplay)")
                            .font(theme.typography.caption)
                            .foregroundStyle(theme.colors.textSecondary)

                        let source = GrocerySourceType(rawValue: item.sourceType) ?? .manual
                        SourceBadge(sourceType: source, theme: theme)
                    }
                }

                Spacer()

                if let cost = item.estimatedCost {
                    Text(cost, format: .currency(code: "USD"))
                        .font(theme.typography.caption)
                        .foregroundStyle(theme.colors.textSecondary)
                }
            }
        }
    }
}
