//
//  WritingAnswerField.swift
//  JustLearn
//

import SwiftUI

struct WritingAnswerField: View {
    @Binding var text: String
    @FocusState.Binding var isFocused: Bool
    let answerState: Constans.AnswerState
    let onSubmit: () -> Void

    var body: some View {
        TextField("Введіть слово", text: $text)
            .font(.title3)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(.tertiarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(borderColor, lineWidth: 2)
            )
            .focused($isFocused)
            .disabled(answerState == .wrong)
            .submitLabel(.done)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .onSubmit(onSubmit)
            .animation(.easeInOut(duration: 0.2), value: isFocused)
            .animation(.easeInOut(duration: 0.2), value: answerState)
    }

    private var borderColor: Color {
        switch answerState {
        case .correct: return .green
        case .wrong:   return .red
        case .idle:    return isFocused ? .blue : Color(.separator)
        }
    }
}
