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


public func alert(title: String!, message: String!, viewController: UIViewController!) -> Void {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "Okay!", style: UIAlertActionStyle.Default, handler: nil))
    viewController.presentViewController(alert, animated: true, completion: nil)
}

public func getNSArrayFromURLEndPoint(url: NSURL) -> NSArray {
    let request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    var error: NSError?
    var response: NSURLResponse?
    let urlData: NSData?
    do {
        urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)
    } catch let error1 as NSError {
        error = error1
        urlData = nil
    }
    
    error = nil
    let result: NSArray = (try! NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers)) as! NSArray
    
    return result
}

