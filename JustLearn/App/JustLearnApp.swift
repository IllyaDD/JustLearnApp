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
    @AppStorage("appTheme") private var themeRaw: String = appTheme.system.rawValue
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
                .preferredColorScheme(appTheme(rawValue: themeRaw)?.colorScheme)
                .onAppear {
                    requestPermission()
                }
        }
        .modelContainer(container)
    }
}
