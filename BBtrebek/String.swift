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
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    func stripHTMLTags() -> String {
        return self.stringByReplacingOccurrencesOfString( "<[^>]+>",
            withString: "",
            options: .RegularExpressionSearch,
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