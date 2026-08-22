//
//  PracticeSessionViewModel .swift
//  JustLearn
//
//  Created by Illya Donchenko on 21.08.2026.
//

import Foundation
@MainActor
@Observable
final class PracticeSessionViewModel{
    var selectedTagID: UUID?
    var isSessionActive: Bool = false
    var currentIndex = 0
    private(set) var sessionWords:[Word] = []
    
    private let wordService: WordService
    init(wordService:WordService){
        self.wordService = wordService
    }
    
    
    func eligibleWords(from allWords: [Word]) -> [Word] {
        let base = allWords.filter { $0.timestoStudy > $0.timesStudied }
        guard let tagID = selectedTagID else { return Array(base.prefix(30)) }
        return Array(base.filter { $0.tags?.contains { $0.id == tagID } ?? false }.prefix(30))
    }
    
    func startButtonTitle(allWords: [Word], allTags: [Tag]) -> String {
        let count = eligibleWords(from: allWords).count
        if let name = allTags.first(where: { $0.id == selectedTagID })?.name {
            return "Start · \(name) · \(count) words"
        }
        return "Start · \(count) words"
    }
    
    func startSession(from allWords: [Word], limit: Int = 15) {
        sessionWords = Array(eligibleWords(from: allWords).shuffled().prefix(limit))
        currentIndex = 0
        isSessionActive = true
    }

    func exitSession() {
        isSessionActive = false
        currentIndex = 0
        sessionWords = []
    }

    var currentWord: Word? {
        guard isSessionActive, currentIndex < sessionWords.count else { return nil }
        return sessionWords[currentIndex]
    }

    func advance() {
        if currentIndex + 1 >= sessionWords.count {
            exitSession()
        } else {
            currentIndex += 1
        }
    }

    func markStudied(_ word: Word) {
        wordService.recordStudy(word)
    }

    func markForgotten(_ word: Word) {
        wordService.decrementStudy(word)
    }
}
