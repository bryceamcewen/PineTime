//
//  EngineTests.swift
//  PineTime
//
//  Created by Goodrick,Joseph on 2/20/25.
//

@testable import PineTime
import Testing

struct EngineTests {
    let engine = Engine(
        players: []
    )

    @Test
    func twoPlayersBothActiveImmediately() throws {
        // given
        engine.players = [
            .init(name: "test 1", id: .init()),
            .init(name: "test 2", id: .init()),
        ]

        // when
        try engine.start()

        // then
        let bothPlayersAreActive = engine.players.allSatisfy({
            $0.active
        })

        #expect(bothPlayersAreActive)
    }

    @Test func elevenPlayersLeavesOneInactiveAtStart() throws {
        // given
        engine.players = (0 ..< 11).map {
            Player(name: "\($0)", id: .init())
        }

        // when
        try engine.start()

        // then
        #expect(engine.activePlayers == 10)
    }

    @Test func startWithNoPlayersThrows() throws {
        // given
        engine.players = []
        // when
        try engine.start()
        // then

    }
}
