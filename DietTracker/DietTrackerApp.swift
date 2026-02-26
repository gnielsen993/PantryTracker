import SwiftUI
import SwiftData

@main
struct DietTrackerApp: App {
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            AppBootstrapView()
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.preferredColorScheme)
        }
        .modelContainer(for: [PantryItem.self, GroceryItem.self, StoreProfile.self])
    }
}
