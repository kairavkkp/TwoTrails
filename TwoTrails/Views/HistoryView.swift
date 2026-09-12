import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var store: TrackerStore
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var scheduleStore: ScheduleStore
    @EnvironmentObject var planStore: PlanStore

    private var last14Days: [Date] {
        (0..<14).map { Calendar.current.date(byAdding: .day, value: -$0, to: Date())! }
    }
    
    private var currentUser: Person? {
        userManager.currentUser?.person
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Last 14 days")
                        .font(.heading(22))
                        .foregroundStyle(Theme.ink)
                        .padding(.bottom, 12)

                    if currentUser != nil {
                        ForEach(last14Days, id: \.self) { date in
                            HistoryRow(date: date)
                        }
                    }
                }
                .padding(18)
            }
            .background(Theme.paper.ignoresSafeArea())
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

private struct HistoryRow: View {
    @EnvironmentObject var store: TrackerStore
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var scheduleStore: ScheduleStore
    @EnvironmentObject var planStore: PlanStore
    let date: Date

    private var dayKind: DayKind {
        guard let person = currentUser else { return .walk }
        let variantKey = scheduleStore.getAssignedWorkout(for: date, person: person)
        return Plan.dayKind(for: variantKey)
    }
    
    private var currentUser: Person? {
        userManager.currentUser?.person
    }

    private var dayLabel: String {
        if Calendar.current.isDateInToday(date) { return "Today" }
        let f = DateFormatter()
        f.dateFormat = "EEE d/M"
        return f.string(from: date)
    }

    var body: some View {
        HStack {
            Text(dayLabel)
                .font(.system(size: 14))
                .foregroundStyle(Theme.ink)
            Spacer()
            if let person = currentUser {
                HStack(spacing: 6) {
                    mark(for: person, label: "Walk", walk: true)
                    if case .gym = dayKind {
                        mark(for: person, label: "Gym", walk: false)
                    }
                }
            }
        }
        .padding(.vertical, 10)
        .overlay(Rectangle().frame(height: 1).foregroundStyle(Theme.line), alignment: .bottom)
    }

    private func mark(for person: Person, label: String, walk: Bool) -> some View {
        let log = store.log(for: date, person: person)
        var on = false
        if walk {
            on = log.walked
        } else if case .gym(let variant) = dayKind {
            let exercises = planStore.getPlan(for: person)[variant]?.exercises ?? []
            on = log.allCompleted(for: exercises)
        }
        return Text(label)
            .font(.system(size: 11))
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(on ? Theme.accentSoft(for: person) : Color.clear)
            .foregroundStyle(on ? Theme.accent(for: person) : Theme.inkSoft)
            .overlay(Capsule().stroke(on ? Theme.accent(for: person) : Theme.line, lineWidth: 1))
            .clipShape(Capsule())
    }
}

#Preview {
    HistoryView()
        .environmentObject(TrackerStore())
        .environmentObject(UserManager())
        .environmentObject(ScheduleStore())
        .environmentObject(PlanStore())
}
