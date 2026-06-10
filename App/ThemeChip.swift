import SwiftUI

/// A small capsule-outlined tag used to display an entry's themes.
struct ThemeChip: View {
  var text: String

  var body: some View {
    Text(text)
      .font(.caption2)
      .foregroundStyle(.secondary)
      .padding(.horizontal, 8)
      .padding(.vertical, 3)
      .overlay(
        Capsule()
          .stroke(Color(.systemGray4), lineWidth: 1)
      )
  }
}
