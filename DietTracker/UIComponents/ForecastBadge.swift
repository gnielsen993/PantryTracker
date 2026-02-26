import SwiftUI
import DesignKit

struct ForecastBadge: View {
    let status: ForecastStatus
    let theme: Theme

    var body: some View {
        switch status {
        case .ok:
            EmptyView()
        case .low:
            badgeView(text: "Low", color: theme.colors.warning)
        case .runningLow(let days):
            badgeView(text: "\(days)d left", color: theme.colors.warning)
        case .outSoon:
            badgeView(text: "Out Soon", color: theme.colors.danger)
        case .expired:
            badgeView(text: "Expired", color: theme.colors.danger)
        case .expiringSoon:
            badgeView(text: "Exp. Soon", color: theme.colors.warning)
        }
    }

    private func badgeView(text: String, color: Color) -> some View {
        Text(text)
            .font(theme.typography.caption.weight(.semibold))
            .foregroundStyle(color)
            .padding(.horizontal, theme.spacing.s)
            .padding(.vertical, theme.spacing.xs)
            .background(color.opacity(0.12))
            .clipShape(Capsule())
    }
}
