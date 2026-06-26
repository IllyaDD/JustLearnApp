//
//  WordListView.swift
//  JustLearn
//
//  Created by Illya Donchenko on 14.06.2026.
//

import SwiftUI
import SwiftData

struct WordListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var words: [Word]

    @State private var isShowingAddWordSheet: Bool = false
    @State private var wordToEdit: Word?
    @State private var searchText = ""
    @State private var sortOrder:sortingOrder  = .byDateNew

    var filteredWords: [Word] {
        let base = searchText.isEmpty
            ? words
            : words.filter { word in
                word.originalSpelling.localizedCaseInsensitiveContains(searchText) ||
                word.translation.localizedCaseInsensitiveContains(searchText)
            }

        switch sortOrder {
        case .byDateNew:
            return base.sorted { $0.createdAt > $1.createdAt }
        case .byDateOld:
            return base.sorted { $0.createdAt < $1.createdAt }
        case .byAlphabet:
            return base.sorted {
                $0.originalSpelling.localizedCompare($1.originalSpelling) == .orderedAscending
            }
        case .byAlphabetReverse:
            return base.sorted {
                $0.originalSpelling.localizedCompare($1.originalSpelling) == .orderedDescending
            }
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if words.isEmpty {
                    Text("To start your journey, add your first word")
                        .font(.title)
                        .bold()
                        .italic()
                        .padding()
                } else {
                    List {
                        ForEach(filteredWords) { word in
                            WordRow(
                                word: word,
                                onEdit: { wordToEdit = word },
                                onDelete: { modelContext.delete(word) }
                            )
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .searchable(text: $searchText, placement: .toolbar, prompt: "Search words")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Newest first").tag(sortingOrder.byDateNew)
                            Text("Oldest first").tag(sortingOrder.byDateOld)
                            Text("A–Z").tag(sortingOrder.byAlphabet)
                            Text("Z–A").tag(sortingOrder.byAlphabetReverse)
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingAddWordSheet = true
                    } label: {
                        Image(systemName: Constans.buttonIconString)
                    }
                }
            }
            .sheet(item: $wordToEdit) { word in
                EditWordSheet(word: word) {
                    wordToEdit = nil
                }
            }
            .sheet(isPresented: $isShowingAddWordSheet) {
                AddWordSheet { originalSpelling, translation, notes, timesToLearn in
                    addWord(
                        originalSpelling: originalSpelling,
                        translation: translation,
                        notes: notes,
                        timesToLearn: timesToLearn
                    )
                }
            }
        }
    }

    private func addWord(originalSpelling: String, translation: String, notes: String, timesToLearn: Int) {
        let word = Word(
            originalSpelling: originalSpelling,
            translation: translation,
            notes: notes.isEmpty ? nil : notes,
            timestoStudy: timesToLearn,
            timesStudied: 0
        )
        modelContext.insert(word)
    }
}

#Preview {
    WordListView()
}
