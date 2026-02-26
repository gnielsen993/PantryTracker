import Foundation
import SwiftData

@Observable
@MainActor
final class GroceryViewModel {
    func groupedByCategory(from items: [GroceryItem]) -> [(String, [GroceryItem])] {
        let grouped = Dictionary(grouping: items) { $0.category }
        return grouped
            .sorted { $0.key < $1.key }
            .map { (key, items) in (key, items.sorted { $0.name < $1.name }) }
    }

    func refreshFromPantry(
        pantryItems: [PantryItem],
        existingGrocery: [GroceryItem],
        context: ModelContext
    ) {
        let autoItems = GroceryListEngine.autoItems(from: pantryItems)
        let merged = GroceryListEngine.merged(existing: existingGrocery, new: autoItems)

        let existingIDs = Set(existingGrocery.map { $0.id })
        for item in merged {
            if !existingIDs.contains(item.id) {
                context.insert(item)
            } else if let existing = existingGrocery.first(where: { $0.id == item.id }) {
                existing.quantityNeeded = item.quantityNeeded
            }
        }
    }
}
