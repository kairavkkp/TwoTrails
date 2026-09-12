import Foundation

enum UserProfile: String, Codable, CaseIterable, Identifiable {
    case him
    case her
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .him: return "Him"
        case .her: return "Her"
        }
    }
    
    var person: Person {
        switch self {
        case .him: return .him
        case .her: return .her
        }
    }
    
    var welcomeMessage: String {
        switch self {
        case .him: return "Welcome back!"
        case .her: return "Welcome back!"
        }
    }
}
