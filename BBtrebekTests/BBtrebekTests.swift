//
//  BBtrebekTests.swift
//  BBtrebekTests
//
//  Created by Dean Silfen on 11/30/15.
//  Copyright (c) 2015 Dean Silfen. All rights reserved.
//

import UIKit
import XCTest
import BBtrebek

class testViewController: UIViewController {

}

class BBtrebekTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testClueCanInitialize() {
        let initializedClue = Clue(
            answer: "Dean",
            question: "Who made this app",
            value: 100,
            category: "people who are learning iOS",
            airdate: "a datetime string"
        )
        
        XCTAssertNotNil(initializedClue, "Pass")
    }

    func testClueCanInitializeFromNSDictonary() {
        let category: NSDictionary = [
            "title": "people who are learning iOS"
        ]
        
        let dict: NSDictionary = [
            "answer": "Dean",
            "question": "Who made this app",
            "value": 100,
            "airdate": "a datetime string",
            "category": category
        ]
        
        let initializedClue = Clue.initWithNSDictionary(dict)
        XCTAssertNotNil(initializedClue, "Pass")
    }

    func testClueStripsHTMLTags() {
        let strippedClue = Clue(
            answer: "<p>Dean</p>",
            question: "Who <em>made</em> this app",
            value: 100,
            category: "people who are learning <a href='stuff.biz'>iOS</a>",
            airdate: "a datetime string"
        )
        
        XCTAssertEqual(strippedClue.answer, "Dean", "Pass")
        XCTAssertEqual(strippedClue.question, "Who made this app", "Pass")
        XCTAssertEqual(strippedClue.category, "people who are learning iOS", "Pass")
    }
    
    func testPlayerKeepsScoreAndTitle() {
        let clue1 = Clue(
            answer: "Dean",
            question: "Who made this app",
            value: 100,
            category: "people who are learning iOS",
            airdate: "a datetime string"
        )
        
        let clue2 = Clue(
            answer: "yes",
            question: "is 500 a lot?",
            value: 500,
            category: "what are numbers really?",
            airdate: "a datetime string"
        )
        
        let player = Player(name: "Dean Silfen")
        player.answeredClues.append(clue1)
        player.answeredClues.append(clue2)
        XCTAssertEqual(player.score(), 600, "Pass")
        XCTAssertEqual(player.toButtonTitle(), "Dean Silfen - 600", "Pass")
    }
    
    func testArraySampleExtension() {
        let array = [1,2,3,4]
        XCTAssertNotNil(array.sample(), "Pass")
    }
    
    func testStringTrimExtension() {
        XCTAssertEqual("       ".trim(), "", "Pass")
    }
    
    func testStringBlankExtension() {
        XCTAssertTrue("      ".blank(), "Pass") // spaces
        XCTAssertTrue(" ".blank(), "Pass") // tab
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
