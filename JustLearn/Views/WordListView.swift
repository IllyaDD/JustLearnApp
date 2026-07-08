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
    @Query(sort: \Tag.createdAt) private var allTags: [Tag]
    @State private var isShowingAddWordSheet: Bool = false
    @State private var wordToEdit: Word?
    @State private var searchText = ""
    @State private var sortOrder:sortingOrder  = .byDateNew
    @State private var selectedTagID: UUID?

    var tagCounts: [UUID: Int] {
        var counts: [UUID: Int] = [:]
        for word in words {
            for tag in word.tags ?? [] {
                counts[tag.id, default: 0] += 1
            }
        }
        return counts
    }

    var filteredWords: [Word] {
        var base = words

        if let selectedTagID {
            base = base.filter { word in
                (word.tags ?? []).contains { $0.id == selectedTagID }
            }
        }

        if !searchText.isEmpty {
            base = base.filter { word in
                word.originalSpelling.localizedCaseInsensitiveContains(searchText) ||
                word.translation.localizedCaseInsensitiveContains(searchText)
            }
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
                    VStack(spacing: 0) {
                        if !allTags.isEmpty {
                            TagFilterBar(
                                tags: allTags,
                                counts: tagCounts,
                                selectedTagID: $selectedTagID
                            )
                            .padding(.vertical, 8)
                        }
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
                AddWordSheet { originalSpelling, translation, tags, timesToLearn in
                    addWord(
                        originalSpelling: originalSpelling,
                        translation: translation,
                        tags: tags,
                        timesToLearn: timesToLearn
                    )
                }
            }
        }
    }

    private func addWord(originalSpelling: String, translation: String, tags: [Tag], timesToLearn: Int) {
        let word = Word(
            originalSpelling: originalSpelling,
            translation: translation,
            notes: nil,
            timestoStudy: timesToLearn,
            timesStudied: 0
        )
        modelContext.insert(word)
        word.tags = tags
    }
}

#Preview {
    WordListView()
}
