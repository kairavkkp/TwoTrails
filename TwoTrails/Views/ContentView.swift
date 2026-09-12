import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Today", systemImage: "sun.max") }

            HistoryView()
                .tabItem { Label("History", systemImage: "calendar") }

            PlanView()
                .tabItem { Label("Plan", systemImage: "list.bullet.rectangle") }
        }
        .background(Theme.paper)
    }
}

#Preview {
    ContentView().environmentObject(TrackerStore())
}
