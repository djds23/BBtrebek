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
    @IBOutlet weak var playerTwo: UITextField!
    @IBOutlet weak var playerOne: UITextField!
    
    var players = [Player]()
    
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
            println("NO PLAYER 1")
            return false
        }
        
        if (self.trim(self.playerTwo.text) == "" ) {
            self.alert("Missing Name", message: "Missing name for Player Two") // <- this is strange
            println("NO PLAYER 2")
            return false
        }
        return true

    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (sender as? UIButton == self.playGame) {
            self.players.append(Player(name: self.trim(self.playerOne.text)))
            self.players.append(Player(name: self.trim(self.playerTwo.text)))
            var swipeController = segue.destinationViewController as! ViewController
            swipeController.players = self.players
        }

    }

    func alert(title: String!, message: String!) -> Void {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay!", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func trim(str: String) -> String {
        return str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }

}
