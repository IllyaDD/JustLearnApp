//
//  CardsStartScreen.swift
//  JustLearn
//

import SwiftUI

struct CardsStartScreen: View {
    let tags: [Tag]
    let allWords: [Word]
    @Binding var selectedTagID: UUID?
    let startTitle: String
    let readyCount: Int
    let onStart: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 6) {
                Image(systemName: "rectangle.on.rectangle.angled")
                    .font(.system(size: 44))
                    .foregroundStyle(.blue.gradient)
                Text("Cards practice")
                    .font(.title2.weight(.semibold))
            }
            .padding(.top, 16)

            if !tags.isEmpty {
                TagQuestGrid(
                    tags: tags,
                    allWords: allWords,
                    selectedTagID: $selectedTagID
                )
            } else {
                Spacer()
                Text("\(readyCount) words ready to practice")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
            }

            Button {
                onStart()
            } label: {
                Label(startTitle, systemImage: "play.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(readyCount == 0)
            .padding(.bottom, 24)
        }
    }
}
