//
//  Constans.swift
//  JustLearn
//
//  Created by Illya Donchenko on 14.06.2026.
//

import Foundation
import SwiftUI

struct Constans{
    //Limits
    static let maxWordLength = 100
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

enum learningDestination: String, CaseIterable, Identifiable {
    case OriginalToTranslate
    case TranslateToOriginal

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .OriginalToTranslate: return "Original → Translation"
        case .TranslateToOriginal: return "Translation → Original"
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
        case .DefaultIcon: "Default"
        case .DarkIcon:    "Dark"
        case .TealIcon:    "Teal"
        }
    }
}

struct OnboardingPage: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Spacer()
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 36, weight: .regular))
                .foregroundStyle(.primary)
            Text(title)
                .font(.system(size: 40, weight: .bold))
                .multilineTextAlignment(.leading)
            Text(subtitle)
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 32)
    }
}

struct OnboardingFeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .regular))
                .frame(width: 28, alignment: .center)
            Text(text)
                .font(.title3)
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }
}
