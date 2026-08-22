//
//  WatchSyncManager.swift
//  JustLearn
//
//  Created by Illya Donchenko on 21.08.2026.
//

import Foundation
import WatchConnectivity
import SwiftData

final class WatchSyncManager:NSObject, WCSessionDelegate{
    static let shared = WatchSyncManager()
    private var modelContainer: ModelContainer?

    private override init() {
        super.init()
    }
    func activate(container: ModelContainer){
        modelContainer = container
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }

    func syncAll(from context: ModelContext){
        guard WCSession.default.activationState == .activated else { return }
        let words = (try? context.fetch(FetchDescriptor<Word>())) ?? []
        let payload = words.map { $0.syncDictionary }
        do {
            try WCSession.default.updateApplicationContext(["words": payload])
            print("Synced \(payload.count) words to watch")
        } catch {
            print("Watch sync failed: \(error)")
        }
    }

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        if let error {
            print("WCSession activation failed: \(error)")
            return
        }
        // Сесія готова — надсилаємо актуальний стан на годинник
        Task { @MainActor in
            guard let context = modelContainer?.mainContext else { return }
            syncAll(from: context)
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // Користувач міг переключитися на інший годинник — активуємо сесію знову
        session.activate()
    }
}
