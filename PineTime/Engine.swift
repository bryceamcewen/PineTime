//
//  Engine.swift
//  PineTime
//
//  Created by Goodrick,Joseph on 2/20/25.
//

final class Engine {
    var players: [Player]

    init(players: [Player]) {
        self.players = players
    }

    func start() throws {
        players = players.enumerated().map { (index, player) in
            var copy = player
            if index < 10 {
                copy.active = true
            }
            return copy
        }
    }

    var activePlayers: Int {
        players.count(where: \.active)
    }
}
