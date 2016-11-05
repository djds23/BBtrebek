//
//  String.swift
//  BBtrebek
//
//  Created by Dean Silfen on 12/22/15.
//  Copyright © 2015 Dean Silfen. All rights reserved.
//

import Foundation

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    func titleize() -> String {
        return self.components(separatedBy: " ").map{ word in
            word.capitalized
        }.joined(separator: " ")
    }
    
    func stripHTMLTags() -> String {
        return self.replacingOccurrences( of: "<[^>]+>",
            with: "",
            options: .regularExpression,
            range: nil
        )
    }
    
    func blank() -> Bool {
        if self.trim() == "" {
            return true
        }
        return false
    }
}
