import Foundation
import WatchConnectivity
import SwiftData

final class PhoneSyncReceiver: NSObject, WCSessionDelegate {
    static let shared = PhoneSyncReceiver()
    private var modelContainer: ModelContainer?

    private override init() {
        super.init()
    }

    func activate(container: ModelContainer) {
        self.modelContainer = container
        WCSession.default.delegate = self
        WCSession.default.activate()
    }

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        // Контекст, який iPhone надіслав, поки watch-app не працював
        let pending = session.receivedApplicationContext
        if !pending.isEmpty {
            apply(pending)
        }
    }

    func session(_ session: WCSession,
                 didReceiveApplicationContext applicationContext: [String: Any]) {
        apply(applicationContext)
    }

    /// Зливає слова з iPhone у локальну базу годинника (upsert + видалення зайвих)
    private func apply(_ payload: [String: Any]) {
        guard let dicts = payload["words"] as? [[String: Any]] else { return }
        Task { @MainActor in
            guard let context = modelContainer?.mainContext else { return }
            let existing = (try? context.fetch(FetchDescriptor<Word>())) ?? []
            let existingByID = Dictionary(uniqueKeysWithValues: existing.map { ($0.id, $0) })
            var incomingIDs: Set<UUID> = []

            for dict in dicts {
                guard let idString = dict["id"] as? String,
                      let id = UUID(uuidString: idString) else { continue }
                incomingIDs.insert(id)

                if let word = existingByID[id] {
                    word.update(from: dict)
                } else if let word = Word(syncDictionary: dict) {
                    context.insert(word)
                }
            }

            // Слова, видалені на iPhone, видаляємо і тут
            for word in existing where !incomingIDs.contains(word.id) {
                context.delete(word)
            }

            try? context.save()
        }
    }
}
