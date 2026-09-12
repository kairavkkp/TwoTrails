import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var analyticsStore: AnalyticsStore
    @EnvironmentObject var userManager: UserManager
    
    private var currentPerson: Person? {
        userManager.currentUser?.person
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.paper.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        if let person = currentPerson {
                            // Header
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Your Progress")
                                    .font(.heading(28))
                                    .foregroundStyle(Theme.ink)
                                Text("Track your fitness journey")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Theme.inkSoft)
                            }
                            .padding(.bottom, 8)
                            
                            // Streaks Card
                            if let streaks = analyticsStore.streaks {
                                StreakCard(streaks: streaks, person: person)
                            }
                            
                            // Weekly Stats
                            if let weekly = analyticsStore.weeklyStats {
                                SectionHeader(title: "This Week")
                                WeeklyStatsCard(stats: weekly, person: person)
                            }
                            
                            // Monthly Stats
                            if let monthly = analyticsStore.monthlyStats {
                                SectionHeader(title: "This Month")
                                MonthlyStatsCard(stats: monthly, person: person)
                            }
                        }
                    }
                    .padding(18)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                if let person = currentPerson {
                    analyticsStore.calculateStats(for: person)
                }
            }
            .refreshable {
                if let person = currentPerson {
                    analyticsStore.calculateStats(for: person)
                }
            }
        }
    }
}

// MARK: - Streak Card

struct StreakCard: View {
    let streaks: StreakData
    let person: Person
    
    var body: some View {
        VStack(spacing: 0) {
            // Top accent bar
            Rectangle()
                .fill(Theme.accent(for: person))
                .frame(height: 4)
            
            HStack(spacing: 24) {
                // Current Streak
                VStack(spacing: 8) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(streaks.currentStreak)")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundStyle(Theme.accent(for: person))
                        Text("days")
                            .font(.system(size: 16))
                            .foregroundStyle(Theme.inkSoft)
                    }
                    Text("Current Streak")
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.ink)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .frame(height: 60)
                
                // Longest Streak
                VStack(spacing: 8) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("\(streaks.longestStreak)")
                            .font(.system(size: 36, weight: .semibold, design: .rounded))
                            .foregroundStyle(Theme.ink)
                        Text("days")
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.inkSoft)
                    }
                    Text("Best Streak")
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.inkSoft)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(20)
        }
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.line, lineWidth: 1)
        )
    }
}

// MARK: - Weekly Stats Card

struct WeeklyStatsCard: View {
    let stats: WeeklyStats
    let person: Person
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Walk Stats
            StatRow(
                icon: "figure.walk",
                title: "Walking",
                value: "\(stats.daysWithWalk)/7",
                subtitle: "\(stats.totalWalkMinutes) min total",
                progress: stats.walkCompletionRate,
                person: person
            )
            
            Divider().background(Theme.line)
            
            // Gym Stats
            StatRow(
                icon: "dumbbell.fill",
                title: "Gym Sessions",
                value: "\(stats.gymWorkoutsCompleted)/\(stats.gymWorkoutsScheduled)",
                subtitle: stats.gymWorkoutsScheduled > 0 ? "Scheduled this week" : "No gym days this week",
                progress: stats.gymCompletionRate,
                person: person
            )
        }
        .padding(16)
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Theme.line, lineWidth: 1)
        )
    }
}

// MARK: - Monthly Stats Card

struct MonthlyStatsCard: View {
    let stats: MonthlyStats
    let person: Person
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Adherence Rate
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 20))
                        .foregroundStyle(Theme.accent(for: person))
                        .frame(width: 28)
                    
                    Text("Adherence Rate")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Theme.ink)
                    
                    Spacer()
                    
                    Text("\(Int(stats.adherenceRate * 100))%")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Theme.accent(for: person))
                }
                
                ProgressBar(value: stats.adherenceRate, color: Theme.accent(for: person))
                
                Text("\(stats.activeDays) active days out of \(stats.totalDays)")
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.inkSoft)
            }
            
            Divider().background(Theme.line)
            
            // Summary Stats Grid
            HStack(spacing: 12) {
                MiniStatCard(
                    icon: "figure.walk",
                    title: "Walk Minutes",
                    value: "\(stats.totalWalkMinutes)",
                    person: person
                )
                
                MiniStatCard(
                    icon: "dumbbell.fill",
                    title: "Gym Sessions",
                    value: "\(stats.totalGymSessions)",
                    person: person
                )
                
                MiniStatCard(
                    icon: "checkmark.circle.fill",
                    title: "Exercises Done",
                    value: "\(stats.totalExercisesCompleted)",
                    person: person
                )
            }
        }
        .padding(16)
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Theme.line, lineWidth: 1)
        )
    }
}

// MARK: - Supporting Views

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.heading(19))
            .foregroundStyle(Theme.ink)
    }
}

struct StatRow: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    let progress: Double
    let person: Person
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(Theme.accent(for: person))
                    .frame(width: 28)
                
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Theme.ink)
                
                Spacer()
                
                Text(value)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Theme.ink)
            }
            
            ProgressBar(value: progress, color: Theme.accent(for: person))
            
            Text(subtitle)
                .font(.system(size: 12))
                .foregroundStyle(Theme.inkSoft)
        }
    }
}

struct ProgressBar: View {
    let value: Double
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(color.opacity(0.2))
                    .frame(height: 6)
                    .clipShape(Capsule())
                
                Rectangle()
                    .fill(color)
                    .frame(width: geometry.size.width * min(max(value, 0), 1), height: 6)
                    .clipShape(Capsule())
            }
        }
        .frame(height: 6)
    }
}

struct MiniStatCard: View {
    let icon: String
    let title: String
    let value: String
    let person: Person
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(Theme.accent(for: person))
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Theme.ink)
            
            Text(title)
                .font(.system(size: 11))
                .foregroundStyle(Theme.inkSoft)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Theme.accentSoft(for: person).opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    ProgressView()
        .environmentObject({
            let store = AnalyticsStore(trackerStore: TrackerStore())
            store.calculateStats(for: .him)
            return store
        }())
        .environmentObject(UserManager())
}
