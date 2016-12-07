//
//  Array.swift
//  BBtrebek
//
//  Created by Dean Silfen on 12/22/15.
//  Copyright © 2015 Dean Silfen. All rights reserved.
//

import Foundation

extension Array {
    
    func randomIndex() -> Int {
        return Int(arc4random_uniform(UInt32(endIndex - 1)))
    }
    
    func sample() -> Element {
        return self[self.randomIndex()]
    }
    
    func indexExists(_ index: Int) -> Bool {
        return self.indices.contains(index)
    }
    
    func shuffled() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffle()
        return list
    }
    
    mutating func shuffle() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in startIndex ..< endIndex - 1 {
            let j = randomIndex()
            if i != j {
                swap(&self[i], &self[j])
            }
        }
    }
}
