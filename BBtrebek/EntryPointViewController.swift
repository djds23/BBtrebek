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
        NotificationCenter.default.addObserver(self, selector:#selector(EntryPointViewController.handleWake), name:
            NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.shakeCard()
    }
    
    public func handleWake() -> Void {
        self.shakeCard()
    }
    
    public func shakeCard() -> Void {
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
