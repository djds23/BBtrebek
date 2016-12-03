//
//  Array.swift
//  BBtrebek
//
//  Created by Dean Silfen on 12/22/15.
//  Copyright © 2015 Dean Silfen. All rights reserved.
//

import Foundation

extension Array {
    func sample() -> Element {
        let randomIndex = Int(arc4random_uniform(UInt32(count)))
        return self[randomIndex]
    }
    
    func indexExists(_ index: Int) -> Bool {
        return self.indices.contains(index)
    }
}
