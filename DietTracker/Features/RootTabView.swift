import SwiftUI
import DesignKit

struct RootTabView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.colorScheme) private var colorScheme

    private var theme: Theme {
        themeManager.theme(for: colorScheme)
    }

    var body: some View {
        TabView {
            PantryView()
                .tabItem {
                    Label("Pantry", systemImage: "cabinet")
                }

            GroceryView()
                .tabItem {
                    Label("Grocery", systemImage: "cart")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .tint(theme.colors.accentPrimary)
    }
}
