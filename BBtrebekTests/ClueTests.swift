//
//  CardTests.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/9/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import XCTest

class CardTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCardCanInitialize() {
        let initializedCard = Card(
            answer: "Dean",
            question: "Who made this app",
            value: 100,
            id: 1
        )
        initializedCard.category = Category(title:"people who are learning iOS", id: 100)
        
        XCTAssertNotNil(initializedCard, "Pass")
    }
    
    func testCardCanInitializeFromNSDictonary() {
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
        
        let initializedCard = Card.initWithNSDictionary(dict)
        XCTAssertNotNil(initializedCard, "Pass")
    }
    
    func testCardStripsHTMLTags() {
        let strippedCard = Card(
            answer: "<p>Dean</p>",
            question: "Who <em>made</em> this app",
            value: 100,
            id: 2
        )
        
        strippedCard.category = Category(title:"people who are learning iOS", id: 100)
        
        XCTAssertEqual(strippedCard.answer, "Dean", "Pass")
        XCTAssertEqual(strippedCard.question, "Who made this app", "Pass")
        XCTAssertEqual(strippedCard.categoryTitle(), "people who are learning iOS", "Pass")
    }
    
    func testCardInitializesWithNullValue() {
        let category: NSDictionary = [
            "title": "people who are learning iOS",
            "id": 100
        ]
        
        let dict: NSDictionary = [
            "answer": "Dean",
            "question": "Who made this app",
            "value": nil as Int? as Any,
            "airdate": "a datetime string",
            "category": category,
            "id": 1
        ]
        
        let initializedCard = Card.initWithNSDictionary(dict)
        XCTAssertNotNil(initializedCard, "Pass")
        XCTAssertNotNil(initializedCard?.value, "Pass")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
