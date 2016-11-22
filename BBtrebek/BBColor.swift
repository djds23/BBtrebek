//
//  BBColor.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/2/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

public class BBColor: NSObject {
    
    static public let tcSeafoamBlue = {
        // 4bd1c3
        return UIColor(
            red: 75.0 / 255.0,
            green: 209.0 / 255.0,
            blue: 195.0 / 255.0,
            alpha: 1.0
        )
    }()

    
    static public let tcLightgreytext = {
        // cccccc
        return UIColor(
            white: 204.0 / 255.0,
            alpha: 1.0
        )
    }()
    
    static public let tcGreenyBlueforText = {
        // 45c1b4
        return UIColor(
            red: 69.0 / 255.0,
            green: 193.0 / 255.0,
            blue: 180.0 / 255.0,
            alpha: 1.0
        )

    }()
    
    static public let black = {
        // 071413
        return UIColor(
            red:0.03,
            green:0.08,
            blue:0.07,
            alpha:1.0
        )
    }()
    
    
    static public let white = {
        // f4f4f4
        return UIColor(
            white: 244.0 / 255.0,
            alpha: 1.0
        )
    }()
    
    static public let cardWhite = {
        // ffffff
        return UIColor.white
    }()

    
}
