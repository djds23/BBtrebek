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
    open var id: Int

    public init(answer: String, question: String, value: Int, category: String, airdate: String, id: Int) {
        self.answer = answer.stripHTMLTags()
        self.question = question.stripHTMLTags()
        self.value = value
        self.airdate = airdate
        self.category = category.stripHTMLTags()
        self.id = id
    }
    
    open static func initWithNSDictionary(_ dict: NSDictionary) -> Clue? {
        let category = (dict["category"] as! NSDictionary)["title"] as! String
    
        if let answer = dict["answer"] as? String,
            let question = dict["question"] as? String,
            let airdate = dict["airdate"] as? String,
            let id = dict["id"] as? Int,
            let value = dict["value"] as? Int {
                
            let clueObj = Clue(
                answer: answer,
                question: question,
                value: value,
                category: category,
                airdate: airdate,
                id: id
            )
            return clueObj;
        } else {
            return nil;
        }
        
    }
    
    private static func randomValidValue() -> Int {
        return [400, 300, 500, 800, 1000, 100, 200, 600].sample()
    }
}
