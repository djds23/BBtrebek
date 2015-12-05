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
    @IBOutlet weak var playerName: UITextField!

    
    override public func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var swipeController = segue.destinationViewController as! ViewController
        swipeController.trebek = self.playerName.text
    }

}
