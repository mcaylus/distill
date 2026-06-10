import SwiftUI

/// The analysis card shown at the top of the Reveal screen: mood, themes,
/// and tappable action items backed by the entry's `completedActions`.
struct AnalysisCard: View {
  @Bindable var entry: JournalEntry
  /// Called when the writer taps an action item's checkbox.
  var onToggleAction: (String) -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 18) {
      if let score = entry.moodScore {
        moodSection(score: score)
      }
      if !entry.themes.isEmpty {
        themesSection
      }
      if !entry.actionItems.isEmpty {
        actionsSection
      }
    }
    .padding(18)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(
      RoundedRectangle(cornerRadius: 20, style: .continuous)
        .fill(Color(.secondarySystemGroupedBackground))
        .shadow(color: .black.opacity(0.06), radius: 12, y: 4)
    )
  }

  private func header(_ text: String) -> some View {
    Text(text)
      .font(.caption.weight(.semibold))
      .textCase(.uppercase)
      .tracking(0.6)
      .foregroundStyle(.secondary)
  }

  private func moodSection(score: Int) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      header("Mood")
      HStack(spacing: 6) {
        Text(MoodStyle.emoji(for: score) ?? "")
        Text("\(score)/10").fontWeight(.semibold)
        if let label = entry.moodLabel {
          Text("— \(label)")
        }
      }
      .font(.body)
      .padding(.horizontal, 12)
      .padding(.vertical, 8)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(
        RoundedRectangle(cornerRadius: 12, style: .continuous)
          .fill(MoodStyle.color(for: score).opacity(0.18))
      )
    }
  }

  private var themesSection: some View {
    VStack(alignment: .leading, spacing: 8) {
      header("Themes")
      FlowLayout(spacing: 8) {
        ForEach(entry.themes, id: \.self) { theme in
          Text(theme)
            .font(.subheadline)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Capsule().fill(.tint.opacity(0.15)))
            .overlay(Capsule().stroke(.tint.opacity(0.35), lineWidth: 1))
        }
      }
    }
  }

  private var actionsSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      header("Action Items")
      ForEach(entry.actionItems, id: \.self) { item in
        Button {
          onToggleAction(item)
        } label: {
          HStack(spacing: 10) {
            Image(systemName: entry.isCompleted(item) ? "checkmark.square.fill" : "square")
              .font(.title3)
              .foregroundStyle(entry.isCompleted(item) ? AnyShapeStyle(.tint) : AnyShapeStyle(.secondary))
            Text(item)
              .strikethrough(entry.isCompleted(item))
              .foregroundStyle(entry.isCompleted(item) ? .secondary : .primary)
            Spacer(minLength: 0)
          }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(entry.isCompleted(item) ? [.isButton, .isSelected] : .isButton)
      }
    }
  }
}
