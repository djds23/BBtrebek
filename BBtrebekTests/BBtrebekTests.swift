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
