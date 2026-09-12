import SwiftUI

@main
struct TwoTrailsApp: App {
    @StateObject private var store = TrackerStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .tint(Theme.ink)
        }
    }
}
