//
//  WritingView.swift
//  JustLearn
//
//  Created by Illya Donchenko on 16.06.2026.
//

import SwiftUI
import SwiftData

struct WritingView: View {
    @FocusState private var isFocused: Bool
    @State private var text: String = ""
    @State private var answerState: Constans.AnswerState = .idle
    @State private var viewModel: PracticeSessionViewModel
    @AppStorage("practiseDirection") private var practiseDirection: learningDestination = .TranslateToOriginal

    @Query(sort: \Word.timesStudied) private var allMatching: [Word]
    @Query private var allTags: [Tag]

    init(wordService: WordService) {
        _viewModel = State(initialValue: PracticeSessionViewModel(wordService: wordService))
    }

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.eligibleWords(from: allMatching).isEmpty && viewModel.selectedTagID == nil {
                PracticeEmptyState()
            } else if !viewModel.isSessionActive {
                startScreen
            } else if let word = viewModel.currentWord {
                practiceContent(for: word)
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

    
    private var startScreen: some View {
        VStack(spacing: 16) {
            VStack(spacing: 6) {
                Image(systemName: "pencil.and.outline")
                    .font(.system(size: 44))
                    .foregroundStyle(.blue.gradient)
                Text("Writing practice")
                    .font(.title2.weight(.semibold))
            }
            .padding(.top, 16)

            if !allTags.isEmpty {
                TagQuestGrid(
                    tags: allTags,
                    allWords: allMatching,
                    selectedTagID: $viewModel.selectedTagID
                )
            } else {
                Spacer()
                Text("\(viewModel.eligibleWords(from: allMatching).count) words ready to practice")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
            }

            Button {
                startSession()
            } label: {
                Label(viewModel.startButtonTitle(allWords: allMatching, allTags: allTags), systemImage: "play.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(viewModel.eligibleWords(from: allMatching).isEmpty)
            .padding(.bottom, 24)
        }
    }

    @ViewBuilder
    private func practiceContent(for word: Word) -> some View {
        HStack {
            Button {
                exitSession()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            Spacer()
        }
        .padding(.top, 8)

        PracticeProgressHeader(currentIndex: viewModel.currentIndex, total: viewModel.sessionWords.count)

        Spacer(minLength: 24)

        WritingTranslationCard(word: word, direction: practiseDirection)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.currentIndex)

        Spacer(minLength: 24)

        WritingAnswerField(
            text: $text,
            isFocused: $isFocused,
            answerState: answerState,
            onSubmit: { submitAnswer(for: word) }
        )

        if answerState == .wrong {
            Text("Correct answer: \(expectedAnswer(for: word))")
                .font(.headline)
                .foregroundStyle(.red)
                .transition(.opacity.combined(with: .move(edge: .top)))
                .padding(.top, 12)
        }

        Spacer()

        Button {
            nextWord()
        } label: {
            Label("Skip", systemImage: "arrow.right")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
        }
        .buttonStyle(.plain)
        .disabled(answerState != .idle)
        .padding(.bottom, 24)
    }

    private func nextWord() {
        text = ""
        answerState = .idle
        viewModel.advance()
        isFocused = viewModel.isSessionActive
    }

    private func startSession() {
        viewModel.startSession(from: allMatching)
        text = ""
        answerState = .idle
        isFocused = true
    }
    private func exitSession() {
        viewModel.exitSession()
        isFocused = false
        text = ""
        answerState = .idle
    }

    private func expectedAnswer(for word: Word) -> String {
        practiseDirection == .OriginalToTranslate ? word.translation : word.originalSpelling
    }

    private func isAnswerCorrect(for word: Word) -> Bool {
        let normalizedInput = text
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedAnswer = expectedAnswer(for: word)
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return normalizedInput == normalizedAnswer
    }

    private func submitAnswer(for word: Word) {
        if isAnswerCorrect(for: word) {
            answerState = .correct
            viewModel.markStudied(word)
            Task {
                try? await Task.sleep(for: .seconds(1.0))
                nextWord()
            }
        } else {
            answerState = .wrong
            Task {
                try? await Task.sleep(for: .seconds(2))
                nextWord()
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Word.self, Tag.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    WritingView(wordService: WordService(modelContext: container.mainContext))
        .modelContainer(container)
}
