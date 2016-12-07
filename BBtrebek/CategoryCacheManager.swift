//
//  CategoryCacheManager.swift
//  BBtrebek
//
//  Created by Dean Silfen on 12/4/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

class CategoryCacheManager: NSObject {
    
    class CachedCategory {
        var viewedCardIds: Array<Int> = []
        var currentIndex: Int?
        var lastViewedId: Int?
        let categoryId: Int
        
        public init(categoryId: Int) {
            self.categoryId = categoryId
        }
        
        public func set() -> Void {
            var cache = UserDefaults.standard.dictionary(forKey: "categoryIndexCache")
            cache?[self.cacheKey()] = self.asDict()
            UserDefaults.standard.set(cache, forKey: "categoryIndexCache")

        }
        public func hasBeenViewed(cardId: Int) -> Bool {
            return self.viewedCardIds.index(of: cardId) != nil
        }
        
        public func viewing(cardId: Int) {
            self.lastViewedId = cardId
            self.viewedCardIds.append(cardId)
        }
        
        public static func initFromCache(categoryId: Int) -> CachedCategory {
            var cache = UserDefaults.standard.dictionary(forKey: "categoryIndexCache")
            let cacheKey = "\(categoryId) - viewedCategory"
            var cachedCategory = nil as CachedCategory?
            if cache != nil && cache![cacheKey] != nil {
                let cachedDict = cache![cacheKey]
                cachedCategory = CachedCategory.initFrom(dict: cachedDict as! Dictionary<String, Any>)
            } else {
                cachedCategory = CachedCategory(categoryId: categoryId)
            }
            return cachedCategory!
        }
        
        public static func initFrom(dict: Dictionary<String, Any>) -> CachedCategory {
            let cachedCategory = CachedCategory(categoryId: dict["categoryId"] as! Int)
            for cardId in dict["viewedCardIds"] as! Array<Int> {
                cachedCategory.viewedCardIds.append(cardId)
            }
            return cachedCategory
        }
        
        public func asDict() -> Dictionary<String, Any>{
            return [
                "categoryId": self.categoryId,
                "lastViewedId": self.lastViewedId as Any,
                "currentIndex": self.currentIndex as Any,
                "viewedCardIds": self.viewedCardIds
            ]
        }
        
        public func cacheKey() -> String {
            return "\(self.categoryId) - viewedCategory"
        }
        
    }
    
    private var category: Category
    private var currentlyCachedIndex: Int?
    
    public init(category: Category) {
        self.category = category
    }
    
    public func set(card: Card) -> Void {
        let cachedCategory = CachedCategory.initFromCache(categoryId: self.category.id)
        cachedCategory.viewing(cardId: card.id)
        cachedCategory.set()
    }
    
    public func index(defaultIndex: Int = 0)  -> Int {
        let cachedCategory = CachedCategory.initFromCache(categoryId: self.category.id)
        return cachedCategory.currentIndex ?? defaultIndex
    }
}
