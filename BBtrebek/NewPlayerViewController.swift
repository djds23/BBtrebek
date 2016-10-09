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
    @IBOutlet weak var cancelButton: UIButton!

    var playerGroup = PlayerGroup()
    var prompt: Array<String> = [
        "Remind them to answer in the form of a question!",
        "Will they win the daily double?",
        "Who will be joining us today?",
        "A new challenger approaches!",
        "A new contestant!",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newPlayerTextField.autocorrectionType = UITextAutocorrectionType.no
        self.newPlayerTextField.becomeFirstResponder()
        self.newPlayerLabel.text = self.prompt.sample()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any!) -> Bool {
        var shouldSegueBePerfomed: Bool
        if (sender as? UIButton == self.addPlayerButton) {
            let name = self.newPlayerTextField.text!.trim()
            if name.blank() {
                alert(title: "No Player Name", message: "Please provide a name for the contestant.", viewController: self)
                shouldSegueBePerfomed = false
            } else {
                shouldSegueBePerfomed = true
            }
        } else if (sender as? UIButton == self.cancelButton)  {
            shouldSegueBePerfomed = true
        } else {
            shouldSegueBePerfomed = false
        }
        return shouldSegueBePerfomed
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (sender as? UIButton == self.addPlayerButton) {
            let name = self.newPlayerTextField.text!.trim()
            self.playerGroup.addPlayer(player: Player(name: name))
            
            let newPlayerViewController = segue.destination as! NewGameController
            newPlayerViewController.playerGroup = self.playerGroup
        }
    }
}
