//
//  WordListViewModel.swift
//  JustLearn
//
//  Created by Illya Donchenko on 22.08.2026.
//

import Foundation

@MainActor
@Observable
final class WordListViewModel{
    var searchText: String = ""
    var sortOrder: sortingOrder = .byDateNew
    var selectedTagID:UUID?
    var isShowingAddWordSheet:Bool = false
    var wordToEdit:Word?
    
    private let wordService:WordService
    
    init(wordService:WordService) {
        self.wordService = wordService
    }
    
    func tagCounts(from words: [Word]) -> [UUID: Int] {
        var counts: [UUID: Int] = [:]
        for word in words {
            for tag in word.tags ?? [] {
                counts[tag.id, default: 0] += 1
            }
        }
        return counts
    }
    
    
    func filterWords(from words:[Word]) -> [Word]{
        var base = words
        if let selectedTagID{
            base = base.filter{word in
                (word.tags ?? []).contains {$0.id == selectedTagID}
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
            return base.sorted {$0.createdAt > $1.createdAt}
        case .byDateOld:
            return base.sorted {$0.createdAt < $1.createdAt}
        case .byAlphabet:
            return base.sorted
            {$0.originalSpelling.localizedCompare($1.originalSpelling) == .orderedAscending}
        case .byAlphabetReverse:
            return base.sorted
            {$0.originalSpelling.localizedCompare($1.originalSpelling) == .orderedDescending}
        }
    }
    
    
    
    func addWord(originalSpelling:String, translation:String, tags: [Tag], timesToLearn:Int){
        wordService.addWord(originalSpelling: originalSpelling,
                            translation: translation,
                            tags: tags,
                            timesToLearn: timesToLearn)
    }
    func delete(_ word:Word){
        wordService.delete(word)
    }
    func resetProgress(_ word:Word){
        wordService.resetProgress(word)
    }
    func wordDidChange(){
        wordService.wordDidChange()
    }
}
