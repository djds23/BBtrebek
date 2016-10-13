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

    public func fetch(success: @escaping (Category) -> Void, failure: @escaping (Data?, URLResponse?, Error? ) -> Void) -> Void {
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
        let newCategory = Category(title: title, id: id)
        let rawClues = rawCategoryWithClues["clues"] as! NSArray
        let newClues: Array<Clue?> = convertToClues(rawClues: rawClues, newCategory: newCategory)
        let filteredClues: Array<Clue> = removeNullClues(newClues: newClues)
        let clues: Array<Clue> = self.category.clues + filteredClues
        newCategory.clues = clues
        return newCategory
    }
    
    private func convertToClues(rawClues: NSArray, newCategory: Category) -> Array<Clue?> {
        return rawClues.map { rawClue in
            if let clueDict = rawClue as? NSDictionary {
                let newClue = Clue.initWithoutCategory(clueDict as NSDictionary)!
                newClue.category = newCategory
                return newClue
            } else {
                return nil as Clue?
            }
        }
    }
    
    private func removeNullClues(newClues: Array<Clue?>) -> Array<Clue> {
        return newClues.filter {
            nullableClues in nullableClues != nil
        }.map { clue in
            clue!
        }
    }
}
