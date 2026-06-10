import SwiftUI

/// Full-height entry composer presented as a sheet.
struct ComposerView: View {
  /// Called with the trimmed text when the writer taps Save.
  var onSave: (String) -> Void

  @Environment(\.dismiss) private var dismiss
  @State private var text = ""
  @FocusState private var focused: Bool

  private var trimmed: String {
    text.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  var body: some View {
    NavigationStack {
      TextEditor(text: $text)
        .font(.body)
        .lineSpacing(3)
        .focused($focused)
        .scrollContentBackground(.hidden)
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .overlay(alignment: .topLeading) {
          if text.isEmpty {
            Text("What's on your mind?")
              .font(.body)
              .foregroundStyle(.secondary)
              .padding(.horizontal, 21)
              .padding(.top, 16)
              .allowsHitTesting(false)
          }
        }
        .navigationTitle(Date.now.formatted(date: .abbreviated, time: .omitted))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") { dismiss() }
          }
          ToolbarItem(placement: .confirmationAction) {
            Button("Save") { onSave(trimmed) }
              .disabled(trimmed.isEmpty)
          }
        }
        .task { focused = true }
    }
  }
}
