//
//  WordSyncPayload.swift
//  JustLearn
//
//  Created by Illya Donchenko on 21.08.2026.
//

import Foundation

extension Word {
    /// Перетворює Word у словник із property-list-типів,
    /// бо WCSession вміє передавати лише String, числа, Bool, Date, Data і їхні колекції
    var syncDictionary: [String: Any] {
        var dict: [String: Any] = [
            "id": id.uuidString,
            "originalSpelling": originalSpelling,
            "translation": translation,
            "timestoStudy": timestoStudy,
            "timesStudied": timesStudied,
            "isLearned": isLearned,
            "createdAt": createdAt.timeIntervalSince1970
        ]
        if let notes {
            dict["notes"] = notes
        }
        return dict
    }

    /// Створює Word зі словника, який прийшов з iPhone.
    /// Failable: якщо словник битий — повертає nil, а не падає
    convenience init?(syncDictionary dict: [String: Any]) {
        guard let idString = dict["id"] as? String,
              let id = UUID(uuidString: idString),
              let originalSpelling = dict["originalSpelling"] as? String,
              let translation = dict["translation"] as? String,
              let timestoStudy = dict["timestoStudy"] as? Int,
              let timesStudied = dict["timesStudied"] as? Int
        else { return nil }

        self.init(
            id: id,
            originalSpelling: originalSpelling,
            translation: translation,
            notes: dict["notes"] as? String,
            timestoStudy: timestoStudy,
            timesStudied: timesStudied
        )
        self.isLearned = dict["isLearned"] as? Bool ?? false
        if let createdAt = dict["createdAt"] as? TimeInterval {
            self.createdAt = Date(timeIntervalSince1970: createdAt)
        }
    }

    /// Оновлює існуюче слово даними з iPhone (для upsert)
    func update(from dict: [String: Any]) {
        if let value = dict["originalSpelling"] as? String { originalSpelling = value }
        if let value = dict["translation"] as? String { translation = value }
        if let value = dict["timestoStudy"] as? Int { timestoStudy = value }
        if let value = dict["timesStudied"] as? Int { timesStudied = value }
        if let value = dict["isLearned"] as? Bool { isLearned = value }
        notes = dict["notes"] as? String
    }
}
