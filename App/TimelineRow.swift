import SwiftUI

/// A single entry row in the timeline.
struct TimelineRow: View {
  var entry: JournalEntry

  private var firstLine: String {
    entry.text
      .split(whereSeparator: \.isNewline)
      .first
      .map(String.init)?
      .trimmingCharacters(in: .whitespaces) ?? ""
  }

  var body: some View {
    HStack(spacing: 12) {
      Capsule()
        .fill(MoodStyle.color(for: entry.moodScore))
        .frame(width: 6)

      VStack(alignment: .leading, spacing: 6) {
        HStack(alignment: .firstTextBaseline) {
          Text(entry.date, format: .dateTime.weekday(.abbreviated).day())
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.secondary)
          Spacer()
          moodBadge
        }

        Text(firstLine.isEmpty ? "No text" : firstLine)
          .font(.body)
          .foregroundStyle(firstLine.isEmpty ? .secondary : .primary)
          .lineLimit(1)

        if !entry.themes.isEmpty {
          HStack(spacing: 6) {
            ForEach(entry.themes.prefix(3), id: \.self) { theme in
              ThemeChip(text: theme)
            }
          }
        }
      }
    }
    .padding(.vertical, 4)
  }

  @ViewBuilder
  private var moodBadge: some View {
    if let emoji = MoodStyle.emoji(for: entry.moodScore), let score = entry.moodScore {
      Text("\(emoji) \(score)")
        .font(.subheadline)
        .monospacedDigit()
    } else {
      ProgressView()
        .controlSize(.mini)
    }
  }
}
