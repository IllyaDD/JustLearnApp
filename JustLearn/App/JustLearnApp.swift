//
//  JustLearnApp.swift
//  JustLearn
//
//  Created by Illya Donchenko on 14.06.2026.
//

import SwiftUI
import SwiftData
// import CloudKit


@main
struct JustLearnApp: App {
    let container: ModelContainer

    init() {
        let schema = Schema([Word.self])
        let config = ModelConfiguration(
            schema: schema
            // cloudKitDatabase: .private("iCloud.illyaDD.JustLearn")
        )
    container = try! ModelContainer(for: schema,configurations: [config])
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    requestPermission()
                }
        }
        .modelContainer(container)
    }
}
