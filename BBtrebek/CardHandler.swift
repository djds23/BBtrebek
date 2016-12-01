//
//  CardHandler.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/27/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

class CardHandler: NSObject, CardViewControllerDelegate {
    
    internal func cardWasDismissed(cardViewController: CardViewController) -> Void {
        self.updateProgressView(cardViewController: cardViewController)
    }
    
    private func updateProgressView(cardViewController: CardViewController) {
        let cardGroup = cardViewController.cardGroup
        if cardGroup.isFinished() {
            cardViewController.barProgressView.setProgress(1, animated: true)
        } else {
            let percentFinished = Float(cardGroup.currentIndex) / Float(cardGroup.cards.count)
            UIView.animate(withDuration: BBUtil.goldenRatio / 4, animations: {
                cardViewController.barProgressView.setProgress(percentFinished, animated: true)
            })
        }
    }
}
