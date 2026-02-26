import SwiftUI
import SwiftData
import DesignKit

struct AddEditPantryItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.colorScheme) private var colorScheme

    var item: PantryItem?

    @State private var name = ""
    @State private var category: PantryCategory = .other
    @State private var unitType: UnitType = .count
    @State private var quantityOnHand = 0.0
    @State private var lowThreshold = 1.0
    @State private var averageDailyUse = ""
    @State private var hasExpiration = false
    @State private var expirationDate = Date.now
    @State private var priceLastPaid = ""
    @State private var isRecurring = true

    private var theme: Theme {
        themeManager.theme(for: colorScheme)
    }

    private var isEditing: Bool { item != nil }

    var body: some View {
        NavigationStack {
            Form {
                Section("Item") {
                    TextField("Name", text: $name)

                    Picker("Category", selection: $category) {
                        ForEach(PantryCategory.allCases, id: \.self) { cat in
                            Text(cat.displayName).tag(cat)
                        }
                    }

                    Picker("Unit", selection: $unitType) {
                        ForEach(UnitType.allCases, id: \.self) { unit in
                            Text(unit.displayName).tag(unit)
                        }
                    }
                }

                Section("Quantity") {
                    #if os(iOS)
                    TextField("Quantity on Hand", value: $quantityOnHand, format: .number)
                        .keyboardType(.decimalPad)

                    TextField("Low Threshold", value: $lowThreshold, format: .number)
                        .keyboardType(.decimalPad)

                    TextField("Avg. Daily Use (optional)", text: $averageDailyUse)
                        .keyboardType(.decimalPad)
                    #else
                    TextField("Quantity on Hand", value: $quantityOnHand, format: .number)
                    TextField("Low Threshold", value: $lowThreshold, format: .number)
                    TextField("Avg. Daily Use (optional)", text: $averageDailyUse)
                    #endif
                }

                Section("Expiration") {
                    Toggle("Has Expiration Date", isOn: $hasExpiration)
                    if hasExpiration {
                        DatePicker("Expiration Date", selection: $expirationDate, displayedComponents: .date)
                    }
                }

                Section("Cost & Recurring") {
                    #if os(iOS)
                    TextField("Price Last Paid (optional)", text: $priceLastPaid)
                        .keyboardType(.decimalPad)
                    #else
                    TextField("Price Last Paid (optional)", text: $priceLastPaid)
                    #endif
                    Toggle("Recurring Purchase", isOn: $isRecurring)
                }
            }
            .navigationTitle(isEditing ? "Edit Item" : "Add Item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                populateIfEditing()
            }
        }
    }

    private func populateIfEditing() {
        guard let item else { return }
        name = item.name
        category = PantryCategory(rawValue: item.category) ?? .other
        unitType = UnitType(rawValue: item.unitType) ?? .count
        quantityOnHand = item.quantityOnHand
        lowThreshold = item.lowThreshold
        if let avg = item.averageDailyUse {
            averageDailyUse = avg.formatted()
        }
        if let expiry = item.expirationDate {
            hasExpiration = true
            expirationDate = expiry
        }
        if let price = item.priceLastPaid {
            priceLastPaid = price.formatted()
        }
        isRecurring = item.isRecurring
    }

    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }

        let avgUse = Double(averageDailyUse)
        let price = Double(priceLastPaid)
        let expiry: Date? = hasExpiration ? expirationDate : nil

        if let item {
            item.name = trimmedName
            item.category = category.rawValue
            item.unitType = unitType.rawValue
            item.quantityOnHand = quantityOnHand
            item.lowThreshold = lowThreshold
            item.averageDailyUse = avgUse
            item.expirationDate = expiry
            item.priceLastPaid = price
            item.isRecurring = isRecurring
            item.updatedAt = .now
        } else {
            let newItem = PantryItem(
                name: trimmedName,
                category: category,
                unitType: unitType,
                quantityOnHand: quantityOnHand,
                lowThreshold: lowThreshold,
                averageDailyUse: avgUse,
                expirationDate: expiry,
                priceLastPaid: price,
                isRecurring: isRecurring
            )
            modelContext.insert(newItem)
        }

        dismiss()
    }
}
