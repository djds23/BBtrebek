//
//  EndGameViewController.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/9/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

class EndGameViewController: UIViewController {
    
    @IBOutlet weak var winningPlayer: UILabel!

    var playerGroup: PlayerGroup = PlayerGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let winner = playerGroup.winner()
        if winner != nil {
            let text = self.winningLabel(player: winner!)
            winningPlayer.text = text
            winningPlayer.sizeToFit()
        } else {
            winningPlayer.text = ""
        }
    }

    open func winningLabel(player: Player) -> String {
        return "\(player.name) is our winner! They got " +
               "the high score of \(player.score()) after " +
               "answering \(player.answeredClues.count) questions!"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
