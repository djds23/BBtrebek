//
//  ClueGroup.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/6/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

open class ClueGroup: NSObject {
    
    enum State {
        case loading
        case failed
        case ready
        case finished
    }
    
    private var state = State.loading
    public var clues: Array<Clue> = []
    public var currentIndex = 0
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
        } else {
            self.state = State.finished
        }
    }
    
    public func prev() -> Void {
        if self.currentIndex > 0 {
            self.state = State.ready
            self.currentIndex -= 1
        }
    }
    public func isFinished() -> Bool {
        return self.state == State.finished
    }
    
    public func isReady() -> Bool {
        return self.state == State.ready
    }
    
    public func failedToFetch() -> Bool {
        return self.state == State.failed
    }
    
    public func isLoading() -> Bool {
        return self.state == State.loading
    }

    public func isRandom() -> Bool {
        var hasRandom = false
        if self.category != nil {
            hasRandom = (self.category?.isRandom())!
        }
        return hasRandom
    }
    
    public func fetch(count: Int = 500, success: @escaping ((ClueGroup) -> Void), failure: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        
        if [State.failed, State.finished].contains(self.state) {
            self.state = State.loading
        }
        
        if self.category != nil && !isRandom() {
            let client = FetchCategoryService(category: category!, count: count)
            client.fetch(success: { (newCategory) in
                self.setStateForClues(clues: newCategory.clues)
                self.clues += newCategory.clues
                success(self)
            }, failure: { (data, urlResponse, error) in
                self.state = State.failed
                failure(data, urlResponse, error)
            })
        }
        
        if isRandom() {
            let client = FetchClueService(count: count)
            client.fetch(success: { (newClues) in
                self.setStateForClues(clues: newClues)
                self.clues += newClues
                success(self)
            }, failure: { (data, urlResponse, error) in
                self.state = State.failed
                failure(data, urlResponse, error)
            })
        }
    }
    
    private func setStateForClues(clues: Array<Clue>) {
        if clues.isEmpty {
           self.state = State.finished
        } else {
            self.state = State.ready
        }
    }
}
