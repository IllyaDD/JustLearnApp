//
//  Item.swift
//  JustLearn
//
//  Created by Illya Donchenko on 14.06.2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
