import SwiftUI
import SwiftData

struct ContentView: View {
  @Environment(\.modelContext) private var context
  @Query(sort: \JournalEntry.date, order: .reverse) private var entries: [JournalEntry]

  @State private var analyzer = EntryAnalyzer()
  @State private var path: [JournalEntry] = []
  @State private var showingComposer = false

  private static let didSeedKey = "didSeedSamples"

  var body: some View {
    NavigationStack(path: $path) {
      ZStack(alignment: .bottomTrailing) {
        List {
          ForEach(entries) { entry in
            NavigationLink(value: entry) {
              TimelineRow(entry: entry)
            }
          }
          .onDelete(perform: delete)
        }
        .listStyle(.plain)
        .contentMargins(.bottom, 88, for: .scrollContent)

        composeButton
      }
      .navigationTitle("Distill")
      .navigationDestination(for: JournalEntry.self) { entry in
        EntryDetailView(entry: entry, analyzer: analyzer)
      }
      .safeAreaInset(edge: .top) {
        if let unavailable = analyzer.unavailable {
          notice(unavailable.notice)
        }
      }
      .sheet(isPresented: $showingComposer) {
        ComposerView(onSave: save)
      }
    }
    .task { seedIfNeeded() }
  }

  private var composeButton: some View {
    Button {
      showingComposer = true
    } label: {
      Image(systemName: "plus")
        .font(.title2.weight(.semibold))
        .foregroundStyle(.white)
        .frame(width: 56, height: 56)
        .background(.tint, in: Circle())
        .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
    }
    .padding(20)
    .accessibilityLabel("New entry")
  }

  private func notice(_ message: String) -> some View {
    Label(message, systemImage: "sparkles")
      .font(.footnote)
      .foregroundStyle(.secondary)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 16)
      .padding(.vertical, 10)
      .background(.bar)
  }

  // MARK: - Actions

  private func save(_ text: String) {
    let entry = JournalEntry(text: text)
    context.insert(entry)
    try? context.save()
    showingComposer = false
    // Navigate straight to the Reveal screen, which runs analysis on appear.
    path.append(entry)
  }

  private func delete(_ offsets: IndexSet) {
    for index in offsets {
      context.delete(entries[index])
    }
    try? context.save()
  }

  private func seedIfNeeded() {
    let defaults = UserDefaults.standard
    guard !defaults.bool(forKey: Self.didSeedKey) else { return }
    defaults.set(true, forKey: Self.didSeedKey)
    guard entries.isEmpty else { return }
    for sample in JournalEntry.makeSamples() {
      context.insert(sample)
    }
    try? context.save()
  }
}
