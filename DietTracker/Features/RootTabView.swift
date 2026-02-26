import SwiftUI

struct RootTabView: View {
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
    }
}
