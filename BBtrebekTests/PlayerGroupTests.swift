//
//  PlayerGroupTests.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/8/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import XCTest

class PlayerGroupTests: XCTestCase {
    
    var playerOne: Player = Player(name: "Dean")
    var playerTwo: Player = Player(name: "Lee")
    var playerThree: Player = Player(name: "Alexis")
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNameListWithOnePlayer() {
        let playerGroup = PlayerGroup()
        playerGroup.addPlayer(player: self.playerOne)
        XCTAssertEqual(playerGroup.nameList(), "Dean", "Pass")
    }
    
    
    func testNameListWithTwoPlayers() {
        let playerGroup = PlayerGroup()
        playerGroup.addPlayer(player: self.playerOne)
        playerGroup.addPlayer(player: self.playerTwo)
        XCTAssertEqual(playerGroup.nameList(), "Dean and Lee", "Pass")
    }
    
    
    func testNameListWithThreePlayers() {
        let playerGroup = PlayerGroup()
        playerGroup.addPlayer(player: self.playerOne)
        playerGroup.addPlayer(player: self.playerTwo)
        playerGroup.addPlayer(player: self.playerThree)
        XCTAssertEqual(playerGroup.nameList(), "Dean, Lee and Alexis", "Pass")
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
