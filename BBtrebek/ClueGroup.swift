//
//  ClueGroup.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/6/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

open class ClueGroup: NSObject {
    var clues: Array<Clue> = [Clue.firstClue()]
    var currentIndex = 0
    
    public func current() -> Clue {
        var clue: Clue
        if self.clues.indexExists(self.currentIndex) {
            clue = self.clues[self.currentIndex]
        } else {
            clue = self.clues.first!
        }
        return clue
    }
    
    public func onDeck() -> Clue {
        var clue: Clue
        if self.clues.indexExists(self.currentIndex + 1) {
            clue = self.clues[self.currentIndex + 1]
        } else {
            clue =  Clue.nowLoadingClue()
        }
        return clue
    }
    
    public func next() -> Void {
        self.currentIndex += 1
    }
    
    public func prev() -> Void {
        if self.currentIndex > 0 {
            self.currentIndex -= 1
        }
    }
    
    public func failedToFetch() -> Bool {
        return self.current().isLoadingClue()
    }

    public func fetch(count: Int = 500, category: Category? = nil, success: @escaping ((ClueGroup) -> Void), failure: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        if category != nil{
            let client = FetchCategoryService(category: category!, count: count)
            client.fetch(success: { (newCategory) in
                self.clues += newCategory.clues
                success(self)
            }, failure: { (data, urlResponse, error) in
                self.clues = [Clue.nowLoadingClue()]
                failure(data, urlResponse, error)
            })
        } else {
            let client = FetchClueService(count: count)
            client.fetch(success: { (newClues) in
                self.clues += newClues
                success(self)
            }, failure: { (data, urlResponse, error) in
                self.clues = [Clue.nowLoadingClue()]
                failure(data, urlResponse, error)
            })
        }
    }
}
