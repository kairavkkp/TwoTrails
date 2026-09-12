import SwiftUI

struct PlanView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var planStore: PlanStore
    @EnvironmentObject var scheduleStore: ScheduleStore
    private let dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    @State private var editingVariant: (key: String, variant: WorkoutVariant)?
    @State private var showingResetAlert = false
    @State private var showingScheduleEditor = false
    
    private var currentUser: Person? {
        userManager.currentUser?.person
    }
    
    private var currentPlan: [String: WorkoutVariant] {
        guard let person = currentUser else { return [:] }
        return planStore.getPlan(for: person)
    }
    
    private var isUsingCustomPlan: Bool {
        guard let person = currentUser else { return false }
        return planStore.isUsingCustomPlan(for: person)
    }
    
    private var schedule: WeeklySchedule {
        guard let person = currentUser else { return WeeklySchedule() }
        return scheduleStore.getSchedule(for: person)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your 12-week plan. Tap days below to assign workouts.")
                            .font(.system(size: 13))
                            .foregroundStyle(Theme.inkSoft)
                        
                        if isUsingCustomPlan {
                            HStack {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 11))
                                    .foregroundStyle(Theme.accent(for: currentUser ?? .him))
                                Text("Using custom plan")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Theme.accent(for: currentUser ?? .him))
                                Spacer()
                                Button {
                                    showingResetAlert = true
                                } label: {
                                    Text("Reset to default")
                                        .font(.system(size: 12))
                                        .foregroundStyle(Theme.inkSoft)
                                }
                            }
                            .padding(.top, 4)
                        }
                    }

                    weekGrid
                    
                    Button {
                        showingScheduleEditor = true
                    } label: {
                        HStack {
                            Image(systemName: "calendar.badge.clock")
                            Text("Edit Weekly Schedule")
                        }
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Theme.accent(for: currentUser ?? .him))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)

                    if let person = currentUser {
                        sectionHeader(person == .him ? "Your Workouts" : "Your Workouts")
                        ForEach(["A", "B", "C"], id: \.self) { v in
                            if let variant = currentPlan[v] {
                                PlanBlock(
                                    person: person,
                                    variant: variant,
                                    variantKey: v,
                                    onEdit: {
                                        editingVariant = (key: v, variant: variant)
                                    }
                                )
                            }
                        }
                    }
                }
                .padding(18)
            }
            .background(Theme.paper.ignoresSafeArea())
            .navigationBarHidden(true)
            .sheet(item: Binding(
                get: { editingVariant.map { EditVariantWrapper(key: $0.key, variant: $0.variant) } },
                set: { editingVariant = $0.map { ($0.key, $0.variant) } }
            )) { wrapper in
                EditWorkoutView(variantKey: wrapper.key, variant: wrapper.variant)
                    .environmentObject(planStore)
                    .environmentObject(userManager)
            }
            .sheet(isPresented: $showingScheduleEditor) {
                if let person = currentUser {
                    ScheduleEditorView(person: person)
                        .environmentObject(scheduleStore)
                        .environmentObject(planStore)
                }
            }
            .alert("Reset to Default Plan?", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    if let person = currentUser {
                        planStore.resetToDefault(for: person)
                    }
                }
            } message: {
                Text("This will restore the original workout plan. Your custom changes will be lost.")
            }
        }
    }

    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.heading(17))
            .foregroundStyle(Theme.ink)
    }

    private var weekGrid: some View {
        HStack(spacing: 5) {
            ForEach(1...7, id: \.self) { weekday in
                let variantKey = schedule.assignments[weekday] ?? nil
                let isGym = variantKey != nil
                VStack(spacing: 2) {
                    Text(dayNames[weekday - 1])
                        .font(.system(size: 11, weight: .medium))
                    if let key = variantKey {
                        Text(key)
                            .font(.system(size: 11, weight: .bold))
                    } else {
                        Text("—")
                            .font(.system(size: 11))
                    }
                }
                .foregroundStyle(isGym ? Theme.accent(for: currentUser ?? .him) : Theme.inkSoft)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .background(isGym ? Theme.accentSoft(for: currentUser ?? .him) : Color.clear)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(isGym ? Theme.accent(for: currentUser ?? .him) : Theme.line, lineWidth: 1))
            }
        }
    }
}

// Wrapper to make the editing state identifiable
struct EditVariantWrapper: Identifiable {
    let id = UUID()
    let key: String
    let variant: WorkoutVariant
}

private struct PlanBlock: View {
    let person: Person
    let variant: WorkoutVariant
    let variantKey: String
    let onEdit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(variantKey): \(variant.label)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Theme.accent(for: person))
                
                Spacer()
                
                Button {
                    onEdit()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "pencil")
                        Text("Edit")
                    }
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.accent(for: person))
                }
                .buttonStyle(.plain)
            }

            VStack(spacing: 0) {
                ForEach(variant.exercises) { ex in
                    HStack {
                        Text(ex.name).font(.system(size: 13.5)).foregroundStyle(Theme.ink)
                        Spacer()
                        Text(ex.sets).font(.system(size: 13.5)).foregroundStyle(Theme.inkSoft)
                    }
                    .padding(.vertical, 5)
                    .overlay(Rectangle().frame(height: 1).foregroundStyle(Theme.line), alignment: .bottom)
                }
            }
        }
        .padding(14)
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.line, lineWidth: 1))
    }
}

#Preview {
    PlanView()
        .environmentObject(UserManager())
        .environmentObject(PlanStore())
        .environmentObject(ScheduleStore())
}
