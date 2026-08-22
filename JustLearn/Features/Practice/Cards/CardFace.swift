//
//  CardFace.swift
//  JustLearn
//

import SwiftUI

struct CardFace: View {
    let word: Word
    let direction: learningDestination
    let isFlipped: Bool
    var swipeProgress: CGFloat = 0

    private var frontText: String {
        direction == .OriginalToTranslate ? word.originalSpelling : word.translation
    }
    private var backText: String {
        direction == .OriginalToTranslate ? word.translation : word.originalSpelling
    }
    private var strokeColor: Color {
        swipeProgress > 0 ? .green : .red
    }

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color(.systemBackground))
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(strokeColor, lineWidth: abs(swipeProgress) * 4)
            }
            .overlay {
                Text(frontText)
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .padding()
                    .opacity(isFlipped ? 0 : 1)
            }
            .overlay {
                Text(backText)
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .padding()
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .opacity(isFlipped ? 1 : 0)
            }
            .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
    }
}
