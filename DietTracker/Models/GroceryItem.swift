import Foundation
import SwiftData

@Model
final class GroceryItem {
    @Attribute(.unique) var id: UUID
    var name: String
    var quantityNeeded: Double
    var unitType: String
    var category: String
    var sourceType: String
    var estimatedCost: Double?
    var isChecked: Bool
    var createdAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        quantityNeeded: Double = 1,
        unitType: UnitType = .count,
        category: PantryCategory = .other,
        sourceType: GrocerySourceType = .manual,
        estimatedCost: Double? = nil,
        isChecked: Bool = false,
        createdAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.quantityNeeded = quantityNeeded
        self.unitType = unitType.rawValue
        self.category = category.rawValue
        self.sourceType = sourceType.rawValue
        self.estimatedCost = estimatedCost
        self.isChecked = isChecked
        self.createdAt = createdAt
    }
}

enum GrocerySourceType: String, Codable {
    case manual
    case pantryLow
    case mealGenerated

    var displayName: String {
        switch self {
        case .manual: "Manual"
        case .pantryLow: "Pantry"
        case .mealGenerated: "Meal Plan"
        }
    }
}
