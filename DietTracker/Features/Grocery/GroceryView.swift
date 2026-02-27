import SwiftUI
import SwiftData
import DesignKit

struct GroceryView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext

    @Query(sort: \GroceryItem.category) private var groceryItems: [GroceryItem]
    @Query(sort: \PantryItem.name) private var pantryItems: [PantryItem]
    @State private var viewModel = GroceryViewModel()

    @State private var showingShoppingMode = false
    @State private var quickAddName = ""

    private var theme: Theme {
        themeManager.theme(for: colorScheme)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: theme.spacing.l) {
                    DKCard(theme: theme) {
                        HStack(spacing: theme.spacing.m) {
                            TextField("Quick add item…", text: $quickAddName)
                                .font(theme.typography.body)
                                .foregroundStyle(theme.colors.textPrimary)

                            Button {
                                addQuickItem()
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(theme.colors.accentPrimary)
                            }
                            .buttonStyle(.plain)
                            .disabled(quickAddName.trimmingCharacters(in: .whitespaces).isEmpty)
                        }
                    }
                    .padding(.horizontal, theme.spacing.l)

                    let total = CostEngine.estimatedTotal(items: groceryItems)
                    if total > 0 {
                        DKCard(theme: theme) {
                            HStack {
                                Text("Est. Total")
                                    .font(theme.typography.body)
                                    .foregroundStyle(theme.colors.textSecondary)
                                Spacer()
                                Text(total, format: .currency(code: "USD"))
                                    .font(theme.typography.headline)
                                    .foregroundStyle(theme.colors.textPrimary)
                            }
                        }
                        .padding(.horizontal, theme.spacing.l)
                    }

                    let categorized = viewModel.groupedByCategory(from: groceryItems)

                    ForEach(categorized, id: \.0) { category, categoryItems in
                        Text(PantryCategory(rawValue: category)?.displayName ?? category)
                            .font(theme.typography.caption)
                            .foregroundStyle(theme.colors.textTertiary)
                            .padding(.horizontal, theme.spacing.l)
                            .padding(.top, theme.spacing.xs)

                        ForEach(categoryItems) { item in
                            GroceryItemRow(item: item, theme: theme)
                                .padding(.horizontal, theme.spacing.l)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        modelContext.delete(item)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                        }
                    }

                    if !groceryItems.isEmpty {
                        DKButton("Refresh from Pantry", style: .secondary, theme: theme) {
                            viewModel.refreshFromPantry(
                                pantryItems: pantryItems,
                                existingGrocery: groceryItems,
                                context: modelContext
                            )
                        }
                        .padding(.horizontal, theme.spacing.l)
                    }

                    if groceryItems.isEmpty {
                        ContentUnavailableView(
                            "No Items",
                            systemImage: "cart",
                            description: Text("Add items or refresh from your pantry.")
                        )
                        .padding(.top, theme.spacing.xl)
                    }
                }
                .padding(.vertical, theme.spacing.l)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(theme.colors.background.ignoresSafeArea())
            .navigationTitle("Grocery")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Shop") {
                        showingShoppingMode = true
                    }
                    .disabled(groceryItems.isEmpty)
                }
            }
            #if os(iOS)
            .fullScreenCover(isPresented: $showingShoppingMode) {
                ShoppingModeView()
            }
            #else
            .sheet(isPresented: $showingShoppingMode) {
                ShoppingModeView()
            }
            #endif
        }
    }

    private func addQuickItem() {
        let trimmed = quickAddName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        let item = GroceryItem(name: trimmed)
        modelContext.insert(item)
        quickAddName = ""
    }
}
