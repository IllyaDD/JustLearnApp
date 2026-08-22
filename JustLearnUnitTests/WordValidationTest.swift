//
//  WordValidationTest.swift
//  JustLearnUnitTests
//
//  Created by Illya Donchenko on 22.08.2026.
//

import Testing
@testable import JustLearn

struct WordValidationTest {

    @Test func shortTetxIsNottooLong(){
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        #expect(!WordValidation.isTooLong("apple"))
    }
    @Test func textOverLimitIsTooLong(){
        let longText = String(repeating: "a", count: Constans.maxWordLength + 1)
        #expect(WordValidation.isTooLong(longText))
    }
    
    @Test func textExactlyAtLimit(){
        let text = String(repeating: "a", count: Constans.maxWordLength)
        #expect(!WordValidation.isTooLong(text))
    }
    
    @Test(arguments: [WordField.original, .translation, .notes])
    func messageContainsFieldName(field: WordField) {
        #expect(WordValidation.message(for: field).contains(field.displayName))
    }
}
