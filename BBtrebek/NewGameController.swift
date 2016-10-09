//
//  NewGameController.swift
//  BBtrebek
//
//  Created by Dean Silfen on 12/5/15.
//  Copyright (c) 2015 Dean Silfen. All rights reserved.
//

import UIKit

open class NewGameController: UIViewController {

    @IBOutlet weak var addPlayer: UIButton!
    @IBOutlet weak var playGame: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contestants: UILabel!

    var playerGroup = PlayerGroup()

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if self.playerGroup.playable() {
            self.contestants.text = ""
        } else {
            self.contestants.text = playerGroup.nameList()
        }
    }
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (sender as? UIButton == self.playGame) {
            let swipeController = segue.destination as! ViewController
            swipeController.players = self.playerGroup.asArray()
        }
        
        if (sender as? UIButton == self.addPlayer) {
            let newPlayerViewController = segue.destination as! NewPlayerViewController
            newPlayerViewController.playerGroup = self.playerGroup
        }

    }

}
