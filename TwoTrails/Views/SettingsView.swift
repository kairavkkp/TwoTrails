import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var store: TrackerStore
    @EnvironmentObject var planStore: PlanStore
    @EnvironmentObject var scheduleStore: ScheduleStore
    @Binding var showingUserSwitcher: Bool
    
    @State private var showingResetAlert = false
    @State private var resetConfirmationText = ""
    
    private var currentUser: UserProfile? {
        userManager.currentUser
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.paper.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Current User Section
                        if let user = currentUser {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Current User")
                                    .font(.system(size: 13))
                                    .foregroundStyle(Theme.inkSoft)
                                    .textCase(.uppercase)
                                    .padding(.horizontal, 18)
                                
                                VStack(spacing: 0) {
                                    HStack(spacing: 16) {
                                        ZStack {
                                            Circle()
                                                .fill(Theme.accentSoft(for: user.person))
                                                .frame(width: 48, height: 48)
                                            
                                            Image(systemName: "figure.walk")
                                                .font(.system(size: 22))
                                                .foregroundStyle(Theme.accent(for: user.person))
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(user.displayName)
                                                .font(.system(size: 17, weight: .medium))
                                                .foregroundStyle(Theme.ink)
                                            
                                            Text("Logged in")
                                                .font(.system(size: 14))
                                                .foregroundStyle(Theme.inkSoft)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(16)
                                }
                                .background(Theme.card)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Theme.line, lineWidth: 1)
                                )
                                .padding(.horizontal, 18)
                            }
                        }
                        
                        // User Management Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("User Management")
                                .font(.system(size: 13))
                                .foregroundStyle(Theme.inkSoft)
                                .textCase(.uppercase)
                                .padding(.horizontal, 18)
                            
                            VStack(spacing: 0) {
                                SettingsRow(
                                    icon: "arrow.left.arrow.right",
                                    title: "Switch User",
                                    subtitle: "Change to a different user profile"
                                ) {
                                    showingUserSwitcher = true
                                }
                            }
                            .background(Theme.card)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Theme.line, lineWidth: 1)
                            )
                            .padding(.horizontal, 18)
                        }
                        
                        // Data Management Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Data Management")
                                .font(.system(size: 13))
                                .foregroundStyle(Theme.inkSoft)
                                .textCase(.uppercase)
                                .padding(.horizontal, 18)
                            
                            VStack(spacing: 0) {
                                SettingsRowDestructive(
                                    icon: "trash.fill",
                                    title: "Reset All Data",
                                    subtitle: "Delete all workouts, plans, and settings"
                                ) {
                                    showingResetAlert = true
                                }
                            }
                            .background(Theme.card)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Theme.line, lineWidth: 1)
                            )
                            .padding(.horizontal, 18)
                        }
                        
                        // App Info
                        VStack(alignment: .leading, spacing: 12) {
                            Text("About")
                                .font(.system(size: 13))
                                .foregroundStyle(Theme.inkSoft)
                                .textCase(.uppercase)
                                .padding(.horizontal, 18)
                            
                            VStack(spacing: 0) {
                                HStack {
                                    Text("Version")
                                        .font(.system(size: 15))
                                        .foregroundStyle(Theme.ink)
                                    Spacer()
                                    Text("1.0")
                                        .font(.system(size: 15))
                                        .foregroundStyle(Theme.inkSoft)
                                }
                                .padding(16)
                            }
                            .background(Theme.card)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Theme.line, lineWidth: 1)
                            )
                            .padding(.horizontal, 18)
                        }
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.vertical, 18)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .alert("Reset All Data?", isPresented: $showingResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset Everything", role: .destructive) {
                    resetAllData()
                }
            } message: {
                Text("This will permanently delete ALL data for both users including:\n\n• All workout logs\n• Custom workout plans\n• Weekly schedules\n• Progress history\n• User preferences\n\nThis action cannot be undone. The app will restart from the beginning.")
            }
        }
    }
    
    private func resetAllData() {
        // Clear all UserDefaults
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        // Force clear specific keys as backup
        UserDefaults.standard.removeObject(forKey: "TwoTrails.CurrentUser")
        UserDefaults.standard.removeObject(forKey: "TwoTrails.HasCompletedOnboarding")
        UserDefaults.standard.removeObject(forKey: "TwoTrails.CustomPlans")
        UserDefaults.standard.removeObject(forKey: "TwoTrails.WeeklySchedules")
        
        // Clear user manager (will trigger app restart to onboarding)
        userManager.clearUser()
        
        // Note: TrackerStore data will be cleared automatically when app restarts
        // since UserDefaults has been wiped
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Theme.ink.opacity(0.08))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundStyle(Theme.ink)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15))
                        .foregroundStyle(Theme.ink)
                    
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.inkSoft)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Theme.inkSoft)
            }
            .padding(16)
        }
        .buttonStyle(.plain)
    }
}

struct SettingsRowDestructive: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.red.opacity(0.08))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundStyle(.red)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15))
                        .foregroundStyle(.red)
                    
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.inkSoft)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Theme.inkSoft)
            }
            .padding(16)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SettingsView(showingUserSwitcher: .constant(false))
        .environmentObject(UserManager())
        .environmentObject(TrackerStore())
        .environmentObject(PlanStore())
        .environmentObject(ScheduleStore())
}
