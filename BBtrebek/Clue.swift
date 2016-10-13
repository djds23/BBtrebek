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
    open var category: Category
    open var answered: Bool = false
    open var id: Int

    public init(answer: String, question: String, value: Int, category: Category, airdate: String, id: Int) {
        self.answer = answer.stripHTMLTags()
        self.question = question.stripHTMLTags()
        self.value = value
        self.airdate = airdate
        self.category = category
        self.id = id
    }
    
    public func categoryTitle() -> String {
        return self.category.title
    }

    static func initWithNSDictionary(_ dict: NSDictionary) -> Clue? {
        let category = Category(
            title: (dict["category"] as! NSDictionary)["title"] as! String,
            id: (dict["category"] as! NSDictionary)["id"] as! Int!
        )
        let value = ensureValue(potentialValue: dict["value"] as? Int)
        if let answer = dict["answer"] as? String,
            let question = dict["question"] as? String,
            let airdate = dict["airdate"] as? String,
            let id = dict["id"] as? Int {
                
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
    
    private static func ensureValue(potentialValue: Int?) -> Int {
        if potentialValue != nil {
            return potentialValue!
        } else {
            return [400, 300, 500, 800, 1000, 100, 200, 600].sample()
        }
    }
}
