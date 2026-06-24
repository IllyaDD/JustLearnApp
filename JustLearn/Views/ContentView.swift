//
//  ContentView.swift
//  JustLearn
//
//  Created by Illya Donchenko on 14.06.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            Tab(Constans.wordlistString, systemImage: Constans.wordlistIconString){
                WordListView()
            }
            Tab(Constans.cardsString, systemImage: Constans.cardsIconString){
                CardView()
            }
            Tab(Constans.writingSring, systemImage: Constans.writingIconString){
                WritingView()
            }
        }
    }
}

#Preview {
    ContentView()
}
