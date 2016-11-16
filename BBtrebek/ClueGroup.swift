//
//  ClueGroup.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/6/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

open class ClueGroup: NSObject {
    var clues: Array<Clue> = [Clue.nowLoadingClue()]
    var currentIndex = 0
    var category: Category?
    
    public init(category: Category? = nil) {
        if category != nil {
            self.category = category
        }
    }
    
    public func current() -> Clue? {
        var clue: Clue?
        if self.clues.indexExists(self.currentIndex) {
            clue = self.clues[self.currentIndex]
        }
        return clue
    }
    
    public func onDeck() -> Clue? {
        var clue: Clue?
        if self.clues.indexExists(self.currentIndex + 1) {
            clue = self.clues[self.currentIndex + 1]
        }
        return clue
    }
    
    public func next() -> Void {
        if self.currentIndex + 1 < self.clues.count {
            self.currentIndex += 1
        }
    }
    
    public func prev() -> Void {
        if self.currentIndex > 0 {
            self.currentIndex -= 1
        }
    }
    public func isFinished() -> Bool {
        var failed: Bool
        if self.current() != nil {
            failed = self.current()!.isFinalClue()
        } else {
            failed = true
        }
        return failed
    }
    
    public func failedToFetch() -> Bool {
        var failed = false
        if let card = self.current() {
           failed = card.isLoadingClue()
        }
        return failed
    }

    private func hasRandomCategory() -> Bool {
        var hasRandom = false
        if self.category != nil {
            hasRandom = (self.category?.isRandom())!
        }
        return hasRandom
    }
    
    public func fetch(count: Int = 500, success: @escaping ((ClueGroup) -> Void), failure: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        if self.category != nil && !hasRandomCategory() {
            let client = FetchCategoryService(category: category!, count: count)
            client.fetch(success: { (newCategory) in
                self.clues += newCategory.clues
                success(self)
            }, failure: { (data, urlResponse, error) in
                self.clues = [Clue.nowLoadingClue()]
                failure(data, urlResponse, error)
            })
        }
        
        if hasRandomCategory() {
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
