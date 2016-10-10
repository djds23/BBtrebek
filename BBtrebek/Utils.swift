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
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "Okay!", style: UIAlertActionStyle.default, handler: nil))
    viewController.present(alert, animated: true, completion: nil)
}
