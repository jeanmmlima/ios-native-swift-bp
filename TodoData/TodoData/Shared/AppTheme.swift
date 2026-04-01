import SwiftUI

enum AppTheme {
    static let accent = Color.purple
    static let cardBackground = Color(.secondarySystemBackground)

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
