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
        engine.addPlayer(name: "test 1")
        engine.addPlayer(name: "test 2")

        // when
        try engine.start()

        // then
        let bothPlayersAreActive = engine.sortedPlayers.allSatisfy({
            $0.active
        })

        #expect(bothPlayersAreActive)
    }

    @Test func elevenPlayersLeavesOneInactiveAtStart() throws {
        // given
        (0 ..< 11).forEach {
            engine.addPlayer(name: "\($0)")
        }

        // when
        try engine.start()

        // then
        #expect(engine.activePlayers == 10)
    }

    @Test func startWithNoPlayersThrows() throws {
        // given
        // when
        do {
            try engine.start()
            #expect(Bool(false))
        } catch {
            // then
            #expect(error as? EngineError == EngineError.noPlayers)
        }
        

    }
}
