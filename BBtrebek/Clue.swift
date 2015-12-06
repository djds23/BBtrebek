//
//  Clue.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/30/15.
//  Copyright (c) 2015 Dean Silfen. All rights reserved.
//

import Foundation

public class Clue: NSObject {

    public var answer: String
    public var question: String
    public var value: Int
    public var airdate: String
    public var category: String

    public var seen: Bool = false

    public init(answer: String, question: String, value: Int, category: String, airdate: String) {
        self.answer = stripHTMLTags(answer)
        self.question = stripHTMLTags(question)
        self.value = value
        self.airdate = airdate
        self.category = stripHTMLTags(category)
    }
}