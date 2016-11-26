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
    
    public func post(body: NSDictionary, asyncCallback: @escaping (Data?, URLResponse?, Error? ) -> Void ) -> Void {
        let request = self.newRequest()
        if let jsonBody = self.asJson(body) {
            request.httpMethod = "POST"
            request.httpBody = jsonBody
            self.performRequest(request: request, asyncCallback: asyncCallback)
        }
    }
    
    public func request(method: String, asyncCallback: @escaping (Data?, URLResponse?, Error? ) -> Void ) -> Void {
        let request = self.newRequest()
        request.httpMethod = method
        self.performRequest(request: request, asyncCallback: asyncCallback)
    }
    
    private func asJson(_ body: NSDictionary) -> Data? {
        var jsonData: Data?
        do {
            jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch _ as Any {
            // I need to start dealing with these errors   
            NSLog("There was an error decoding json")
        }
        return jsonData
    }

    private func performRequest(request: NSMutableURLRequest, asyncCallback: @escaping (Data?, URLResponse?, Error? ) -> Void) -> Void {
        do {
            let task = session.dataTask(with: request as URLRequest, completionHandler: asyncCallback)
            task.resume()
        }
    }
    
    private func newRequest() -> NSMutableURLRequest{
        let mutableRequest = NSMutableURLRequest(url: url)
        mutableRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return mutableRequest
    }
}
