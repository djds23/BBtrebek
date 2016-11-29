//
//  FetchCategoryService.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/12/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

class FetchCategoryService: NSObject {

    let category: Category
    let client: APIClient

    public init (category: Category, count: Int, offset: Int = 0) {
        self.category = category
        let url =  "https://triviacards.xyz/api/v1/category/\(self.category.id)"
        self.client = APIClient(url: url)
    }

    public func fetch(success: @escaping (Category) -> Void, failure: @escaping (Data?, URLResponse?, Error? ) -> Void) -> Void {
        self.client.request(method: "GET") { (data, url, error) in
            DispatchQueue.main.async(execute: {
                if (error != nil) {
                    failure(data, url, error)
                } else {
                    let categoryDict = ((try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary)
                    let category = self.dataToCategory(rawCategoryWithCards: categoryDict)
                    success(category)
                }
            })
        }
    }

    private func dataToCategory(rawCategoryWithCards: NSDictionary) -> Category {
        let title = rawCategoryWithCards["title"] as! String
        let id = rawCategoryWithCards["id"] as! Int
        let newCategory = Category(title: title, id: id)
        let rawCards = rawCategoryWithCards["cards"] as! NSArray // cards
        let newCards: Array<Card?> = convertToCards(rawCards: rawCards, newCategory: newCategory)
        let filteredCards: Array<Card> = removeNullCards(newCards: newCards)
        let cards: Array<Card> = self.category.cards + filteredCards
        newCategory.cards = cards
        return newCategory
    }
    
    private func convertToCards(rawCards: NSArray, newCategory: Category) -> Array<Card?> {
        return rawCards.map { rawCard in
            if let cardDict = rawCard as? NSDictionary {
                let newCard = Card.initWithoutCategory(cardDict as NSDictionary)!
                newCard.category = newCategory
                return newCard
            } else {
                return nil as Card?
            }
        }
    }
    
    private func removeNullCards(newCards: Array<Card?>) -> Array<Card> {
        return newCards.filter { nullableCards in
            nullableCards != nil
        }.map { card in
            card!
        }
    }
}
