import Foundation

extension JournalEntry {
  /// Three pre-analyzed entries seeded on first launch so the timeline is never empty.
  static func makeSamples() -> [JournalEntry] {
    let day: TimeInterval = 86_400
    return [
      JournalEntry(
        text: "Went for a long run before work and it cleared my head completely. I want to make this a habit. Also told myself I'd finally call mom this week.",
        date: .now.addingTimeInterval(-day * 0.2),
        moodScore: 8,
        moodLabel: "calm and energized",
        themes: ["exercise", "morning", "focus"],
        actionItems: ["Make morning runs a habit", "Call mom this week"]
      ),
      JournalEntry(
        text: "Today was a lot. Back-to-back meetings and I never caught up. Felt stretched thin but I'm managing. Going to block out tomorrow morning to plan.",
        date: .now.addingTimeInterval(-day * 1.3),
        moodScore: 4,
        moodLabel: "stressed but coping",
        themes: ["work", "stress"],
        actionItems: ["Block tomorrow morning to plan"]
      ),
      JournalEntry(
        text: "Quiet evening with tea and a good book. Nowhere to be, nothing to prove. I forget how much I need nights like this.",
        date: .now.addingTimeInterval(-day * 3.1),
        moodScore: 7,
        moodLabel: "content and rested",
        themes: ["rest", "reading"],
        actionItems: []
      ),
    ]
  }
}
