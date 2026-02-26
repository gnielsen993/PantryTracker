import Testing
import Foundation
@testable import DietTracker

@Suite("Engine Tests")
struct EngineTests {

    // MARK: - ForecastEngine

    @Test func testEstimatedDaysRemainingBasicMath() {
        let item = PantryItem(name: "Milk", quantityOnHand: 12, lowThreshold: 2, averageDailyUse: 3)
        let days = ForecastEngine.estimatedDaysRemaining(item: item)
        #expect(days == 4.0)
    }

    @Test func testEstimatedDaysRemainingNilWhenNoAverage() {
        let item = PantryItem(name: "Milk", quantityOnHand: 12, lowThreshold: 2, averageDailyUse: nil)
        let days = ForecastEngine.estimatedDaysRemaining(item: item)
        #expect(days == nil)
    }

    @Test func testIsLowWhenAtThreshold() {
        let item = PantryItem(name: "Eggs", quantityOnHand: 2, lowThreshold: 2)
        #expect(ForecastEngine.isLow(item: item) == true)
    }

    @Test func testIsNotLowWhenAboveThreshold() {
        let item = PantryItem(name: "Eggs", quantityOnHand: 5, lowThreshold: 2)
        #expect(ForecastEngine.isLow(item: item) == false)
    }

    @Test func testForecastStatusExpired() {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        let item = PantryItem(name: "Yogurt", quantityOnHand: 3, lowThreshold: 1, expirationDate: yesterday)
        let status = ForecastEngine.forecastStatus(item: item)
        #expect(status == .expired)
    }

    @Test func testForecastStatusRunningLow() {
        let item = PantryItem(name: "Bread", quantityOnHand: 6, lowThreshold: 1, averageDailyUse: 2)
        let status = ForecastEngine.forecastStatus(item: item)
        #expect(status == .runningLow(days: 3))
    }

    // MARK: - CostEngine

    @Test func testUncheckedTotalExcludesCheckedItems() {
        let itemA = GroceryItem(name: "A", estimatedCost: 5.0)
        let itemB = GroceryItem(name: "B", estimatedCost: 3.0, isChecked: true)
        let itemC = GroceryItem(name: "C", estimatedCost: 2.0)
        let total = CostEngine.uncheckedTotal(items: [itemA, itemB, itemC])
        #expect(total == 7.0)
    }

    @Test func testEstimatedTotalIgnoresNilCosts() {
        let itemA = GroceryItem(name: "A", estimatedCost: 5.0)
        let itemB = GroceryItem(name: "B", estimatedCost: nil)
        let total = CostEngine.estimatedTotal(items: [itemA, itemB])
        #expect(total == 5.0)
    }

    // MARK: - GroceryListEngine

    @Test func testAutoItemsOnlyIncludesLowAndRecurring() {
        let lowRecurring = PantryItem(name: "Salt", quantityOnHand: 0, lowThreshold: 1, isRecurring: true)
        let lowNotRecurring = PantryItem(name: "Pepper", quantityOnHand: 0, lowThreshold: 1, isRecurring: false)
        let notLow = PantryItem(name: "Sugar", quantityOnHand: 5, lowThreshold: 1, isRecurring: true)

        let result = GroceryListEngine.autoItems(from: [lowRecurring, lowNotRecurring, notLow])
        #expect(result.count == 1)
        #expect(result.first?.name == "Salt")
    }

    @Test func testMergedSumsQuantitiesForDuplicates() {
        let existing = [GroceryItem(name: "Milk", quantityNeeded: 1)]
        let new = [GroceryItem(name: "milk", quantityNeeded: 2)]
        let merged = GroceryListEngine.merged(existing: existing, new: new)
        #expect(merged.count == 1)
        #expect(merged.first?.quantityNeeded == 3)
    }

    @Test func testMergedAppendsUniqueItems() {
        let existing = [GroceryItem(name: "Bread")]
        let new = [GroceryItem(name: "Butter")]
        let merged = GroceryListEngine.merged(existing: existing, new: new)
        #expect(merged.count == 2)
    }
}
