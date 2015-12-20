//
//  NewGameController.swift
//  BBtrebek
//
//  Created by Dean Silfen on 12/5/15.
//  Copyright (c) 2015 Dean Silfen. All rights reserved.
//

import UIKit

public class NewGameController: UIViewController {

    @IBOutlet weak var addPlayer: UIButton!
    @IBOutlet weak var playGame: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!

    var players = [Player]()

    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (sender as? UIButton == self.playGame) {
//            self.players.append(Player(name: trim(self.playerOne.text!)))
//            self.players.append(Player(name: trim(self.playerTwo.text!)))
            let swipeController = segue.destinationViewController as! ViewController
            swipeController.players = self.players
        }
        
        if (sender as? UIButton == self.addPlayer) {
            let newPlayerViewController = segue.destinationViewController as! NewPlayerViewController
            newPlayerViewController.players = self.players
        }

    }

}
