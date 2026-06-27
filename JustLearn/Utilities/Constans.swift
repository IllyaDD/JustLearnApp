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

enum appTheme: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }

    var iconName: String {
        switch self {
        case .system: return "iphone"
        case .light:  return "sun.max.fill"
        case .dark:   return "moon.fill"
        }
    }
}

enum CustomAppIcon: String, CaseIterable{
    case DefaultIcon
    case DarkIcon
    case TealIcon
    
    
    
    var bundleValue:String?{
        switch self{
        case .DefaultIcon: nil

        case .DarkIcon: "JustLearnDark"

        case .TealIcon: "JustLearnTeal"

        }
    }

    var displayName: String {
        switch self {
        case .DefaultIcon: "default"
        case .DarkIcon:    "dark"
        case .TealIcon:    "teal"
        }
    }
}
