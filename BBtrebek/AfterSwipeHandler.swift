//
//  PostSwipeHandler.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/27/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

class AfterSwipeHandler: NSObject, AfterSwipeDelegate {
    func wasSwiped(cardViewController: CardViewController) -> Void {
        self.updateProgressView(cardViewController: cardViewController)
    }
    
    private func updateProgressView(cardViewController: CardViewController) {
        let clueGroup = cardViewController.clueGroup
        if clueGroup.isFinished() {
            cardViewController.barProgressView.setProgress(1, animated: true)
        } else {
            let percentFinished = Float(clueGroup.currentIndex) / Float(clueGroup.clues.count)
            UIView.animate(withDuration: BBUtil.goldenRatio / 4, animations: {
                cardViewController.barProgressView.setProgress(percentFinished, animated: true)
            })
        }
    }
}
