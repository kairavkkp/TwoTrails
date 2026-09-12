import SwiftUI

struct UserSelectionView: View {
    @EnvironmentObject var userManager: UserManager
    let isOnboarding: Bool
    
    @State private var selectedUser: UserProfile? = nil
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.paper.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Text(isOnboarding ? "Welcome to" : "Switch User")
                            .font(.system(size: 17))
                            .foregroundStyle(Theme.inkSoft)
                        
                        Text("Two Trails")
                            .font(.heading(42))
                            .foregroundStyle(Theme.ink)
                        
                        if isOnboarding {
                            Text("Who's using the app?")
                                .font(.system(size: 15))
                                .foregroundStyle(Theme.inkSoft)
                                .padding(.top, 8)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    VStack(spacing: 12) {
                        ForEach(UserProfile.allCases) { profile in
                            UserSelectionCard(
                                profile: profile,
                                isSelected: selectedUser == profile
                            ) {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedUser = profile
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    if let selected = selectedUser {
                        Button {
                            userManager.selectUser(selected)
                            if !isOnboarding {
                                dismiss()
                            }
                        } label: {
                            Text("Continue as \(selected.displayName)")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Theme.accent(for: selected.person))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .toolbar {
                if !isOnboarding {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundStyle(Theme.ink)
                    }
                }
            }
        }
    }
}

struct UserSelectionCard: View {
    let profile: UserProfile
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Theme.accentSoft(for: profile.person))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: profile == .him ? "figure.walk" : "figure.walk")
                        .font(.system(size: 24))
                        .foregroundStyle(Theme.accent(for: profile.person))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(profile.displayName)
                        .font(.system(size: 19, weight: .medium))
                        .foregroundStyle(Theme.ink)
                    
                    Text("View your personal tracker")
                        .font(.system(size: 14))
                        .foregroundStyle(Theme.inkSoft)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Theme.accent(for: profile.person))
                }
            }
            .padding(20)
            .background(Theme.card)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? Theme.accent(for: profile.person) : Theme.line,
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

#Preview("Onboarding") {
    UserSelectionView(isOnboarding: true)
        .environmentObject(UserManager())
}

#Preview("Switch User") {
    UserSelectionView(isOnboarding: false)
        .environmentObject(UserManager())
}
