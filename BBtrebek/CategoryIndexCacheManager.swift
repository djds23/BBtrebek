//
//  CategoryIndexCacheManager.swift
//  BBtrebek
//
//  Created by Dean Silfen on 12/4/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

class CategoryIndexCacheManager: NSObject {
    
    public let category: Category
    private var currentlyCachedIndex: Int?
    
    public init(category: Category) {
        self.category = category
    }
    
    public func set(index: Int) -> Void {
        guard currentlyCachedIndex != index else {
            return
        }
        
        var cache = UserDefaults.standard.dictionary(forKey: "categoryIndexCache")
        if cache != nil {
            cache![self.cacheKey()] = index
            UserDefaults.standard.set(cache, forKey: "categoryIndexCache")
            self.currentlyCachedIndex = index
        } else {
            cache = Dictionary<String, Int>()
            cache![self.cacheKey()] = index
            UserDefaults.standard.set(cache!, forKey: "categoryIndexCache")
        }
    }
    
    public func index(defaultIndex: Int = 0)  -> Int {
        var value = defaultIndex
        var cache = UserDefaults.standard.dictionary(forKey: "categoryIndexCache")
        
        guard cache != nil else {
            return value
        }

        if let cachedIndex = cache![self.cacheKey()] {
            value = cachedIndex as! Int
        }
        
        self.currentlyCachedIndex = value
        return value
    }
    
    private func cacheKey() -> String {
        return "\(self.category.title)\(self.category.id)"
    }
}
