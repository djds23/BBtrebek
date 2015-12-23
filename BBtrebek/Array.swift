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
        let randomIndex = Int(rand()) % count
        return self[randomIndex]
    }
}