import Foundation
import SwiftData

@Model
final class StoreProfile {
    @Attribute(.unique) var id: UUID
    var name: String
    var defaultTaxRate: Double?
    var createdAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        defaultTaxRate: Double? = nil,
        createdAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.defaultTaxRate = defaultTaxRate
        self.createdAt = createdAt
    }
}
