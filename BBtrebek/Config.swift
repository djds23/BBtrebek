//
//  Config.swift
//  BBtrebek
//
//  Created by Dean Silfen on 12/4/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

enum ConfigEnvironment {
    case local
    case production
}

class Config: NSObject {
    
    static let environment: ConfigEnvironment = .production
    
    public static func baseURLString() -> String {
        var baseUrl: String
        
        switch environment {
        case .production:
            baseUrl = "https://triviacards.xyz"
        case .local:
            baseUrl = "http://172.20.10.2:3000"
        }
        
        return baseUrl
    }

}
