//
//  Engine.swift
//  PineTime
//
//  Created by Goodrick,Joseph on 2/20/25.
//

import Foundation

struct Player: Identifiable {
    var id: UUID = .init()
    let name: String
    let added: Date = .now
    var state: State
    enum State {
        case active
        case idle
    }
    var active: Bool { state ~= .active }
}

final class Engine {
    var sortedPlayers: [Player] {
        players.values.sorted(by: { $0.added < $1.added })
    }
    
    private var players: [Player.ID: Player]
    
    private var gameTime: TimeInterval = 0
    
    private var onDeck: [Player.ID: Player.ID] = [:]
    
    private var totalActiveTime: [Player.ID: TimeInterval] = [:]
    
    private var states: [Player.ID: Player.State] = [:]
    
    init(players: [Player]) {
        self.players = players.reduce(into: [:]) {
            $0[$1.id] = $1
        }
    }

    func start() throws {
        guard !sortedPlayers.isEmpty else {
            throw EngineError.noPlayers
        }
        players = sortedPlayers.enumerated().map { (index, player) in
            var copy = player
            if index < 10 {
                copy.state = .active
            }
            return copy
        }.reduce(into: [:]) {
            $0[$1.id] = $1
        }
    }

    var activePlayers: Int {
        sortedPlayers.count(where: \.active)
    }
    
    func addPlayer(name: String) {
        let player = Player(name: name, state: .idle)
        players[player.id] = player
    }
}

enum EngineError: Error {
    case noPlayers
}
