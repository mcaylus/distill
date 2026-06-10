import SwiftUI
import SwiftData

/// Screen 3 — the Reveal. Runs on-device analysis (if needed), reveals the
/// results card with a spring, and shows the writer's full entry below.
struct EntryDetailView: View {
  @Bindable var entry: JournalEntry
  var analyzer: EntryAnalyzer

  @Environment(\.modelContext) private var context
  @State private var isAnalyzing = false
  @State private var failed = false

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 24) {
        analysisSection
        wordsSection
      }
      .padding(20)
    }
    .navigationTitle(entry.date.formatted(.dateTime.weekday(.abbreviated).month().day()))
    .navigationBarTitleDisplayMode(.inline)
    .task { await analyzeIfNeeded() }
  }

  // MARK: - Analysis

  @ViewBuilder
  private var analysisSection: some View {
    if entry.isAnalyzed {
      AnalysisCard(entry: entry, onToggleAction: toggle)
        .transition(.asymmetric(
          insertion: .scale(scale: 0.92).combined(with: .opacity),
          removal: .opacity
        ))
    } else if isAnalyzing {
      analyzingStrip
    } else if let unavailable = analyzer.unavailable {
      infoStrip(unavailable.notice)
    } else if failed {
      Button {
        Task { await analyze() }
      } label: {
        infoStrip("Couldn't read this entry. Tap to try again.")
      }
      .buttonStyle(.plain)
    }
  }

  private var analyzingStrip: some View {
    HStack(spacing: 10) {
      ProgressView().controlSize(.small)
      Text("Reading your entry…")
        .foregroundStyle(.secondary)
      Spacer()
      Text("on-device")
        .font(.caption)
        .foregroundStyle(.tertiary)
    }
    .padding(16)
    .frame(maxWidth: .infinity)
    .background(
      RoundedRectangle(cornerRadius: 14, style: .continuous)
        .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [6]))
        .foregroundStyle(.quaternary)
    )
    .transition(.opacity)
  }

  private func infoStrip(_ text: String) -> some View {
    Label(text, systemImage: "sparkles")
      .font(.footnote)
      .foregroundStyle(.secondary)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(16)
      .background(
        RoundedRectangle(cornerRadius: 14, style: .continuous)
          .fill(Color(.secondarySystemGroupedBackground))
      )
  }

  // MARK: - Entry text

  private var wordsSection: some View {
    VStack(alignment: .leading, spacing: 14) {
      labeledDivider("your words")
      Text(entry.text)
        .font(.body)
        .frame(maxWidth: .infinity, alignment: .leading)
        .textSelection(.enabled)
    }
  }

  private func labeledDivider(_ text: String) -> some View {
    HStack(spacing: 12) {
      rule
      Text(text)
        .font(.caption)
        .foregroundStyle(.secondary)
      rule
    }
  }

  private var rule: some View {
    Rectangle()
      .fill(Color(.separator))
      .frame(height: 1)
  }

  // MARK: - Actions

  private func analyzeIfNeeded() async {
    guard !entry.isAnalyzed, analyzer.isAvailable else { return }
    await analyze()
  }

  private func analyze() async {
    guard !isAnalyzing else { return }
    withAnimation { failed = false }
    isAnalyzing = true
    do {
      let analysis = try await analyzer.analyze(entry.text)
      withAnimation(.bouncy(duration: 0.5)) {
        entry.moodScore = analysis.moodScore
        entry.moodLabel = analysis.moodLabel
        entry.themes = analysis.themes
        entry.actionItems = analysis.actionItems
        isAnalyzing = false
      }
      try? context.save()
    } catch {
      withAnimation {
        isAnalyzing = false
        failed = true
      }
    }
  }

  private func toggle(_ action: String) {
    entry.toggleCompletion(of: action)
    try? context.save()
  }
}
