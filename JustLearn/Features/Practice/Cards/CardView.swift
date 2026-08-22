//
//  CardView.swift
//  JustLearn
//
//  Created by Illya Donchenko on 23.06.2026.
//

import SwiftUI
import SwiftData

struct CardView: View {
    @Query(sort: \Word.timesStudied) private var words: [Word]
    @Query private var allTags: [Tag]
    @State private var viewModel: PracticeSessionViewModel
    @AppStorage("practiseDirection") private var practiseDirection: learningDestination = .TranslateToOriginal

    init(wordService: WordService) {
        _viewModel = State(initialValue: PracticeSessionViewModel(wordService: wordService))
    }

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.eligibleWords(from: words).isEmpty && viewModel.selectedTagID == nil {
                PracticeEmptyState()
            } else if !viewModel.isSessionActive {
                CardsStartScreen(
                    tags: allTags,
                    allWords: words,
                    selectedTagID: $viewModel.selectedTagID,
                    startTitle: viewModel.startButtonTitle(allWords: words, allTags: allTags),
                    readyCount: viewModel.eligibleWords(from: words).count,
                    onStart: { viewModel.startSession(from: words, limit: 30) }
                )
            } else {
                PracticeProgressHeader(currentIndex: viewModel.currentIndex, total: viewModel.sessionWords.count)
                CardStackView(
                    words: viewModel.sessionWords,
                    currentIndex: viewModel.currentIndex,
                    direction: practiseDirection,
                    onRemembered: { viewModel.markStudied($0) },
                    onForgotten: { viewModel.markForgotten($0) },
                    onAdvance: { viewModel.advance() }
                )
            }
        }
        .padding(.horizontal, 20)
        .background(
            LinearGradient(
                colors: [Color(.systemBackground), Color(.secondarySystemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Word.self, Tag.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    CardView(wordService: WordService(modelContext: container.mainContext))
        .modelContainer(container)
}
