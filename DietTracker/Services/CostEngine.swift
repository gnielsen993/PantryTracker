import Foundation

enum CostEngine {
    nonisolated static func estimatedCost(item: GroceryItem) -> Double? {
        item.estimatedCost
    }

    nonisolated static func estimatedTotal(items: [GroceryItem]) -> Double {
        items.reduce(0) { $0 + ($1.estimatedCost ?? 0) }
    }

    nonisolated static func uncheckedTotal(items: [GroceryItem]) -> Double {
        estimatedTotal(items: items.filter { !$0.isChecked })
    }
}
