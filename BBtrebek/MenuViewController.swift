//
//  MenuViewController.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/9/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var gameOverButton: UIButton!
    
    var playerGroup: PlayerGroup = PlayerGroup()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (sender as? UIButton == self.gameOverButton) {
            let endGameViewController = segue.destination as! EndGameViewController
            endGameViewController.playerGroup = self.playerGroup
        }
    }

}
