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
        self.newPlayerTextField.autocorrectionType = UITextAutocorrectionType.No
        self.newPlayerLabel.text = self.prompt.sample()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if (sender as? UIButton == self.addPlayerButton) {
            let name = self.newPlayerTextField.text!.trim()
            if name.blank() {
                // why does the first arg not need a label? swift gives a compiler error here:
                alert("No Player Name", message: "Please provide a name for the contestant.", viewController: self)
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (sender as? UIButton == self.addPlayerButton) {
            let name = self.newPlayerTextField.text!.trim()
            let newPlayerViewController = segue.destinationViewController as! NewGameController
            newPlayerViewController.players.append(Player(name: name))
        }
    }
}
