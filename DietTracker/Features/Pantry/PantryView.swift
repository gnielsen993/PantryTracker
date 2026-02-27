import SwiftUI
import SwiftData
import DesignKit

struct PantryView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \PantryItem.name) private var items: [PantryItem]
    @State private var viewModel = PantryViewModel()

    @State private var showingAddItem = false
    @State private var editingItem: PantryItem?

    private var theme: Theme {
        themeManager.theme(for: colorScheme)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: theme.spacing.l) {
                    let lowItems = viewModel.runningLow(from: items)
                    let expiringItems = viewModel.expiringSoon(from: items)
                    let categorized = viewModel.itemsByCategory(from: items)

                    if !lowItems.isEmpty {
                        DKSectionHeader("Running Low", theme: theme)
                            .padding(.horizontal, theme.spacing.l)

                        ForEach(lowItems) { item in
                            PantryItemRow(item: item, theme: theme)
                                .padding(.horizontal, theme.spacing.l)
                                .onTapGesture { editingItem = item }
                        }
                    }

                    if !expiringItems.isEmpty {
                        DKSectionHeader("Expiring Soon", theme: theme)
                            .padding(.horizontal, theme.spacing.l)

                        ForEach(expiringItems) { item in
                            PantryItemRow(item: item, theme: theme)
                                .padding(.horizontal, theme.spacing.l)
                                .onTapGesture { editingItem = item }
                        }
                    }

                    DKSectionHeader("All Items", theme: theme)
                        .padding(.horizontal, theme.spacing.l)

                    ForEach(categorized, id: \.0) { category, categoryItems in
                        Text(PantryCategory(rawValue: category)?.displayName ?? category)
                            .font(theme.typography.caption)
                            .foregroundStyle(theme.colors.textTertiary)
                            .padding(.horizontal, theme.spacing.l)
                            .padding(.top, theme.spacing.xs)

                        ForEach(categoryItems) { item in
                            PantryItemRow(item: item, theme: theme)
                                .padding(.horizontal, theme.spacing.l)
                                .onTapGesture { editingItem = item }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        modelContext.delete(item)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }

                    if items.isEmpty {
                        ContentUnavailableView(
                            "No Items",
                            systemImage: "cabinet",
                            description: Text("Add items to track your pantry.")
                        )
                        .padding(.top, theme.spacing.xl)
                    }
                }
                .padding(.vertical, theme.spacing.l)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(theme.colors.background.ignoresSafeArea())
            .navigationTitle("Pantry")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddItem = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddItem) {
                AddEditPantryItemView(item: nil)
            }
            .sheet(item: $editingItem) { item in
                AddEditPantryItemView(item: item)
            }
        }
    }
}
