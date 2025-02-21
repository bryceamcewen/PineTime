//
//  Player.swift
//  PineTime
//
//  Created by Bryce McEwen on 2/5/25.
//

import Foundation

struct Player: Identifiable {
    let name: String
    let id: UUID
    let startTime: Date = .now
    var currentTime: TimeInterval = 0.0
    var idleTime: TimeInterval = 0.0
    var active: Bool = false
    var subName: String = ""
    var totalTime: TimeInterval = 0.0
    
    
    
}
