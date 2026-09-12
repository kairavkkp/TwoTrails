import SwiftUI

struct ScheduleEditorView: View {
    @EnvironmentObject var scheduleStore: ScheduleStore
    @EnvironmentObject var planStore: PlanStore
    @Environment(\.dismiss) private var dismiss
    
    let person: Person
    
    @State private var schedule: WeeklySchedule
    private let dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    init(person: Person) {
        self.person = person
        _schedule = State(initialValue: WeeklySchedule())
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.paper.ignoresSafeArea()
                
                List {
                    Section {
                        Text("Assign workouts (A, B, or C) to specific days of the week. Leave empty for walk-only days.")
                            .font(.system(size: 13))
                            .foregroundStyle(Theme.inkSoft)
                            .listRowBackground(Color.clear)
                    }
                    
                    Section {
                        ForEach(1...7, id: \.self) { weekday in
                            DayScheduleRow(
                                dayName: dayNames[weekday - 1],
                                weekday: weekday,
                                selectedWorkout: Binding(
                                    get: { schedule.assignments[weekday] ?? nil },
                                    set: { schedule.assignments[weekday] = $0 }
                                ),
                                person: person
                            )
                            .listRowBackground(Theme.card)
                        }
                    } header: {
                        Text("Weekly Schedule")
                            .foregroundStyle(Theme.ink)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Edit Schedule")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(Theme.ink)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveSchedule()
                        dismiss()
                    }
                    .foregroundStyle(Theme.ink)
                }
            }
            .onAppear {
                schedule = scheduleStore.getSchedule(for: person)
            }
        }
    }
    
    private func saveSchedule() {
        for (weekday, workout) in schedule.assignments {
            scheduleStore.assignWorkout(workout, to: weekday, for: person)
        }
    }
}

struct DayScheduleRow: View {
    let dayName: String
    let weekday: Int
    @Binding var selectedWorkout: String?
    let person: Person
    
    private let workoutOptions = ["A", "B", "C"]
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(dayName)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Theme.ink)
                
                if let workout = selectedWorkout {
                    Text("Workout \(workout)")
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.accent(for: person))
                } else {
                    Text("Walk only")
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.inkSoft)
                }
            }
            
            Spacer()
            
            HStack(spacing: 6) {
                // Rest/Walk option
                Button {
                    selectedWorkout = nil
                } label: {
                    Image(systemName: selectedWorkout == nil ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 20))
                        .foregroundStyle(selectedWorkout == nil ? Theme.accent(for: person) : Theme.line)
                }
                .buttonStyle(.plain)
                
                Divider()
                    .frame(height: 24)
                
                // Workout options
                ForEach(workoutOptions, id: \.self) { workout in
                    Button {
                        selectedWorkout = workout
                    } label: {
                        Text(workout)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(selectedWorkout == workout ? .white : Theme.ink)
                            .frame(width: 32, height: 32)
                            .background(selectedWorkout == workout ? Theme.accent(for: person) : Theme.line.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ScheduleEditorView(person: .him)
        .environmentObject(ScheduleStore())
        .environmentObject(PlanStore())
}
