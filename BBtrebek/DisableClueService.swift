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
        self.client = APIClient(url:"http://192.168.1.6:3000/api/invalid?id=\(clue.id)")
    }
    
    open func disable(asyncCallback: @escaping (Data?, URLResponse?, Error? ) -> Void) -> Void {
        self.client.request(method: "POST", asyncCallback: asyncCallback)
    }

}
