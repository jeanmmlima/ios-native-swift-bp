import SwiftUI

@main
struct GreatPlacesMVVMApp: App {
    @State private var store = PlacesStore()

    var body: some Scene {
        WindowGroup {
            PlacesListView()
                .environment(store)
        }
    }
}
