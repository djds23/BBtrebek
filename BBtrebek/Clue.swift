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
    
    func stripHTMLTags(str: String) -> String {
        return str.stringByReplacingOccurrencesOfString( "<[^>]+>",
            withString: "",
            options: .RegularExpressionSearch,
            range: nil
        )
    }

    init(answer: String, question: String, value: Int, category: String, airdate: String) {
        self.answer = answer
        self.question = question
        self.value = value
        self.airdate = airdate
        self.category = category
        
        // this feels wrong, but I get compiler errors if I assign & call stripHTMLTags at the same time
        self.answer = self.stripHTMLTags(self.answer)
        self.question = self.stripHTMLTags(self.question)
        self.category = self.stripHTMLTags(self.category)
    }
}