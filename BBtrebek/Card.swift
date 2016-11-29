//
//  Card.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/30/15.
//  Copyright (c) 2015 Dean Silfen. All rights reserved.
//

import UIKit

public class Card: NSObject {

    open var answer: String
    open var question: String
    open var value: Int?
    open var category: Category?
    open var answered: Bool = false
    open var id: Int

    public init(answer: String, question: String, value: Int?, id: Int) {
        self.answer = answer.stripHTMLTags()
        self.question = question.stripHTMLTags()
        self.value = value
        self.id = id
    }
    
    public func categoryTitle() -> String {
        return self.category!.title
    }
    
    public func isFinalCard() -> Bool {
        return self.id == -2
    }

    public static func outOfCards() -> Card {
        let card = Card(
            answer: "Out of cards for this category! Take a peak at some of the other cards we have.",
            question: "Out of cards for this category! Take a peak at some of the other cards we have.",
            value: nil as Int?,
            id: -2
        )
        card.category = Category(title: "Out of Cards", id: 42)
        return card
    }

    static func initWithNSDictionary(_ dict: NSDictionary) -> Card? {
        let card = initWithoutCategory(dict)
        if card != nil {
            card?.category = Category(
                title: (dict["category"] as! NSDictionary)["title"] as! String,
                id: (dict["category"] as! NSDictionary)["id"] as! Int!
            )
        }
        return card
    }
    
    static func initWithoutCategory(_ dict: NSDictionary) -> Card? {
        if let answer = dict["answer"] as? String,
            let question = dict["question"] as? String,
            let id = dict["id"] as? Int {
            
            let cardObj = Card(
                answer: answer,
                question: question,
                value: nil as Int?,
                id: id
            )
            return cardObj;
        } else {
            return nil as Card?;
        }
    }
}
