//
//  FlagReason.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/26/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit
import Foundation

public class FlagReason: NSObject {
    var id: Int
    var machineName: String
    var displayName: String
    public init(id: Int, machineName: String, displayName: String) {
        self.id = id
        self.machineName = machineName
        self.displayName = displayName
    }
    
    static public func initWithDict(_ dict: NSDictionary) -> FlagReason? {
        var reason: FlagReason?
        if let id = dict["id"] as? Int,
            let machineName = dict["machine_name"] as? String,
            let displayName = dict["display_name"] as? String {
            reason = FlagReason(id: id, machineName: machineName, displayName: displayName)
        }
        return reason
    }
}
