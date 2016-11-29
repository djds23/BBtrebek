//
//  DisableCardService.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/9/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit


class DisableCardService: NSObject {
    
    let card: Card
    let reason: FlagReason
    let client: APIClient = APIClient(url:"https://triviacards.xyz/api/v1/flag")
    
    public init (card: Card, reason: FlagReason) {
        self.card = card
        self.reason = reason 
    }
    
    public func disable(success: @escaping (Card) -> Void, failure: @escaping (Data?, URLResponse?, Error? ) -> Void) -> Void {
        self.client.post(body: self.jsonBody(), asyncCallback: { data, url, error in
            DispatchQueue.main.async(execute: {
                if error != nil {
                    failure(data, url, error)
                } else {
                    success(self.card)
                }
            })
            
        })
    }
    
    private func jsonBody() -> NSDictionary {
        return [
            "flag": [
                "reason_id": self.reason.id,
                "card_id": self.card.id
            ]
        ]
    }
}
