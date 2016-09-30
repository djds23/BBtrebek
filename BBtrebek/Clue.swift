//
//  Clue.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/30/15.
//  Copyright (c) 2015 Dean Silfen. All rights reserved.
//

import Foundation

open class Clue: NSObject {

    open var answer: String
    open var question: String
    open var value: Int
    open var airdate: String
    open var category: String
    open var answered: Bool = false

    public init(answer: String, question: String, value: Int, category: String, airdate: String) {
        self.answer = answer.stripHTMLTags()
        self.question = question.stripHTMLTags()
        self.value = value
        self.airdate = airdate
        self.category = category.stripHTMLTags()
    }
    
    open static func initWithNSDictionary(_ dict: NSDictionary) -> Clue? {
        let category = (dict["category"] as! NSDictionary)["title"] as! String
        if let value = dict["value"] as? Int,
            let answer = dict["answer"] as? String,
            let question = dict["question"] as? String,
            let airdate = dict["airdate"] as? String {
                
            let clueObj = Clue(
                answer: answer,
                question: question,
                value: value,
                category: category,
                airdate: airdate
            )
            return clueObj;
        } else {
            return nil;
        }
        
    }
}
