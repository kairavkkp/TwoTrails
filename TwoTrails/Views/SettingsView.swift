import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userManager: UserManager
    @Binding var showingUserSwitcher: Bool
    
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
        }
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

#Preview {
    SettingsView(showingUserSwitcher: .constant(false))
        .environmentObject(UserManager())
}
