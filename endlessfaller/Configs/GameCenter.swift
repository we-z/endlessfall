//
//  GameCenter.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 9/16/23.
//

import Foundation
import GameKit
import SwiftUI
import CoreMotion

class GameCenter: ObservableObject {
    
    @Published var todaysPlayersList: [Player] = []
    @Published var allTimePlayersList: [Player] = []
    init() {
        todaysPlayersList = []
        //loadScores()
        Task{
            await loadLeaderboard()
        }
    }
    
    // API
    
    // status of Game Center
    
    private(set) var isGameCenterEnabled: Bool = false

    func authenticateUser() {
        GKLocalPlayer.local.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            Task{
                await self.loadLeaderboard(source: 3)
            }
        }
    }
    
    // update local player score
    
    func updateScore(currentScore: Int, bestScore: Int, ballID: String) {
        // push score to Game Center
        Task{
            GKLeaderboard.submitScore(currentScore, context: ballID.hash, player: GKLocalPlayer.local, leaderboardIDs: [self.leaderboardID, self.allTimeLeaderboardID]) { error in
                
                if let error = error {
                    print("Error submitting score: \(error)")
                } else {
                    print("Score submitted to daily successfully")
                }
            }
        }
    }
    
    // local player
    
    private var localPlayer = GKLocalPlayer.local
    
    // leaderboard ID from iTunes Connect
    
    let leaderboardID = "grp.fallball.leaderboard"
    let allTimeLeaderboardID = "grp.AllTimeLeaderboard"
    
    //@Published var leaderboardScores: [PlayerScore] = []
 
    private var leaderboard: GKLeaderboard?
    let leaderboardIdentifier = "fallball.leaderboard"
    let allTimeLeaderboardIdentifier = "grp.AllTimeLeaderboard"
    
    // fetching leaderboard method
    
    func loadLeaderboard(source: Int = 0) async {
        DispatchQueue.main.async {
        print("source:")
        print(source)
            self.todaysPlayersList.removeAll()
            self.allTimePlayersList.removeAll()
        
            
            Task{
                var todaysPlayersListTemp : [Player] = []
                let leaderboards = try await GKLeaderboard.loadLeaderboards(IDs: [self.leaderboardIdentifier])
                if let leaderboard = leaderboards.filter ({ $0.baseLeaderboardID == self.leaderboardIdentifier }).first {
                    let allPlayers = try await leaderboard.loadEntries(for: .global, timeScope: .allTime, range: NSRange(1...50))
                    if allPlayers.1.count > 0 {
                        allPlayers.1.forEach { leaderboardEntry in
                            todaysPlayersListTemp.append(Player(name: leaderboardEntry.player.displayName, score:leaderboardEntry.score, ballID: leaderboardEntry.context, currentPlayer: leaderboardEntry.player, rank: leaderboardEntry.rank))
                            todaysPlayersListTemp.sort{
                                $0.score > $1.score
                            }
                        }
                    }
                }
                self.todaysPlayersList = todaysPlayersListTemp
            }
            Task{
                var allTimePlayersListTemp : [Player] = []
                let leaderboards = try await GKLeaderboard.loadLeaderboards(IDs: [self.allTimeLeaderboardIdentifier])
                if let leaderboard = leaderboards.filter ({ $0.baseLeaderboardID == self.allTimeLeaderboardIdentifier }).first {
                    let allPlayers = try await leaderboard.loadEntries(for: .global, timeScope: .allTime, range: NSRange(1...50))
                    if allPlayers.1.count > 0 {
                        allPlayers.1.forEach { leaderboardEntry in
                            allTimePlayersListTemp.append(Player(name: leaderboardEntry.player.displayName, score:leaderboardEntry.score, ballID: leaderboardEntry.context, currentPlayer: leaderboardEntry.player, rank: leaderboardEntry.rank))
                            allTimePlayersListTemp.sort{
                                $0.score > $1.score
                            }
                        }
                    }
                }
                self.allTimePlayersList = allTimePlayersListTemp
            }
        }
    }
}
