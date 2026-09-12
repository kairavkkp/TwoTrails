import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb & 0xFF0000) >> 16) / 255
        let g = Double((rgb & 0x00FF00) >> 8) / 255
        let b = Double(rgb & 0x0000FF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

enum Theme {
    static let paper = Color(hex: "EDEAE1")
    static let card = Color(hex: "F8F6F0")
    static let ink = Color(hex: "2A2820")
    static let inkSoft = Color(hex: "6B685D")
    static let line = Color(hex: "D8D3C5")

    static let him = Color(hex: "35566B")
    static let himSoft = Color(hex: "DCE6EA")
    static let her = Color(hex: "7C4468")
    static let herSoft = Color(hex: "EFDEE8")

    static func accent(for person: Person) -> Color {
        person == .him ? him : her
    }
    static func accentSoft(for person: Person) -> Color {
        person == .him ? himSoft : herSoft
    }
}

extension Font {
    static func heading(_ size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .serif)
    }
}
