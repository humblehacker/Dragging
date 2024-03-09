import SwiftUI

public extension Color {
    static let basic: [Color] = [.red, .orange, .yellow, .green, .mint, .teal, .cyan, .blue, .indigo, .purple, .pink, .brown]

    static func random() -> Color {
        basic.randomElement()!
    }
}
