import Foundation
import SwiftData

@Model
final class PantryItem {
    @Attribute(.unique) var id: UUID
    var name: String
    var category: String
    var unitType: String
    var quantityOnHand: Double
    var lowThreshold: Double
    var averageDailyUse: Double?
    var lastPurchasedDate: Date?
    var expirationDate: Date?
    var priceLastPaid: Double?
    var isRecurring: Bool
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        category: PantryCategory = .other,
        unitType: UnitType = .count,
        quantityOnHand: Double = 0,
        lowThreshold: Double = 1,
        averageDailyUse: Double? = nil,
        lastPurchasedDate: Date? = nil,
        expirationDate: Date? = nil,
        priceLastPaid: Double? = nil,
        isRecurring: Bool = true,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.category = category.rawValue
        self.unitType = unitType.rawValue
        self.quantityOnHand = quantityOnHand
        self.lowThreshold = lowThreshold
        self.averageDailyUse = averageDailyUse
        self.lastPurchasedDate = lastPurchasedDate
        self.expirationDate = expirationDate
        self.priceLastPaid = priceLastPaid
        self.isRecurring = isRecurring
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

enum PantryCategory: String, CaseIterable, Codable {
    case produce
    case dairy
    case meat
    case pantry
    case frozen
    case beverages
    case snacks
    case household
    case personal
    case other

    var displayName: String {
        switch self {
        case .produce: "Produce"
        case .dairy: "Dairy"
        case .meat: "Meat"
        case .pantry: "Pantry"
        case .frozen: "Frozen"
        case .beverages: "Beverages"
        case .snacks: "Snacks"
        case .household: "Household"
        case .personal: "Personal"
        case .other: "Other"
        }
    }
}

enum UnitType: String, CaseIterable, Codable {
    case count
    case grams
    case ounces
    case pounds
    case liters
    case milliliters
    case cups
    case tablespoons
    case teaspoons

    var displayName: String {
        switch self {
        case .count: "Count"
        case .grams: "Grams"
        case .ounces: "Ounces"
        case .pounds: "Pounds"
        case .liters: "Liters"
        case .milliliters: "Milliliters"
        case .cups: "Cups"
        case .tablespoons: "Tablespoons"
        case .teaspoons: "Teaspoons"
        }
    }
}
