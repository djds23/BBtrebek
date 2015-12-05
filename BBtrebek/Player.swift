//
//  Player.swift
//  BBtrebek
//
//  Created by Dean Silfen on 12/5/15.
//  Copyright (c) 2015 Dean Silfen. All rights reserved.
//

import Foundation

public class Player: NSObject {
    public var name: String
    public var answeredClues = [Int]()
    
    public init(name: String) {
        self.name = name   
    }
    
    public func score() -> Int {
        return self.answeredClues.reduce(0, combine:+)
    }
}