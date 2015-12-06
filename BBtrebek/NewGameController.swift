//
//  NewGameController.swift
//  BBtrebek
//
//  Created by Dean Silfen on 12/5/15.
//  Copyright (c) 2015 Dean Silfen. All rights reserved.
//

import UIKit

public class NewGameController: UIViewController {


    @IBOutlet weak var playGame: UIButton!
    @IBOutlet weak var playerTwo: UITextField!
    @IBOutlet weak var playerOne: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!

    var players = [Player]()

    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override public func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject?) -> Bool {
        if (trim(self.playerOne.text) == "" ) {
            alert("Missing Name", "Missing name for Player One", self)
            return false
        }

        if (trim(self.playerTwo.text) == "" ) {
            alert("Missing Name", "Missing name for Player Two", self)
            return false
        }
        return true

    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (sender as? UIButton == self.playGame) {
            self.players.append(Player(name: trim(self.playerOne.text)))
            self.players.append(Player(name: trim(self.playerTwo.text)))
            var swipeController = segue.destinationViewController as! ViewController
            swipeController.players = self.players
        }

    }

}
