//
//  ClueTests.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/9/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import XCTest

class ClueTests: XCTestCase {
    
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
            airdate: "a datetime string",
            id: 1
        )
        initializedClue.category = Category(title:"people who are learning iOS", id: 100)
        
        XCTAssertNotNil(initializedClue, "Pass")
    }
    
    func testClueCanInitializeFromNSDictonary() {
        let category: NSDictionary = [
            "title": "people who are learning iOS",
            "id": 1000
        ]
        
        let dict: NSDictionary = [
            "answer": "Dean",
            "question": "Who made this app",
            "value": 100,
            "airdate": "a datetime string",
            "category": category,
            "id": 1
        ]
        
        let initializedClue = Clue.initWithNSDictionary(dict)
        XCTAssertNotNil(initializedClue, "Pass")
    }
    
    func testClueStripsHTMLTags() {
        let strippedClue = Clue(
            answer: "<p>Dean</p>",
            question: "Who <em>made</em> this app",
            value: 100,
            airdate: "a datetime string",
            id: 2
        )
        
        strippedClue.category = Category(title:"people who are learning iOS", id: 100)
        
        XCTAssertEqual(strippedClue.answer, "Dean", "Pass")
        XCTAssertEqual(strippedClue.question, "Who made this app", "Pass")
        XCTAssertEqual(strippedClue.categoryTitle(), "people who are learning iOS", "Pass")
    }
    
    func testClueInitializesWithNullValue() {
        let category: NSDictionary = [
            "title": "people who are learning iOS",
            "id": 100
        ]
        
        let dict: NSDictionary = [
            "answer": "Dean",
            "question": "Who made this app",
            "value": nil as Int?,
            "airdate": "a datetime string",
            "category": category,
            "id": 1
        ]
        
        let initializedClue = Clue.initWithNSDictionary(dict)
        XCTAssertNotNil(initializedClue, "Pass")
        XCTAssertNotNil(initializedClue?.value, "Pass")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
