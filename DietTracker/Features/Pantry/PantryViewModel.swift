import Foundation

@Observable
@MainActor
final class PantryViewModel {
    func runningLow(from items: [PantryItem]) -> [PantryItem] {
        items
            .filter { ForecastEngine.isLow(item: $0) }
            .sorted { $0.name < $1.name }
    }

    func expiringSoon(from items: [PantryItem]) -> [PantryItem] {
        items
            .filter { ForecastEngine.isExpiringSoon(item: $0) }
            .sorted { ($0.expirationDate ?? .distantFuture) < ($1.expirationDate ?? .distantFuture) }
    }

    func itemsByCategory(from items: [PantryItem]) -> [(String, [PantryItem])] {
        let grouped = Dictionary(grouping: items) { $0.category }
        return grouped
            .sorted { $0.key < $1.key }
            .map { (key, items) in (key, items.sorted { $0.name < $1.name }) }
    }
}
