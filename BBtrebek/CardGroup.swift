//
//  CardGroup.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/6/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

open class CardGroup: NSObject {
    
    enum State {
        case loading
        case failed
        case ready
        case finished
    }
    
    private var state = State.loading
    public var cards: Array<Card> = []
    public var currentIndex = 0
    var category: Category?
    
    public init(category: Category? = nil) {
        if category != nil {
            self.category = category
        }
    }
    
    public func current() -> Card? {
        var card: Card?
        if self.cards.indexExists(self.currentIndex) {
            card = self.cards[self.currentIndex]
        }
        return card
    }
    
    public func onDeck() -> Card? {
        var card: Card?
        if self.cards.indexExists(self.currentIndex + 1) {
            card = self.cards[self.currentIndex + 1]
        }
        return card
    }
    
    internal func next() -> Void {
        if self.currentIndex + 1 < self.cards.count {
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
    
    internal func updateProgress(cardViewController: CardViewController) -> Void {
        if self.isFinished() {
            cardViewController.barProgressView.setProgress(1, animated: true)
        } else {
            let percentFinished = Float(self.currentIndex) / Float(self.cards.count)
            UIView.animate(withDuration: BBUtil.goldenRatio / 4, animations: {
                cardViewController.barProgressView.setProgress(percentFinished, animated: true)
            })
        }
    }
    
    internal func fetchCardsIfNeeded(cardViewController: CardViewController) -> Void {
        if self.failedToFetch() {
            cardViewController.fetchCards()
        }
    }
    
    internal func updateLabels(cardViewController: CardViewController) -> Void {
        if self.isFinished() {
            cardViewController.cardView.setCardLabels(card: Card.outOfCards())
        } else if self.isReady() {
            cardViewController.cardView.setCardLabels(card: self.current()!)
        } else if self.isLoading() {
            cardViewController.cardView.hideLabels()
        }
        
        if let onDeckCard = self.onDeck() {
            cardViewController.bottomCardView.setCardLabels(card: onDeckCard)
        } else {
            cardViewController.bottomCardView.setCardLabels(card: Card.outOfCards())
        }
    }
    
    public func fetch(count: Int = 500, success: @escaping ((CardGroup) -> Void), failure: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        
        if [State.failed, State.finished].contains(self.state) {
            self.state = State.loading
        }
        
        if self.category != nil && !isRandom() {
            let client = FetchCategoryService(category: category!, count: count)
            client.fetch(success: { (newCategory) in
                self.setStateForCards(cards: newCategory.cards)
                self.cards += newCategory.cards
                success(self)
            }, failure: { (data, urlResponse, error) in
                self.state = State.failed
                failure(data, urlResponse, error)
            })
        }
        
        if isRandom() {
            let client = FetchCardService(count: count)
            client.fetch(success: { (newCards) in
                self.setStateForCards(cards: newCards)
                self.cards += newCards
                success(self)
            }, failure: { (data, urlResponse, error) in
                self.state = State.failed
                failure(data, urlResponse, error)
            })
        }
    }
    
    private func setStateForCards(cards: Array<Card>) {
        if cards.isEmpty {
           self.state = State.finished
        } else {
            self.state = State.ready
        }
    }
}
