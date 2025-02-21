//
//  ContentView.swift
//  PineTime
//
//  Created by Bryce McEwen on 2/3/25.
//

import SwiftUI
import AVFoundation


struct Root: View {
    let firstGameTime: TimeInterval = 1*5
    let subTimeInterval: TimeInterval = 1*5
    
    
    @State private var counter = 1*5 // This is equal to first game time but I'm not sure about the best way to set this
    
    @State private var minimumPlayingTime: TimeInterval = 40
    @State private var timerRunning: Bool = false
    @State private var firstGame: Bool = true
    
    @State private var newPlayerName = ""
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var sortOrder = [KeyPathComparator(\Player.currentTime)]
    @State private var selection: Player.ID?
    
    @State private var players: [Player] = [
        Player(name: "Bryce", id: UUID.init(), currentTime: 40.0,
               idleTime: 10.0, active: true),
        Player(name: "Mike", id: UUID.init(), currentTime: 30.0,
               idleTime: 20.0, active: true),
        Player(name: "Gary", id: UUID.init(), currentTime: 20.0,
               idleTime: 4.0, active: true),
        Player(name: "Scott", id: UUID.init(), currentTime: 60.0,
               idleTime: 3.0, active: true),
        Player(name: "Shane", id: UUID.init(), currentTime: 10.0,
               idleTime: 2.0, active: false),
        Player(name: "Andrew", id: UUID.init(), currentTime: 4.0,
               idleTime: 0.0, active: true),
        Player(name: "Jeff", id: UUID.init(), currentTime: 0.0,
               idleTime: 33.0, active: false),
        Player(name: "Shawn", id: UUID.init(), currentTime: 55.0,
               idleTime: 0.0, active: true),
        Player(name: "Joe", id: UUID.init(), currentTime: 34,
               idleTime: 0.0, active: true),
        Player(name: "Sameer", id: UUID.init(), currentTime: 45.4,
               idleTime: 0.0, active: true),
        Player(name: "Nevada", id: UUID.init(), currentTime: 15.0,
               idleTime: 0.0, active: true),
        Player(name: "Andrew H.", id: UUID.init(), currentTime: 25.2,
               idleTime: 0.0, active: true),
        Player(name: "Brian", id: UUID.init(), currentTime: 1.0,
               idleTime: 0.0, active: false),
    ]
    
    @State private var activePlayerGroup: [Player] = []
    
    var activePlayers: [Player] {
        players
            .filter { $0.active }
            .sorted { $0.currentTime > $1.currentTime }
    }
    
    func updatePlayerTimes() {
        for index in players.indices {
            if players[index].active {
                players[index].currentTime += 1 // Increment by 1 second
            } else {
                players[index].idleTime += 1 // Increment idle time for inactive players
            }
        }
    }
    
    func assignSubstitutes() {
        // Substitutes are assigned to active players only
        // Get array of active players
        let sortedActivePlayers = activePlayers
        // Get array of inactive players and sort by idletime
        var sortedInactivePlayers = players
            .filter { !$0.active }
            .sorted { $0.idleTime > $1.idleTime }
        // Loop through the active players
        for index in sortedActivePlayers.indices {
            // Get the first inactive player in the list (the one with the most idleTime
            if let sub = sortedInactivePlayers.first {
                // If the first player in the active player array (the one with the greatest currentTime) will have received the minimum amount of playing time at the end of the cycle, assign the next eligible sub to him/her
                if let playerIndex = players.firstIndex(where: { $0.name == sortedActivePlayers[index].name }) {
                    if (players[playerIndex].currentTime + subTimeInterval >= minimumPlayingTime) {
                        players[playerIndex].subName = sub.name
                        // Remove this player from the list because they have been assigned
                        sortedInactivePlayers.removeFirst()
                    }
                }
            } else {
                // This player does not meet criteria for sub assignment, so clear out their subName
                if let playerIndex = players.firstIndex(where: { $0.name == sortedActivePlayers[index].name }) {
                    players[playerIndex].subName = ""
                }
            }
        }
    }
    
    func makeSubstitutions() {
        for index in players.indices {
            if players[index].active, !players[index].subName.isEmpty, players[index].currentTime >= minimumPlayingTime {
                if let subIndex = players.firstIndex(where: { $0.name == players[index].subName }) {
                    players[index].active = false
                    players[index].currentTime = 0.0
                    players[subIndex].active = true
                    players[subIndex].idleTime = 0.0
                    players[index].subName = ""
                }
            }
        }
    }

    
    
    func updateActivePlayers() {
        // Get sorted active players
        let activePlayers = players.filter({ $0.active })
            .sorted { $0.currentTime > $1.currentTime }

        // Get sorted inactive players
        var inactivePlayers = players.filter({ !$0.active })
            .sorted { $0.idleTime > $1.idleTime }

        // Get the top 10
        var topActivePlayers = Array(activePlayers.prefix(10))

        // Assign subs
        /*for index in topActivePlayers.indices {
            if let sub = inactivePlayers.first {
                if (topActivePlayers[index].currentTime + Double(counter) <= minimumPlayingTime){
                    topActivePlayers[index].subName = sub.name
                    inactivePlayers.removeFirst()
                }
                
            } else {
                topActivePlayers[index].subName = ""
            }
        }*/
        activePlayerGroup = topActivePlayers
    }
    
    var nextPlayers: [Player] {
        Array(players.sorted { $0.currentTime < $1.currentTime }
            .prefix(10))
    }
    
    
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack {
                    Text("Player List:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 15)
                    Table(players) {
                        TableColumn("Player", value: \.name)
                    }
                    HStack {
                        TextField("Enter", text: $newPlayerName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: .infinity)
                        Button(action: {
                            addPlayer(playerName: newPlayerName)
                            newPlayerName = ""
                        }) {
                            Text("+")
                                .padding(.horizontal, 5)
                        }
                    }
                    
                    
                }
                .frame(width: geometry.size.width*0.2)
                VStack {
                    Text(String(format: "Time Remaining: %02d:%02d", Int(counter) / 60, Int(counter) % 60))
                    
                    Button(timerRunning ? "Stop Timer" : "Start Timer") {
                        timerRunning.toggle()
                        if timerRunning {
                            timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                        } else {
                            timer.upstream.connect().cancel()
                        }
                    }
                    Table(activePlayerGroup) {
                        TableColumn("In", value: \.name)
                        TableColumn("Time Played") { player in
                            Text(String(player.currentTime))
                        }
                        TableColumn("Sub", value: \.subName)

                    }
                }
                .onReceive(timer) { _ in
                    if timerRunning {
                        counter -= 1
                        updateActivePlayers()
                        updatePlayerTimes()
                        if counter <= 0 {
                            print("Should be making subs")
                            makeSubstitutions()
                            counter = Int(subTimeInterval)
                            assignSubstitutes()

                            
                        }
                        
                    } else {
                        
                    }
                    
                }
            }
        }
    }
    

    
    func getTimeRemaining(player: Player) -> String {
        return String(format: "%02d:%02d", Int(subTimeInterval-player.currentTime) / 60,
                      Int(subTimeInterval-player.currentTime) % 60)
    }
    
    func addPlayer(playerName: String) {
        print("Adding player")
        players.append(
            Player(name: playerName, id: UUID.init(), currentTime: 0.0,
                   idleTime: 0.0, active: false)
        )
        newPlayerName = ""
    }
    
}

#Preview(traits: .landscapeLeft) {
    Root()
}
