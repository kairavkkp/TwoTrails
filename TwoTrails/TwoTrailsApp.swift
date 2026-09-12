import SwiftUI

@main
struct TwoTrailsApp: App {
    @StateObject private var store = TrackerStore()
    @StateObject private var userManager = UserManager()
    @StateObject private var planStore = PlanStore()
    @StateObject private var scheduleStore = ScheduleStore()
    @StateObject private var analyticsStore: AnalyticsStore
    
    init() {
        let trackerStore = TrackerStore()
        _store = StateObject(wrappedValue: trackerStore)
        _userManager = StateObject(wrappedValue: UserManager())
        _planStore = StateObject(wrappedValue: PlanStore())
        _scheduleStore = StateObject(wrappedValue: ScheduleStore())
        _analyticsStore = StateObject(wrappedValue: AnalyticsStore(trackerStore: trackerStore))
    }

    var body: some Scene {
        WindowGroup {
            if userManager.currentUser != nil {
                ContentView()
                    .environmentObject(store)
                    .environmentObject(userManager)
                    .environmentObject(planStore)
                    .environmentObject(scheduleStore)
                    .environmentObject(analyticsStore)
                    .tint(Theme.ink)
            } else {
                UserSelectionView(isOnboarding: true)
                    .environmentObject(userManager)
                    .tint(Theme.ink)
            }
        }
    }
}
