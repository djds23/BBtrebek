//
//  CardViewController.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/21/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

public class CardViewController: UIViewController {

    @IBOutlet weak var cardHolderView: CardHolderView!
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
        self.perform(#selector(CardViewController.delayedAppear), with: self, afterDelay: 0.8)
    }
    
    public func delayedAppear(sender: Any?) -> Void {
        self.cardHolderView.shakeCard()
    }
    
    override public func becomeFirstResponder() -> Bool {
        return true
    }

    override public func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.cardHolderView.prevClue()
        }
    }
}
