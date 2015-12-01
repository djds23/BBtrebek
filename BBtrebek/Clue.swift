//
//  Clue.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/30/15.
//  Copyright (c) 2015 Dean Silfen. All rights reserved.
//

import Foundation

class Clue {
    var answer: String
    var question: String
    var value: Int
    var airdate: String
    var category: String
    
    init(answer: String, question: String, value: Int, category: String, airdate: String) {
        self.answer = answer
        self.question = question
        self.value = value
        self.airdate = airdate
        self.category = category
    }
}