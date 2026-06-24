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
    @State private var currentIndex: Int = 0
    @State private var answerState: Constans.AnswerState = .idle
    @State private var wordsToLearn: [Word] = []
    @State private var isSessionActive: Bool = false
    @Environment(\.modelContext) private var modelContext

    @Query private var allMatching: [Word]

    init() {
        var descriptor = FetchDescriptor<Word>(
            predicate: #Predicate<Word> { word in
                word.timestoStudy > word.timesStudied
            },
            sortBy: [SortDescriptor(\.timesStudied, order: .forward)]
        )
        descriptor.fetchLimit = 30
        _allMatching = Query(descriptor)
    }

    var body: some View {
        VStack(spacing: 0) {
            if allMatching.isEmpty {
                WritingEmptyState()
            } else if !isSessionActive {
                startScreen
            } else if currentIndex < wordsToLearn.count {
                practiceContent(for: wordsToLearn[currentIndex])
            } else {
                WritingCompletedState(
                    totalWords: wordsToLearn.count,
                    onRestart: restartSession
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
        .onAppear {
            // авто-старт першої сесії; після виходу показуємо стартовий екран
            if !isSessionActive && wordsToLearn.isEmpty && !allMatching.isEmpty {
                startSession()
            }
        }
    }

    // MARK: - Стартовий екран (також екран після виходу з сесії)

    private var startScreen: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "pencil.and.outline")
                .font(.system(size: 64))
                .foregroundStyle(.blue.gradient)
            Text("Writing practice")
                .font(.title2.weight(.semibold))
            Text("\(allMatching.count) words ready to practice")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Button {
                startSession()
            } label: {
                Label("Start practice", systemImage: "play.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
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

        WritingProgressHeader(currentIndex: currentIndex, total: wordsToLearn.count)

        Spacer(minLength: 24)

        WritingTranslationCard(word: word)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentIndex)

        Spacer(minLength: 24)

        WritingAnswerField(
            text: $text,
            isFocused: $isFocused,
            answerState: answerState,
            onSubmit: { submitAnswer(for: word) }
        )

        if answerState == .wrong {
            Text("Правильно: \(word.translation)")
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
        .disabled(answerState == .wrong)
        .padding(.bottom, 24)
    }

    private func nextWord() {
        text = ""
        currentIndex += 1
        answerState = .idle
        isFocused = true
    }

    private func startSession() {
        wordsToLearn = Array(allMatching.shuffled().prefix(15))
        currentIndex = 0
        text = ""
        answerState = .idle
        isSessionActive = true
        isFocused = true
    }

    private func restartSession() {
        startSession()
    }

    private func exitSession() {
        isSessionActive = false
        isFocused = false
        text = ""
        answerState = .idle
    }

    private func isAnswerCorrect(for word: Word) -> Bool {
        let normalizedInput = text
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedAnswer = word.translation
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return normalizedInput == normalizedAnswer
    }

    private func submitAnswer(for word: Word) {
        if isAnswerCorrect(for: word) {
            answerState = .correct
            word.timesStudied += 1
            try? modelContext.save()
            nextWord()
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
    WritingView()
}
