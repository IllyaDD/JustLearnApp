//
//  Constans.swift
//  JustLearn
//
//  Created by Illya Donchenko on 14.06.2026.
//

import Foundation
import SwiftUI

struct Constans{
    //Name strings
    static let cardsString = "cards"
    static let writingSring = "writing"
    static let wordlistString = "wordlist"
    static let settingsString = "settings"
    
    
    
    //Icon Strings
    static let cardsIconString = "rectangle.portrait.on.rectangle.portrait.angled.fill"
    static let writingIconString = "pencil.circle"
    static let wordlistIconString = "list.bullet"
    static let buttonIconString = "plus"
    static let settingsIconString = "gear"
    
    enum AnswerState{
        case correct
        case wrong
        case idle
    }


}
extension Text{
    func textStyleOriginal() -> some View{
     self
         .frame(maxWidth: .infinity, alignment: .leading)
         .font(.title2)
    }
}
extension Text{
    func textStyleSecondary() -> some View{
        self
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.primary)
            .font(.title2)
    }
    }

enum sortingOrder{
    case byDateNew
    case byDateOld
    case byAlphabet
    case byAlphabetReverse
}

