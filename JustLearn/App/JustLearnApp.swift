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
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    let container: ModelContainer

    init() {
        let args = ProcessInfo.processInfo.arguments
        let isUITest = args.contains("-uitest-reset")
        if args.contains("-force-onboarding") {
            UserDefaults.standard.removeObject(forKey: "hasSeenOnboarding")
        }
        let schema = Schema([Word.self, Tag.self])
        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: isUITest
            // cloudKitDatabase: .private("iCloud.illyaDD.JustLearn")
        )
    container = try! ModelContainer(for: schema,configurations: [config])
    }
    
    
    var body: some Scene {
        WindowGroup {
            Group {
                if hasSeenOnboarding {
                    ContentView()
                } else {
                    OnBoardingView()
                }
            }
            .preferredColorScheme(appTheme(rawValue: themeRaw)?.colorScheme)
        }
        .modelContainer(container)
    }
}
