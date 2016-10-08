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

    var players = [Player]()

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if self.players.isEmpty {
            self.contestants.text = ""
        } else {
            
        }
    }
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (sender as? UIButton == self.playGame) {
            let swipeController = segue.destination as! ViewController
            swipeController.players = self.players
        }
        
        if (sender as? UIButton == self.addPlayer) {
            let newPlayerViewController = segue.destination as! NewPlayerViewController
            newPlayerViewController.players = self.players
        }

    }

}
