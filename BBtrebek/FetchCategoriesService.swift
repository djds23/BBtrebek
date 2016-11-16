//
//  FetchCategoriesService.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/13/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

class FetchCategoriesService: NSObject {
    let client: APIClient
    
    public init (count: Int) {
        self.client = APIClient(url:"https://triviacards.xyz/api/v1/category?count=\(count)")
    }
    
    func dataToCategories(rawCategories: NSArray) -> Array<Category> {
        var categories: Array<Category> = []
        for clue in rawCategories {
            if let category = Category.initWithNSDictionary(clue as! NSDictionary) {
                categories.append(category)
            }
        }
        return categories
    }
    
    public func fetch(success: @escaping (Array<Category>) -> Void, failure: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        self.client.request(method: "GET") { (data, url, error) in
            if (error != nil) {
                DispatchQueue.main.async(execute: {
                    failure(data, url, error)
                })
            } else {
                let categoryDictsFromRequest = ((try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSArray)
                let categories = self.dataToCategories(rawCategories: categoryDictsFromRequest)
                DispatchQueue.main.async(execute: {
                    success(categories)
                })
            }
        }
    }
}
