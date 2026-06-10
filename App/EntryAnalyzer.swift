import Foundation
import FoundationModels

/// Runs Apple's on-device language model to analyze journal entries.
/// All work happens locally; nothing leaves the device.
@Observable
@MainActor
final class EntryAnalyzer {
  /// Why analysis can't run, if it can't. `nil` means the model is ready.
  enum Unavailable {
    case appleIntelligenceNotEnabled
    case modelNotReady
    case deviceNotEligible

    var notice: String {
      switch self {
      case .appleIntelligenceNotEnabled:
        return "Turn on Apple Intelligence in Settings to get mood and theme insights."
      case .modelNotReady:
        return "The on-device model is still downloading. Insights will appear once it's ready."
      case .deviceNotEligible:
        return "This device can't run on-device insights, but your entries are saved safely."
      }
    }
  }

  private static let instructions = """
  You analyze personal journal entries. Read the entry and infer the writer's mood, \
  the main themes, and any concrete actions they intend to take. Be concise, neutral, \
  and respectful. Never invent facts that aren't supported by the text.
  """

  /// `nil` when the model is available, otherwise the reason it isn't.
  var unavailable: Unavailable? {
    switch SystemLanguageModel.default.availability {
    case .available:
      return nil
    case .unavailable(.appleIntelligenceNotEnabled):
      return .appleIntelligenceNotEnabled
    case .unavailable(.modelNotReady):
      return .modelNotReady
    default:
      return .deviceNotEligible
    }
  }

  var isAvailable: Bool { unavailable == nil }

  private func makeSession() -> LanguageModelSession {
    LanguageModelSession(instructions: Self.instructions)
  }

  /// Analyzes the given text on-device. Throws if the model is unavailable or generation fails.
  func analyze(_ text: String) async throws -> EntryAnalysis {
    let session = makeSession()
    let response = try await session.respond(to: text, generating: EntryAnalysis.self)
    return response.content
  }
}
