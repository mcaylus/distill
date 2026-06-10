import SwiftUI
import SwiftData

/// Placeholder detail screen. The full Screen 3 lands in a later step;
/// this shows the entry and its analysis so navigation from the timeline
/// and the composer works end to end.
struct EntryDetailView: View {
  @Bindable var entry: JournalEntry
  var analyzer: EntryAnalyzer

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        header

        Text(entry.text)
          .font(.body)
          .frame(maxWidth: .infinity, alignment: .leading)

        if !entry.themes.isEmpty {
          HStack(spacing: 6) {
            ForEach(entry.themes, id: \.self) { ThemeChip(text: $0) }
          }
        }

        if !entry.actionItems.isEmpty {
          VStack(alignment: .leading, spacing: 8) {
            Text("Action Items")
              .font(.headline)
            ForEach(entry.actionItems, id: \.self) { item in
              Label(item, systemImage: "circle")
                .font(.subheadline)
            }
          }
        }
      }
      .padding(20)
    }
    .navigationTitle(entry.date.formatted(date: .abbreviated, time: .omitted))
    .navigationBarTitleDisplayMode(.inline)
  }

  private var header: some View {
    HStack(spacing: 10) {
      Capsule()
        .fill(MoodStyle.color(for: entry.moodScore))
        .frame(width: 6, height: 34)
      VStack(alignment: .leading, spacing: 2) {
        if let label = entry.moodLabel, let score = entry.moodScore {
          Text("\(MoodStyle.emoji(for: score) ?? "") \(label)")
            .font(.headline)
          Text("Mood \(score) / 10")
            .font(.caption)
            .foregroundStyle(.secondary)
        } else {
          Text("Not analyzed yet")
            .font(.headline)
            .foregroundStyle(.secondary)
        }
      }
      Spacer()
    }
  }
}
