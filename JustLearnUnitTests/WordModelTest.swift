//
//  WordModelTest.swift
//  JustLearnUnitTests
//
//  Created by Illya Donchenko on 22.08.2026.
//

import Testing
import SwiftData
@testable import JustLearn
struct WordModelTest {

    @Test func makeContext() throws -> ModelContext{
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Word.self,Tag.self,  configurations: config)
        return ModelContext(container)
    }
    
    @Test func notesUnwrappedTurnsEmptyStringIntoNil() throws{
        let word = Word(originalSpelling: "sun", translation: "сонце", timestoStudy: 10, timesStudied: 0)
        word.notesUnwrapped = ""
        #expect(word.notes == nil)
    }
    
    @Test func insertAndFetchWord() throws {
        let context = try makeContext()
        context.insert(Word(originalSpelling: "book", translation: "книга", timestoStudy: 10, timesStudied: 0))
        
        let words = try context.fetch(FetchDescriptor<Word>())
        #expect(words.count == 1)
        #expect(words.first?.translation == "книга")
    }

}
