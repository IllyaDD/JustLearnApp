//
//  WritingTranslationCard.swift
//  JustLearn
//

import SwiftUI

struct WritingTranslationCard: View {
    let word: Word
    let direction: learningDestination

    private var promptText: String {
        direction == .OriginalToTranslate ? word.originalSpelling : word.translation
    }

    var body: some View {
        VStack(spacing: 12) {
            Text("Translate the word")
                .font(.caption)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .tracking(1.5)

            Text(promptText)
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .lineLimit(2)
                .id(word.id)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .move(edge: .trailing)),
                    removal: .opacity.combined(with: .move(edge: .leading))
                ))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.tertiarySystemBackground))
                .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
        )
    }
}
