//
//  FlagReasonsService.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/26/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

class FlagReasonsService: NSObject {
    let client = APIClient(url:"\(Config.baseURLString())/api/v1/reasons")
    
    func dataToReasons(rawReasons: NSArray) -> Array<FlagReason> {
        var flagReasons: Array<FlagReason> = []
        for rawReason in rawReasons {
            if let flagReason = FlagReason.initWithDict(rawReason as! NSDictionary) {
                flagReasons.append(flagReason)
            }
        }
        return flagReasons
    }
    
    public func fetch(success: @escaping (Array<FlagReason>) -> Void, failure: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        self.client.request(method: "GET") { (data, url, error) in
            DispatchQueue.main.async(execute: {
                if (error != nil) {
                    failure(data, url, error)
                } else {
                    let reasonDictsFromRequest = ((try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSArray)
                    let reasons = self.dataToReasons(rawReasons: reasonDictsFromRequest)
                    success(reasons)
                }
            })
        }
    }
}
