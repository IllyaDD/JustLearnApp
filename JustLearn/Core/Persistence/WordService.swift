//
//  WordServices.swift
//  JustLearn
//
//  Created by Illya Donchenko on 21.08.2026.
//

import Foundation
import SwiftData
@MainActor
@Observable
final class WordService{
    private let modelContext:ModelContext
    
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func addWord(
        originalSpelling:String,
        translation:String,
        tags:[Tag],
        timesToLearn:Int
    ){
        let word = Word(originalSpelling: originalSpelling, translation: translation, timestoStudy: timesToLearn, timesStudied: 0)
        modelContext.insert(word)
        word.tags = tags
        syncToWatch()
    }
    func delete(_ word:Word){
        modelContext.delete(word)
        syncToWatch()
    }
    
    func resetProgress(_ word:Word){
        word.timesStudied = 0
        word.isLearned = false
        syncToWatch()
    }

    func recordStudy(_ word:Word){
        word.timesStudied += 1
        try? modelContext.save()
        syncToWatch()
    }

    func decrementStudy(_ word:Word){
        word.timesStudied = max(0, word.timesStudied - 1)
        try? modelContext.save()
        syncToWatch()
    }

    func wordDidChange(){
        try? modelContext.save()
        syncToWatch()
    }

    private func syncToWatch(){
        WatchSyncManager.shared.syncAll(from: modelContext)
    }
}
