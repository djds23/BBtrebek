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
    var clues: Array<Clue> = []

    public func isRandom() -> Bool {
        return self.id == -1 ? true : false
    }
    
    public init(title: String, id: Int) {
        self.title = title.stripHTMLTags()
        self.id = id
    }

    static public func initWithNSDictionary(_ dict: NSDictionary) -> Category? {
        var category = nil as Category?
        if let title = dict["title"] as? String {
            if let id = dict["id"] as? Int {
                category = Category(title: title, id: id)
            }
        }
        return category
    }

    static public func initWithClues(title: String, id: Int, clues: Array<Clue>) -> Category {
        let category = Category(title: title, id: id)
        category.clues = clues
        return category
    }

    public func appendClue(clue: Clue) {
        self.clues.append(clue)
    }
}
