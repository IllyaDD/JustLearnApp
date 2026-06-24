//
//  Words.swift
//  JustLearn
//
//  Created by Illya Donchenko on 14.06.2026.
//

import Foundation
import SwiftData

@Model
class Word {
    var id:UUID = UUID()
    var originalSpelling: String = ""
    var translation: String = ""
    var notes: String? = nil
    var timestoStudy: Int = 0
    var timesStudied: Int = 0
    var createdAt: Date = Date()
    var isLearned:Bool = false
    
    var notesUnwrapped: String{
        get {notes ?? ""}
        set {
            notes = newValue.isEmpty ? nil : newValue
        }
    }
    
    
    init(id: UUID = UUID(), originalSpelling: String, translation: String, notes: String? = nil, timestoStudy: Int, timesStudied: Int) {
        self.id = id
        self.originalSpelling = originalSpelling
        self.translation = translation
        self.notes = notes
        self.timestoStudy = timestoStudy
        self.timesStudied = timesStudied
        self.createdAt = Date()
    }
    
    static var prieviewWords = [
        Word(originalSpelling: "apple", translation: "яблуко", notes: "A common fruit", timestoStudy: 5, timesStudied: 0),
        Word(originalSpelling: "book", translation: "книга", notes: "Something you read", timestoStudy: 4, timesStudied: 1),
        Word(originalSpelling: "water", translation: "вода", notes: "Useful everyday word", timestoStudy: 6, timesStudied: 2),
        Word(originalSpelling: "sun", translation: "сонце", notes: nil, timestoStudy: 3, timesStudied: 0),
        Word(originalSpelling: "friend", translation: "друг", notes: "Person you like and trust", timestoStudy: 5, timesStudied: 3)
    ]
    
}
