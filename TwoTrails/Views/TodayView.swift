import SwiftUI

struct TodayView: View {
    @EnvironmentObject var store: TrackerStore
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var scheduleStore: ScheduleStore
    @EnvironmentObject var planStore: PlanStore
    private let today = Date()

    private var dayKind: DayKind {
        guard let person = currentUser else { return .walk }
        let variantKey = scheduleStore.getAssignedWorkout(for: today, person: person)
        return Plan.dayKind(forVariant: variantKey)
    }

    private var dateLabel: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, d MMMM"
        return f.string(from: today)
    }
    
    private var currentUser: Person? {
        userManager.currentUser?.person
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    header

                    if let user = currentUser {
                        PersonCard(person: user, date: today, dayKind: dayKind)
                    }
                }
                .padding(18)
            }
            .background(Theme.paper.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(dateLabel)
                .font(.system(size: 13))
                .foregroundStyle(Theme.inkSoft)
            Text("Two Trails")
                .font(.heading(28))
                .foregroundStyle(Theme.ink)
            Text(dayKind.label)
                .font(.system(size: 13))
                .foregroundStyle(Theme.inkSoft)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Theme.line, lineWidth: 1)
                )
        }
        .padding(.bottom, 4)
    }
}

#Preview {
    TodayView()
        .environmentObject(TrackerStore())
        .environmentObject(UserManager())
        .environmentObject(ScheduleStore())
        .environmentObject(PlanStore())
}
