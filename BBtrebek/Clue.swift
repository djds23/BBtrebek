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
    public var answered: Bool = false

    public init(answer: String, question: String, value: Int, category: String, airdate: String) {
        self.answer = answer.stripHTMLTags()
        self.question = question.stripHTMLTags()
        self.value = value
        self.airdate = airdate
        self.category = category.stripHTMLTags()
    }
    
    public static func initWithNSDictionary(dict: NSDictionary) -> Clue? {
        let category = (dict["category"] as! NSDictionary)["title"] as! String
        if let value = dict["value"] as? Int,
            answer = dict["answer"] as? String,
            question = dict["question"] as? String,
            airdate = dict["airdate"] as? String {
                
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