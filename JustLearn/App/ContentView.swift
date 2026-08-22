//
//  ContentView.swift
//  JustLearn
//
//  Created by Illya Donchenko on 14.06.2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(WordService.self) private var wordService

    var body: some View {
        TabView{
            Tab(Constans.wordlistString, systemImage: Constans.wordlistIconString){
                WordListView(wordService: wordService)
            }
            Tab(Constans.cardsString, systemImage: Constans.cardsIconString){
                CardView(wordService: wordService)
            }
            Tab(Constans.writingSring, systemImage: Constans.writingIconString){
                WritingView(wordService: wordService)
            }
            Tab(Constans.settingsString, systemImage: Constans.settingsIconString){
                SettingsView(wordService: wordService)
            }
            
        }
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Word.self, Tag.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    ContentView()
        .modelContainer(container)
        .environment(WordService(modelContext: container.mainContext))
}
