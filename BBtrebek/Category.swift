//
//  Category.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/12/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

public class Category: NSObject {

    let title: String
    let id: Int
    var cards: Array<Card> = []
    var cardCount: Int?

    public func isRandom() -> Bool {
        return self.id == -1 ? true : false
    }
    
    public func count() -> Int {
        var output = self.cards.count
        if self.cards.isEmpty && self.cardCount != nil {
            output = self.cardCount!
        }
        return output
    }
    
    
    public init(title: String, id: Int, cardCount: Int? = nil) {
        self.title = title.stripHTMLTags()
        self.id = id
        self.cardCount = cardCount
    }

    static public func initWithNSDictionary(_ dict: NSDictionary) -> Category? {
        var category = nil as Category?
        if let title = dict["title"] as? String,
            let id = dict["id"] as? Int,
            let cardCount = dict["card_count"] as? Int{
            category = Category(title: title, id: id, cardCount: cardCount)
        }
        return category
    }

    static public func initWithCards(title: String, id: Int, cards: Array<Card>) -> Category {
        let category = Category(title: title, id: id)
        category.cards = cards
        return category
    }

    public func appendCard(card: Card) {
        self.cards.append(card)
    }
}
