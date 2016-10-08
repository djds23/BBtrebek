//
//  PlayerGroup.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/8/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

open class PlayerGroup: NSObject {
    var players: Array<Player> = []
    
    public static func initWithArray(newPlayers: Array<Player>) -> PlayerGroup {
        let newPlayerGroup = PlayerGroup()
        newPlayerGroup.players = newPlayers
        return newPlayerGroup
    }
    
    public func addPlayer(player: Player) -> Void {
        self.players.append(player)
    }
    
    public func nameList() -> String {
        var listString: String
        if self.players.count == 1 {
            listString = self.nameFromPlayer(player: self.players.first!)
        } else if self.players.count == 2 {
            let playerOneName = self.nameFromPlayer(player: self.players.first!)
            let playerTwoName = self.nameFromPlayer(player: self.players.last!)
            listString = "\(playerOneName) and \(playerTwoName)"
        } else {
            let playerNames: Array<String> =  self.playerList(includeLast: false).map({player in
                player.name
            })
            listString = "\(playerNames.joined(separator: ", ")) and \(self.players.last!.name)"
        }
        return listString
    }
    
    private func nameFromPlayer(player: Player) -> String{
        return player.name
    }
    
    private func playerList(includeLast: Bool) -> Array<Player> {
        let finalElement = includeLast ?  1 : 2
        let endCount = self.players.count - finalElement
        if endCount > self.players.count {
            return self.players
        }else {
            let slice = self.players[0...endCount]
            return Array(slice)
        }
    }
}
