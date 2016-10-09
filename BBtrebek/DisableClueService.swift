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
    
    open func disable() -> Clue {
        self.client.request(method: "POST", { url, data, error in
            
        })
        return self.clue
    }

}