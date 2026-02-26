import SwiftUI
import SwiftData
import DesignKit

struct ShoppingModeView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss

    @Query(sort: \GroceryItem.category) private var items: [GroceryItem]

    @State private var collapsedCategories: Set<String> = []

    private var theme: Theme {
        themeManager.theme(for: colorScheme)
    }

    private var groupedItems: [(String, [GroceryItem])] {
        let grouped = Dictionary(grouping: items) { $0.category }
        return grouped
            .sorted { $0.key < $1.key }
            .map { (key, items) in (key, items.sorted { $0.name < $1.name }) }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(alignment: .leading, spacing: theme.spacing.m) {
                        ForEach(groupedItems, id: \.0) { category, categoryItems in
                            let displayName = PantryCategory(rawValue: category)?.displayName ?? category
                            let isCollapsed = collapsedCategories.contains(category)

                            Button {
                                if isCollapsed {
                                    collapsedCategories.remove(category)
                                } else {
                                    collapsedCategories.insert(category)
                                }
                            } label: {
                                HStack {
                                    Text(displayName)
                                        .font(theme.typography.headline)
                                        .foregroundStyle(theme.colors.textPrimary)
                                    Spacer()
                                    Image(systemName: isCollapsed ? "chevron.right" : "chevron.down")
                                        .foregroundStyle(theme.colors.textTertiary)
                                }
                                .padding(.horizontal, theme.spacing.l)
                                .padding(.vertical, theme.spacing.s)
                            }
                            .buttonStyle(.plain)

                            if !isCollapsed {
                                ForEach(categoryItems) { item in
                                    ShoppingItemRow(item: item, theme: theme)
                                        .padding(.horizontal, theme.spacing.l)
                                }
                            }
                        }
                    }
                    .padding(.vertical, theme.spacing.l)
                    .padding(.bottom, 80)
                }
                .background(theme.colors.background.ignoresSafeArea())

                footerView
            }
            .navigationTitle("Shopping")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private var footerView: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                VStack(alignment: .leading, spacing: theme.spacing.xs) {
                    let remaining = items.filter { !$0.isChecked }.count
                    Text("\(remaining) remaining")
                        .font(theme.typography.body)
                        .foregroundStyle(theme.colors.textPrimary)

                    let total = CostEngine.uncheckedTotal(items: items)
                    if total > 0 {
                        Text(total, format: .currency(code: "USD"))
                            .font(theme.typography.caption)
                            .foregroundStyle(theme.colors.textSecondary)
                    }
                }

                Spacer()

                Button("Done") { dismiss() }
                    .font(theme.typography.headline)
                    .foregroundStyle(theme.colors.accentPrimary)
            }
            .padding(theme.spacing.l)
            .background(theme.colors.surface)
        }
    }
}

private struct ShoppingItemRow: View {
    @Bindable var item: GroceryItem
    let theme: Theme

    var body: some View {
        Button {
            item.isChecked.toggle()
        } label: {
            DKCard(theme: theme) {
                HStack(spacing: theme.spacing.m) {
                    Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(item.isChecked ? theme.colors.success : theme.colors.textTertiary)
                        .font(.title2)

                    Text(item.name)
                        .font(theme.typography.title)
                        .foregroundStyle(item.isChecked ? theme.colors.textTertiary : theme.colors.textPrimary)
                        .strikethrough(item.isChecked, color: theme.colors.textTertiary)

                    Spacer()

                    if let cost = item.estimatedCost {
                        Text(cost, format: .currency(code: "USD"))
                            .font(theme.typography.body)
                            .foregroundStyle(theme.colors.textSecondary)
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
    }
}
