import SwiftUI

/// Maps a 1–10 mood score (or `nil` when unanalyzed) to color and emoji.
enum MoodStyle {
  static func color(for score: Int?) -> Color {
    guard let score else { return Color(.systemGray3) }
    switch score {
    case ...3: return Color(red: 0.83, green: 0.33, blue: 0.33)
    case 4...6: return Color(red: 0.90, green: 0.69, blue: 0.24)
    default: return Color(red: 0.34, green: 0.64, blue: 0.42)
    }
  }

  static func emoji(for score: Int?) -> String? {
    guard let score else { return nil }
    switch score {
    case ...3: return "🙁"
    case 4...6: return "😐"
    default: return "🙂"
    }
  }
}
