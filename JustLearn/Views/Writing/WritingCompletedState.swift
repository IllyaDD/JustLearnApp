//
//  WritingCompletedState.swift
//  JustLearn
//

import SwiftUI

struct WritingCompletedState: View {
    let title: String
    let totalWords: Int
    let onRestart: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "trophy.fill")
                .font(.system(size: 72))
                .foregroundStyle(.yellow.gradient)
                .symbolEffect(.bounce)

            Text(title)
                .font(.title.weight(.bold))
                .multilineTextAlignment(.center)

            Text("Great job! You finished all \(totalWords) words.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Spacer()

            Button {
                onRestart()
            } label: {
                Label("Start again", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.bottom, 24)
        }
    }
}

#Preview {
    WritingCompletedState(title: "Writing practice completed", totalWords: 15, onRestart: {})
        .padding()
}
