//
//  Utils.swift
//  BBtrebek
//  General purpose functions for all files
//
//  Created by Dean Silfen on 12/6/15.
//  Copyright (c) 2015 Dean Silfen. All rights reserved.
//

import UIKit
import Foundation


public func alert(_ title: String!, message: String!, viewController: UIViewController!) -> Void {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Okay!", style: UIAlertActionStyle.default, handler: nil))
    viewController.present(alert, animated: true, completion: nil)
}

public func getNSArrayFromURLEndPoint(_ url: URL) -> NSArray {
    let request = NSMutableURLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    var error: NSError?
    var response: URLResponse?
    let urlData: Data?
    do {
        urlData = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response)
    } catch let error1 as NSError {
        error = error1
        urlData = nil
    }
    
    error = nil
    let result: NSArray = (try! JSONSerialization.jsonObject(with: urlData!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSArray
    
    return result
}

