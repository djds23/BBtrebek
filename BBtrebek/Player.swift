//
//  Player.swift
//  BBtrebek
//
//  Created by Dean Silfen on 12/5/15.
//  Copyright (c) 2015 Dean Silfen. All rights reserved.
//

import UIKit
import Foundation

open class Player: NSObject {
    open var name: String
    open var answeredClues = [Clue]()
    
    public init(name: String) {
        self.name = name   
    }

    open func score() -> Int {
        let values = self.answeredClues.map {(clue: Clue) -> Int in
            var value = 0
            if clue.value != nil {
                value = clue.value!
            }
            return value
        }
        return values.reduce(0, +)
    }
    
    open func award(clue: Clue) -> Void {
        self.answeredClues.append(clue)
    }
}

