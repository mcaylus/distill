import FoundationModels

/// Structured, on-device analysis of a single journal entry.
@Generable
struct EntryAnalysis {
  @Guide(description: "Overall emotional tone of the entry, from 1 (very low) to 10 (very positive).")
  var moodScore: Int

  @Guide(description: "A short 2–4 word label describing the writer's mood, e.g. 'calm and hopeful'.")
  var moodLabel: String

  @Guide(description: "Short, lowercase, single-or-two-word tags for the main themes of the entry.", .maximumCount(4))
  var themes: [String]

  @Guide(description: "Concrete things the writer said they intend to do. Use the writer's own intent. Empty if none.")
  var actionItems: [String]
}
