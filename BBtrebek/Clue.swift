//
//  Clue.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/30/15.
//  Copyright (c) 2015 Dean Silfen. All rights reserved.
//

import UIKit

open class Clue: NSObject {

    open var answer: String
    open var question: String
    open var value: Int
    open var airdate: String
    open var category: Category?
    open var answered: Bool = false
    open var id: Int

    public init(answer: String, question: String, value: Int, airdate: String, id: Int) {
        self.answer = answer.stripHTMLTags()
        self.question = question.stripHTMLTags()
        self.value = value
        self.airdate = airdate
        self.id = id
    }
    
    public func categoryTitle() -> String {
        return self.category!.title
    }

    static func initWithNSDictionary(_ dict: NSDictionary) -> Clue? {
        let clue = initWithoutCategory(dict)
        if clue != nil {
            clue?.category = Category(
                title: (dict["category"] as! NSDictionary)["title"] as! String,
                id: (dict["category"] as! NSDictionary)["id"] as! Int!
            )
        }
        return clue
    }
    
    static func initWithoutCategory(_ dict: NSDictionary) -> Clue? {
        let value = ensureValue(potentialValue: dict["value"] as? Int)
        if let answer = dict["answer"] as? String,
            let question = dict["question"] as? String,
            let airdate = dict["airdate"] as? String,
            let id = dict["id"] as? Int {
            
            let clueObj = Clue(
                answer: answer,
                question: question,
                value: value,
                airdate: airdate,
                id: id
            )
            return clueObj;
        } else {
            return nil;
        }
    }
    
    private static func ensureValue(potentialValue: Int?) -> Int {
        if potentialValue != nil {
            return potentialValue!
        } else {
            return [400, 300, 500, 800, 1000, 100, 200, 600].sample()
        }
    }
}
