//
//  FetchClueService.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/9/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

class FetchClueService: NSObject {
    let client: APIClient
    
    public init (count: Int) {
        self.client = APIClient(url:"http://192.168.1.6:3000/api/random?count=\(count)")
    }
    
    open func fetch(asyncCallback: @escaping (Data?, URLResponse?, Error? ) -> Void) -> Void {
        self.client.request(method: "GET", asyncCallback: asyncCallback)
    }
}
