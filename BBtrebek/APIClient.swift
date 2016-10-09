//
//  APIClient.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/9/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit


class APIClient: NSObject {
    
    let url: URL
    let session: URLSession = URLSession.shared
    
    public init(url: String) {
        self.url = URL(string: url)!
        
    }
    
    public func request(method: String, asyncCallback: @escaping (Data?, URLResponse?, Error? ) -> Void ) -> Void {
        let request = self.newRequest()
        request.httpMethod = method
        do {
            session.dataTask(with: request as URLRequest, completionHandler: asyncCallback)
        }
    }
    
    private func newRequest() -> NSMutableURLRequest{
        let mutableRequest = NSMutableURLRequest(url: url)
        mutableRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return mutableRequest
    }
}
