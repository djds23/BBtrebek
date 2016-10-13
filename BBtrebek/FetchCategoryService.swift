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

    public init (category: Category) {
        self.category = category
        self.client = APIClient(url:"http://jservice.io/api/category?id=\(self.category.id)")
    }

    public func disable(success: @escaping (Category) -> Void, failure: @escaping (Data?, URLResponse?, Error? ) -> Void) -> Void {
        self.client.request(method: "GET") { (data, url, error) in
            if (error != nil) {
                DispatchQueue.main.async(execute: {
                    failure(data, url, error)
                })
            } else {
                let categoryDict = ((try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary)
                let category = self.dataToCategory(rawCategoryWithClues: categoryDict)
                DispatchQueue.main.async(execute: {
                    success(category)
                })
            }
        }
    }

    private func dataToCategory(rawCategoryWithClues: NSDictionary) -> Category {
        let title = rawCategoryWithClues["title"] as! String
        let id = rawCategoryWithClues["id"] as! Int
        let rawClues = rawCategoryWithClues["clues"] as! NSArray
        let newClues: Array<Clue?> = rawClues.map { rawClue in
            Clue.initWithNSDictionary(rawClue  as! NSDictionary)
        }
        let filteredClues: Array<Clue> = newClues.filter{ possibleClue in possibleClue != nil }.map{ nonNullClue in
            nonNullClue!
        }

        let clues: Array<Clue> = self.category.clues + filteredClues
        return Category.initWithClues(title: title, id: id, clues: clues)
    }
}
