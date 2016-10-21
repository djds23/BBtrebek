//
//  Category.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/12/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

open class Category: NSObject {

    let title: String
    let id: Int
    var clues: Array<Clue> = []

    public init(title: String, id: Int) {
        self.title = title.stripHTMLTags()
        self.id = id
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