//
//  Item.swift
//  MacroTracker
//
//  Created by Dean Elbery on 2024-12-31.
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
