import SwiftUI

struct PersonCard: View {
    @EnvironmentObject var store: TrackerStore
    @EnvironmentObject var planStore: PlanStore
    let person: Person
    let date: Date
    let dayKind: DayKind

    private let walkOptions = [20, 30, 40, 60]

    private var log: DailyLog { store.log(for: date, person: person) }

    private var exercises: [ExerciseItem] {
        if case .gym(let variant) = dayKind {
            return planStore.getPlan(for: person)[variant]?.exercises ?? []
        }
        return []
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle()
                .fill(Theme.accent(for: person))
                .frame(height: 4)

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(person.displayName)
                        .font(.heading(19))
                        .foregroundStyle(Theme.accent(for: person))
                    Spacer()
                    if !exercises.isEmpty {
                        Text("\(log.completedCount(for: exercises))/\(exercises.count) done")
                            .font(.system(size: 12))
                            .foregroundStyle(Theme.inkSoft)
                    }
                }

                walkRow

                if !exercises.isEmpty {
                    Divider().background(Theme.line)
                    ForEach(exercises) { ex in
                        exerciseRow(ex)
                    }
                } else if dayKind == .walk {
                    Text("No gym today — just get the walk in.")
                        .font(.system(size: 14))
                        .foregroundStyle(Theme.inkSoft)
                        .padding(.top, 2)
                } else {
                    Text("Rest day. Light movement is fine.")
                        .font(.system(size: 14))
                        .foregroundStyle(Theme.inkSoft)
                        .padding(.top, 2)
                }
            }
            .padding(16)
        }
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.line, lineWidth: 1))
    }

    private var walkRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Walk")
                        .font(.system(size: 15))
                        .foregroundStyle(Theme.ink)
                    Text(log.walkMinutes > 0 ? "\(log.walkMinutes) min logged" : "Not logged yet")
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.inkSoft)
                }
                Spacer()
            }
            HStack(spacing: 6) {
                ForEach(walkOptions, id: \.self) { minutes in
                    let active = log.walkMinutes == minutes
                    Button {
                        store.setWalkMinutes(minutes, date: date, person: person)
                    } label: {
                        Text("\(minutes)")
                            .font(.system(size: 13))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(active ? Theme.accentSoft(for: person) : Color.clear)
                            .foregroundStyle(active ? Theme.accent(for: person) : Theme.ink)
                            .overlay(
                                Capsule().stroke(active ? Theme.accent(for: person) : Theme.line, lineWidth: 1)
                            )
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            Divider().background(Theme.line).padding(.top, 4)
        }
    }

    private func exerciseRow(_ ex: ExerciseItem) -> some View {
        let checked = log.exChecked[ex.id] == true
        return VStack(spacing: 0) {
            Button {
                store.toggleExercise(ex.id, date: date, person: person)
            } label: {
                HStack(alignment: .top, spacing: 11) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(checked ? Theme.accent(for: person) : Theme.inkSoft, lineWidth: 1.5)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(checked ? Theme.accent(for: person) : Color.clear)
                            )
                            .frame(width: 20, height: 20)
                        if checked {
                            Image(systemName: "checkmark")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.top, 1)

                    VStack(alignment: .leading, spacing: 1) {
                        Text(ex.name)
                            .font(.system(size: 15))
                            .foregroundStyle(checked ? Theme.inkSoft : Theme.ink)
                            .strikethrough(checked)
                        Text(ex.sets)
                            .font(.system(size: 12))
                            .foregroundStyle(Theme.inkSoft)
                    }
                    Spacer()
                }
                .padding(.vertical, 8)
            }
            .buttonStyle(.plain)
            Divider().background(Theme.line)
        }
    }
}
