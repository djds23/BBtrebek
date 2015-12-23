//
//  Player.swift
//  BBtrebek
//
//  Created by Dean Silfen on 12/5/15.
//  Copyright (c) 2015 Dean Silfen. All rights reserved.
//

import UIKit
import Foundation

public class Player: NSObject {
    public var name: String
    public var answeredClues = [Clue]()
    
    public init(name: String) {
        self.name = name   
    }

    public func score() -> Int {
        let values = self.answeredClues.map {(clue: Clue) -> Int in
            return clue.value
        }
        return values.reduce(0, combine:+)
    }
    
    public func toButtonTitle() -> String {
        return "\(self.name) - \(self.score())"
    }
}
