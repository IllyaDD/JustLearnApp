//
//  WordValidation.swift
//  JustLearn
//

import Foundation

enum WordField {
    case original
    case translation
    case notes

    var displayName: String {
        switch self {
        case .original:    return "Original spelling"
        case .translation: return "Translation"
        case .notes:       return "Notes"
        }
    }
}

struct WordValidation {
    static func isTooLong(_ text: String) -> Bool {
        text.count > Constans.maxWordLength
    }

    static func message(for field: WordField) -> String {
        "\(field.displayName) must be \(Constans.maxWordLength) characters or fewer."
    }
}
