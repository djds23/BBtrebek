//
//  DisableClueService.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/9/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

class DisableClueService: NSObject {
    
    let clue: Clue
    let client: APIClient
    
    public init (clue: Clue) {
        self.clue = clue
        self.client = APIClient(url:"http://jservice.io/api/invalid?id=\(clue.id)")
    }
    
    public func disable(success: @escaping (Clue) -> Void, failure: @escaping (Data?, URLResponse?, Error? ) -> Void) -> Void {
        self.client.request(method: "POST", asyncCallback: { data, url, error in
            if error != nil {
                DispatchQueue.main.async(execute: {
                    failure(data, url, error)
                })
            } else {
                DispatchQueue.main.async(execute: {
                    success(self.clue)
                })
            }
            
        })
    }
}
