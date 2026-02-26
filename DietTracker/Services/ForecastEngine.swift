import Foundation

enum ForecastStatus: Equatable {
    case ok
    case low
    case runningLow(days: Int)
    case outSoon
    case expired
    case expiringSoon
}

enum ForecastEngine {
    nonisolated static func estimatedDaysRemaining(item: PantryItem) -> Double? {
        guard let avg = item.averageDailyUse, avg > 0 else { return nil }
        return item.quantityOnHand / avg
    }

    nonisolated static func projectedOutDate(item: PantryItem) -> Date? {
        guard let days = estimatedDaysRemaining(item: item) else { return nil }
        return Date.now.addingTimeInterval(days * 86400)
    }

    nonisolated static func isLow(item: PantryItem) -> Bool {
        item.quantityOnHand <= item.lowThreshold
    }

    nonisolated static func isExpiringSoon(item: PantryItem, withinDays: Int = 7) -> Bool {
        guard let expiry = item.expirationDate else { return false }
        guard expiry > Date.now else { return false }
        return expiry <= Date.now.addingTimeInterval(Double(withinDays) * 86400)
    }

    nonisolated static func forecastStatus(item: PantryItem) -> ForecastStatus {
        if let expiry = item.expirationDate, expiry <= Date.now {
            return .expired
        }
        if isExpiringSoon(item: item) {
            return .expiringSoon
        }
        if let days = estimatedDaysRemaining(item: item) {
            if days < 1 {
                return .outSoon
            }
            if days <= 7 {
                return .runningLow(days: Int(days))
            }
        }
        if isLow(item: item) {
            return .low
        }
        return .ok
    }
}
