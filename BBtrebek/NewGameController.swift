//
//  NewGameController.swift
//  BBtrebek
//
//  Created by Dean Silfen on 12/5/15.
//  Copyright (c) 2015 Dean Silfen. All rights reserved.
//

import UIKit

public class NewGameController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var playGame: UIButton!
    @IBOutlet weak var playerOne: UITextField!
    @IBOutlet weak var playerTwo: UITextField!
    
    var players = [UITextField]()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override public func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject?) -> Bool {
        if (self.trim(self.playerOne.text) == "" ) {
            self.alert("Missing Name", message: "Missing name for Player One") // <- this is strange
            return false
        }
        
        if (self.trim(self.playerTwo.text) == "" ) {
            self.alert("Missing Name", message: "Missing name for Player Two") // <- this is strange
            return false
        }
        return true

    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (sender as? UIButton == self.playGame) {
            var swipeController = segue.destinationViewController as! ViewController
        }

    }

    func alert(title: String!, message: String!) -> Void {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func trim(str: String) -> String {
        return str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }

}
