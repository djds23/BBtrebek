//
//  EntryPointViewController.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/21/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

class EntryPointViewController: UIViewController {

    @IBOutlet weak var cardHolderView: CardHolderView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cardHolderView.shakeCard()
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.cardHolderView.prevClue()
        }
    }
}
