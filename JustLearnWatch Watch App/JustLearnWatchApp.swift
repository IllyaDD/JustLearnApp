//
//  JustLearnWatchApp.swift
//  JustLearnWatch Watch App
//
//  Created by Illya Donchenko on 21.08.2026.
//

import SwiftUI
import SwiftData

@main
struct JustLearnWatch_Watch_AppApp: App {
    let container: ModelContainer

    init() {
        let schema = Schema([Word.self, Tag.self])
        container = try! ModelContainer(for: schema)
        PhoneSyncReceiver.shared.activate(container: container)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
