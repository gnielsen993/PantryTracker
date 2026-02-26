import Foundation
import SwiftData

struct PantryExportBundle: Codable {
    let schemaVersion: Int
    let exportedAt: Date
    let pantryItems: [PantryItemDTO]
    let groceryItems: [GroceryItemDTO]
}

struct PantryItemDTO: Codable {
    let id: UUID
    let name: String
    let category: String
    let unitType: String
    let quantityOnHand: Double
    let lowThreshold: Double
    let averageDailyUse: Double?
    let lastPurchasedDate: Date?
    let expirationDate: Date?
    let priceLastPaid: Double?
    let isRecurring: Bool
    let createdAt: Date
    let updatedAt: Date
}

struct GroceryItemDTO: Codable {
    let id: UUID
    let name: String
    let quantityNeeded: Double
    let unitType: String
    let category: String
    let sourceType: String
    let estimatedCost: Double?
    let isChecked: Bool
    let createdAt: Date
}

enum ImportError: Error {
    case unsupportedSchema(Int)
}

final class ExportImportService {
    private let schemaVersion = 1
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        self.encoder = encoder
        self.decoder = decoder
    }

    func exportData(pantryItems: [PantryItem], groceryItems: [GroceryItem]) throws -> Data {
        let pantryDTOs = pantryItems.map { item in
            PantryItemDTO(
                id: item.id,
                name: item.name,
                category: item.category,
                unitType: item.unitType,
                quantityOnHand: item.quantityOnHand,
                lowThreshold: item.lowThreshold,
                averageDailyUse: item.averageDailyUse,
                lastPurchasedDate: item.lastPurchasedDate,
                expirationDate: item.expirationDate,
                priceLastPaid: item.priceLastPaid,
                isRecurring: item.isRecurring,
                createdAt: item.createdAt,
                updatedAt: item.updatedAt
            )
        }

        let groceryDTOs = groceryItems.map { item in
            GroceryItemDTO(
                id: item.id,
                name: item.name,
                quantityNeeded: item.quantityNeeded,
                unitType: item.unitType,
                category: item.category,
                sourceType: item.sourceType,
                estimatedCost: item.estimatedCost,
                isChecked: item.isChecked,
                createdAt: item.createdAt
            )
        }

        let bundle = PantryExportBundle(
            schemaVersion: schemaVersion,
            exportedAt: .now,
            pantryItems: pantryDTOs,
            groceryItems: groceryDTOs
        )

        return try encoder.encode(bundle)
    }

    func importData(_ data: Data, into context: ModelContext) throws {
        let bundle = try decoder.decode(PantryExportBundle.self, from: data)
        guard bundle.schemaVersion == schemaVersion else {
            throw ImportError.unsupportedSchema(bundle.schemaVersion)
        }

        try context.delete(model: PantryItem.self)
        try context.delete(model: GroceryItem.self)

        for dto in bundle.pantryItems {
            let item = PantryItem(
                id: dto.id,
                name: dto.name,
                category: PantryCategory(rawValue: dto.category) ?? .other,
                unitType: UnitType(rawValue: dto.unitType) ?? .count,
                quantityOnHand: dto.quantityOnHand,
                lowThreshold: dto.lowThreshold,
                averageDailyUse: dto.averageDailyUse,
                lastPurchasedDate: dto.lastPurchasedDate,
                expirationDate: dto.expirationDate,
                priceLastPaid: dto.priceLastPaid,
                isRecurring: dto.isRecurring,
                createdAt: dto.createdAt,
                updatedAt: dto.updatedAt
            )
            context.insert(item)
        }

        for dto in bundle.groceryItems {
            let item = GroceryItem(
                id: dto.id,
                name: dto.name,
                quantityNeeded: dto.quantityNeeded,
                unitType: UnitType(rawValue: dto.unitType) ?? .count,
                category: PantryCategory(rawValue: dto.category) ?? .other,
                sourceType: GrocerySourceType(rawValue: dto.sourceType) ?? .manual,
                estimatedCost: dto.estimatedCost,
                isChecked: dto.isChecked,
                createdAt: dto.createdAt
            )
            context.insert(item)
        }

        try context.save()
    }
}
