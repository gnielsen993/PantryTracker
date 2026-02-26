import SwiftUI
import DesignKit

struct PantryItemRow: View {
    let item: PantryItem
    let theme: Theme

    var body: some View {
        DKCard(theme: theme) {
            HStack {
                VStack(alignment: .leading, spacing: theme.spacing.xs) {
                    Text(item.name)
                        .font(theme.typography.headline)
                        .foregroundStyle(theme.colors.textPrimary)

                    let unitDisplay = UnitType(rawValue: item.unitType)?.displayName ?? item.unitType
                    Text("\(item.quantityOnHand.formatted()) \(unitDisplay)")
                        .font(theme.typography.body)
                        .foregroundStyle(theme.colors.textSecondary)
                }

                Spacer()

                ForecastBadge(
                    status: ForecastEngine.forecastStatus(item: item),
                    theme: theme
                )
            }
        }
    }
}
