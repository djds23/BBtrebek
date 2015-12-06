//
//  utils.swift
//  BBtrebek
//
//  Created by Dean Silfen on 12/6/15.
//  Copyright (c) 2015 Dean Silfen. All rights reserved.
//

import UIKit
import Foundation


public func alert(title: String!, message: String!, viewController: UIViewController!) -> Void {
    var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "Okay!", style: UIAlertActionStyle.Default, handler: nil))
    viewController.presentViewController(alert, animated: true, completion: nil)
}

public func trim(str: String) -> String {
    return str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
}


public func stripHTMLTags(str: String) -> String {
    return str.stringByReplacingOccurrencesOfString( "<[^>]+>",
        withString: "",
        options: .RegularExpressionSearch,
        range: nil
    )
}