//
//  NewPlayerViewController.swift
//  BBtrebek
//
//  Created by Dean Silfen on 12/20/15.
//  Copyright © 2015 Dean Silfen. All rights reserved.
//

import UIKit

class NewPlayerViewController: UIViewController {

    @IBOutlet weak var newPlayerTextField: UITextField!
    @IBOutlet weak var addPlayerButton: UIButton!
    @IBOutlet weak var newPlayerLabel: UILabel!

    var players = [Player]()
    var prompt: Array<String> = [
        "Remind them to answer in the form of a question!",
        "Will they win the daily double?",
        "Who will be joining us today?",
        "A new challenger approaches!",
        "A new contestant!",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newPlayerLabel.text = self.prompt.sample()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (sender as? UIButton == self.addPlayerButton) {
            let newPlayerViewController = segue.destinationViewController as! NewGameController
            newPlayerViewController.players.append(Player(name: self.newPlayerTextField.text!))
        }
    }
}
