import Foundation

enum GroceryListEngine {
    nonisolated static func autoItems(from pantryItems: [PantryItem]) -> [GroceryItem] {
        pantryItems
            .filter { ForecastEngine.isLow(item: $0) && $0.isRecurring }
            .map { item in
                GroceryItem(
                    name: item.name,
                    quantityNeeded: item.lowThreshold,
                    unitType: UnitType(rawValue: item.unitType) ?? .count,
                    category: PantryCategory(rawValue: item.category) ?? .other,
                    sourceType: .pantryLow,
                    estimatedCost: item.priceLastPaid
                )
            }
    }

    nonisolated static func merged(existing: [GroceryItem], new: [GroceryItem]) -> [GroceryItem] {
        var result = existing
        for newItem in new {
            if let index = result.firstIndex(where: { $0.name.lowercased() == newItem.name.lowercased() }) {
                result[index].quantityNeeded += newItem.quantityNeeded
            } else {
                result.append(newItem)
            }
        }
        return result
    }
}
