import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userManager: UserManager
    @State private var showingUserSwitcher = false
    
    var body: some View {
        TabView {
            TodayView()
                .tabItem { Label("Today", systemImage: "sun.max") }

            ProgressView()
                .tabItem { Label("Progress", systemImage: "chart.line.uptrend.xyaxis") }

            HistoryView()
                .tabItem { Label("History", systemImage: "calendar") }

            PlanView()
                .tabItem { Label("Plan", systemImage: "list.bullet.rectangle") }
            
            SettingsView(showingUserSwitcher: $showingUserSwitcher)
                .tabItem { Label("Settings", systemImage: "gear") }
        }
        .background(Theme.paper)
        .sheet(isPresented: $showingUserSwitcher) {
            UserSelectionView(isOnboarding: false)
                .environmentObject(userManager)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(TrackerStore())
        .environmentObject(UserManager())
        .environmentObject(PlanStore())
        .environmentObject(AnalyticsStore(trackerStore: TrackerStore()))
}
