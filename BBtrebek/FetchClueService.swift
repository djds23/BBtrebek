//
//  FetchCardService.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/9/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

class FetchCardService: NSObject {
    let client: APIClient
    
    public init (count: Int) {
        self.client = APIClient(url:"https://triviacards.xyz/api/v1/random?count=\(count)")
    }
    
    func dataToCard(rawCards: NSArray) -> Array<Card> {
        var cards: Array<Card> = []
        for card in rawCards {
            if let cardObj = Card.initWithNSDictionary(card as! NSDictionary) {
                cards.append(cardObj)
            }
        }
        return cards
    }

    public func fetch(success: @escaping (Array<Card>) -> Void, failure: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        self.client.request(method: "GET") { (data, url, error) in
            DispatchQueue.main.async(execute: {
                if (error != nil) {
                    failure(data, url, error)
                } else {
                    let cardDictsFromRequest = ((try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSArray)
                    let cards = self.dataToCard(rawCards: cardDictsFromRequest)
                    success(cards)
                }
            })
        }
    }
}
