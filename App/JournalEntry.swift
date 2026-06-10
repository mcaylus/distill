import Foundation
import SwiftData

@Model
final class JournalEntry {
  var text: String
  var date: Date
  var moodScore: Int?
  var moodLabel: String?
  var themes: [String]
  var actionItems: [String]
  var completedActions: [String]

  init(
    text: String,
    date: Date = .now,
    moodScore: Int? = nil,
    moodLabel: String? = nil,
    themes: [String] = [],
    actionItems: [String] = [],
    completedActions: [String] = []
  ) {
    self.text = text
    self.date = date
    self.moodScore = moodScore
    self.moodLabel = moodLabel
    self.themes = themes
    self.actionItems = actionItems
    self.completedActions = completedActions
  }

  /// Whether on-device analysis has populated this entry.
  var isAnalyzed: Bool {
    moodScore != nil || moodLabel != nil || !themes.isEmpty
  }

  func isCompleted(_ action: String) -> Bool {
    completedActions.contains(action)
  }

  func toggleCompletion(of action: String) {
    if let index = completedActions.firstIndex(of: action) {
      completedActions.remove(at: index)
    } else {
      completedActions.append(action)
    }
  }
}
