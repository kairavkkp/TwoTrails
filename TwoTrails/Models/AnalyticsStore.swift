import Foundation
import Combine

/// Analytics and progress tracking
final class AnalyticsStore: ObservableObject {
    @Published private(set) var weeklyStats: WeeklyStats?
    @Published private(set) var monthlyStats: MonthlyStats?
    @Published private(set) var streaks: StreakData?
    
    private let trackerStore: TrackerStore
    
    init(trackerStore: TrackerStore) {
        self.trackerStore = trackerStore
    }
    
    // MARK: - Public Methods
    
    func calculateStats(for person: Person) {
        weeklyStats = calculateWeeklyStats(for: person)
        monthlyStats = calculateMonthlyStats(for: person)
        streaks = calculateStreaks(for: person)
    }
    
    // MARK: - Weekly Stats
    
    private func calculateWeeklyStats(for person: Person) -> WeeklyStats {
        let calendar = Calendar.current
        let today = Date()
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        
        var daysWithWalk = 0
        var daysWithGym = 0
        var totalWalkMinutes = 0
        var gymWorkoutsCompleted = 0
        var gymWorkoutsScheduled = 0
        
        for dayOffset in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: weekStart) else { continue }
            guard date <= today else { continue } // Don't count future days
            
            let log = trackerStore.log(for: date, person: person)
            let dayKind = Plan.dayKind(for: date)
            
            // Walk stats
            if log.walked {
                daysWithWalk += 1
                totalWalkMinutes += log.walkMinutes
            }
            
            // Gym stats
            if case .gym(let variant) = dayKind {
                gymWorkoutsScheduled += 1
                let exercises = Plan.variants(for: person)[variant]?.exercises ?? []
                if log.allCompleted(for: exercises) {
                    gymWorkoutsCompleted += 1
                    daysWithGym += 1
                }
            }
        }
        
        return WeeklyStats(
            daysWithWalk: daysWithWalk,
            daysWithGym: daysWithGym,
            totalWalkMinutes: totalWalkMinutes,
            gymWorkoutsCompleted: gymWorkoutsCompleted,
            gymWorkoutsScheduled: gymWorkoutsScheduled
        )
    }
    
    // MARK: - Monthly Stats
    
    private func calculateMonthlyStats(for person: Person) -> MonthlyStats {
        let calendar = Calendar.current
        let today = Date()
        let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
        
        var totalDays = 0
        var activeDays = 0
        var totalWalkMinutes = 0
        var totalGymSessions = 0
        var totalExercisesCompleted = 0
        
        var currentDate = monthStart
        while currentDate <= today {
            let log = trackerStore.log(for: currentDate, person: person)
            let dayKind = Plan.dayKind(for: currentDate)
            
            totalDays += 1
            
            var dayWasActive = false
            
            // Check walk
            if log.walked {
                dayWasActive = true
                totalWalkMinutes += log.walkMinutes
            }
            
            // Check gym
            if case .gym(let variant) = dayKind {
                let exercises = Plan.variants(for: person)[variant]?.exercises ?? []
                let completed = log.completedCount(for: exercises)
                if completed > 0 {
                    dayWasActive = true
                }
                if log.allCompleted(for: exercises) {
                    totalGymSessions += 1
                }
                totalExercisesCompleted += completed
            }
            
            if dayWasActive {
                activeDays += 1
            }
            
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDate
        }
        
        let adherenceRate = totalDays > 0 ? Double(activeDays) / Double(totalDays) : 0.0
        
        return MonthlyStats(
            activeDays: activeDays,
            totalDays: totalDays,
            adherenceRate: adherenceRate,
            totalWalkMinutes: totalWalkMinutes,
            totalGymSessions: totalGymSessions,
            totalExercisesCompleted: totalExercisesCompleted
        )
    }
    
    // MARK: - Streaks
    
    private func calculateStreaks(for person: Person) -> StreakData {
        let calendar = Calendar.current
        let today = Date()
        
        var currentStreak = 0
        var longestStreak = 0
        var tempStreak = 0
        var lastActiveDate: Date?
        
        // Check last 90 days
        for dayOffset in 0..<90 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) else { continue }
            
            let log = trackerStore.log(for: date, person: person)
            let dayKind = Plan.dayKind(for: date)
            
            var dayWasActive = false
            
            // Consider it active if they did walk OR gym
            if log.walked {
                dayWasActive = true
            }
            
            if case .gym(let variant) = dayKind {
                let exercises = Plan.variants(for: person)[variant]?.exercises ?? []
                if log.completedCount(for: exercises) > 0 {
                    dayWasActive = true
                }
            }
            
            if dayWasActive {
                tempStreak += 1
                if dayOffset == 0 || (lastActiveDate != nil && calendar.isDate(date, equalTo: calendar.date(byAdding: .day, value: 1, to: lastActiveDate!)!, toGranularity: .day)) {
                    if dayOffset < currentStreak + 1 {
                        currentStreak = tempStreak
                    }
                }
                longestStreak = max(longestStreak, tempStreak)
                lastActiveDate = date
            } else {
                tempStreak = 0
            }
        }
        
        // Simplified current streak calculation
        var checkedCurrentStreak = 0
        var checkDate = today
        for _ in 0..<90 {
            let log = trackerStore.log(for: checkDate, person: person)
            let dayKind = Plan.dayKind(for: checkDate)
            
            var dayWasActive = false
            if log.walked {
                dayWasActive = true
            }
            if case .gym(let variant) = dayKind {
                let exercises = Plan.variants(for: person)[variant]?.exercises ?? []
                if log.completedCount(for: exercises) > 0 {
                    dayWasActive = true
                }
            }
            
            if dayWasActive {
                checkedCurrentStreak += 1
            } else {
                break
            }
            
            guard let prevDate = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
            checkDate = prevDate
        }
        
        return StreakData(
            currentStreak: checkedCurrentStreak,
            longestStreak: longestStreak
        )
    }
    
    // MARK: - Export for Cloud Sync (Future Use)
    
    func exportAnalytics(for person: Person) -> AnalyticsExport {
        return AnalyticsExport(
            person: person,
            weekly: weeklyStats,
            monthly: monthlyStats,
            streaks: streaks,
            exportDate: Date()
        )
    }
}

// MARK: - Data Models

struct WeeklyStats: Codable {
    let daysWithWalk: Int
    let daysWithGym: Int
    let totalWalkMinutes: Int
    let gymWorkoutsCompleted: Int
    let gymWorkoutsScheduled: Int
    
    var walkCompletionRate: Double {
        // Expect walks most days (5-7 per week)
        Double(daysWithWalk) / 7.0
    }
    
    var gymCompletionRate: Double {
        guard gymWorkoutsScheduled > 0 else { return 0 }
        return Double(gymWorkoutsCompleted) / Double(gymWorkoutsScheduled)
    }
}

struct MonthlyStats: Codable {
    let activeDays: Int
    let totalDays: Int
    let adherenceRate: Double
    let totalWalkMinutes: Int
    let totalGymSessions: Int
    let totalExercisesCompleted: Int
    
    var averageWalkMinutesPerDay: Double {
        guard totalDays > 0 else { return 0 }
        return Double(totalWalkMinutes) / Double(totalDays)
    }
}

struct StreakData: Codable {
    let currentStreak: Int
    let longestStreak: Int
}

// For future cloud sync
struct AnalyticsExport: Codable {
    let person: Person
    let weekly: WeeklyStats?
    let monthly: MonthlyStats?
    let streaks: StreakData?
    let exportDate: Date
    
    // Add user ID when implementing cloud sync
    // var userID: String?
    // var syncToken: String?
}
