//
//  FetchClueService.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/9/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

class FetchClueService: NSObject {
    let client: APIClient
    
    public init (count: Int) {
        self.client = APIClient(url:"http://triviacards.xyz/api/random?count=\(count)")
    }
    
    func dataToClue(rawClues: NSArray) -> Array<Clue> {
        var clues: Array<Clue> = []
        for clue in rawClues {
            if let clueObj = Clue.initWithNSDictionary(clue as! NSDictionary) {
                clues.append(clueObj)
            }
        }
        return clues
    }

    public func fetch(success: @escaping (Array<Clue>) -> Void, failure: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        self.client.request(method: "GET") { (data, url, error) in
            if (error != nil) {
                DispatchQueue.main.async(execute: {
                    failure(data, url, error)
                })
            } else {
                let clueDictsFromRequest = ((try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSArray)
                let clues = self.dataToClue(rawClues: clueDictsFromRequest)
                DispatchQueue.main.async(execute: {
                    success(clues)
                })
            }
        }
    }
}
