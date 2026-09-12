import Foundation
import Combine

final class UserManager: ObservableObject {
    @Published private(set) var currentUser: UserProfile?
    @Published private(set) var hasCompletedOnboarding: Bool
    
    private let userDefaultsKey = "TwoTrails.CurrentUser"
    private let onboardingKey = "TwoTrails.HasCompletedOnboarding"
    
    init() {
        // Load saved user preference
        if let savedUserRaw = UserDefaults.standard.string(forKey: userDefaultsKey),
           let savedUser = UserProfile(rawValue: savedUserRaw) {
            self.currentUser = savedUser
        } else {
            self.currentUser = nil
        }
        
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: onboardingKey)
    }
    
    func selectUser(_ user: UserProfile) {
        currentUser = user
        hasCompletedOnboarding = true
        
        // Persist the selection
        UserDefaults.standard.set(user.rawValue, forKey: userDefaultsKey)
        UserDefaults.standard.set(true, forKey: onboardingKey)
    }
    
    func switchUser(to user: UserProfile) {
        selectUser(user)
    }
    
    func clearUser() {
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
}
