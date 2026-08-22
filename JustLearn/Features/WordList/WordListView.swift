//
//  WordListView.swift
//  JustLearn
//
//  Created by Illya Donchenko on 14.06.2026.
//

import SwiftUI
import SwiftData

struct WordListView: View {
    @Query private var words: [Word]
    @Query(sort: \Tag.createdAt) private var allTags: [Tag]
    @State private var viewModel: WordListViewModel

    init(wordService: WordService) {
        _viewModel = State(initialValue: WordListViewModel(wordService: wordService))
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
                    VStack(spacing: 0) {
                        if !allTags.isEmpty {
                            TagFilterBar(
                                tags: allTags,
                                counts: viewModel.tagCounts(from: words),
                                selectedTagID: $viewModel.selectedTagID
                            )
                            .padding(.vertical, 8)
                        }
                        List {
                            ForEach(viewModel.filterWords(from: words)) { word in
                                WordRow(
                                    word: word,
                                    onEdit: { viewModel.wordToEdit = word },
                                    onDelete: { viewModel.delete(word) },
                                    onResetProgress: { viewModel.resetProgress(word) }
                                )
                            }
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .searchable(text: $viewModel.searchText, placement: .toolbar, prompt: "Search words")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Picker("Sort", selection: $viewModel.sortOrder) {
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
                        viewModel.isShowingAddWordSheet = true
                    } label: {
                        Image(systemName: Constans.buttonIconString)
                    }
                }
            }
            .sheet(item: $viewModel.wordToEdit, onDismiss: {
                viewModel.wordDidChange()
            }) { word in
                EditWordSheet(word: word) {
                    viewModel.wordToEdit = nil
                }
            }
            .sheet(isPresented: $viewModel.isShowingAddWordSheet) {
                AddWordSheet { originalSpelling, translation, tags, timesToLearn in
                    viewModel.addWord(
                        originalSpelling: originalSpelling,
                        translation: translation,
                        tags: tags,
                        timesToLearn: timesToLearn
                    )
                }
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Word.self, Tag.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    WordListView(wordService: WordService(modelContext: container.mainContext))
        .modelContainer(container)
}
