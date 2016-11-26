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
        self.client = APIClient(url:"https://triviacards.xyz/api/invalid?id=\(clue.id)")
    }
    
    public func disable(success: @escaping (Clue) -> Void, failure: @escaping (Data?, URLResponse?, Error? ) -> Void) -> Void {
        self.client.request(method: "POST", asyncCallback: { data, url, error in
            DispatchQueue.main.async(execute: {
                if error != nil {
                    failure(data, url, error)
                } else {
                    success(self.clue)
                }
            })
            
        })
    }
}
