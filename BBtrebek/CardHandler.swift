//
//  CardHandler.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/27/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

class CardHandler: NSObject, CardViewDelegate {
    
    public func updatesCardView(cardView: CardView, newCard: Card) {
        
    }
    
    public func cardViewDidAppear(cardView: CardView, card: Card) {
        
    }
    
    public func cardViewWillAppear(cardView: CardView, card: Card) {
        
    }
    
    public func cardViewIsPanned(cardView: CardView, sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: cardView)
        let newTranslationXY = CGAffineTransform(
            translationX: translation.x,
            
            y: -abs(translation.x) / 15
        )
        let newRotation = CGAffineTransform(
            rotationAngle: -translation.x / 1500
        )
        
        let newTransform = newRotation.concatenating(newTranslationXY)
        cardView.transform = newTransform
        if sender.state == UIGestureRecognizerState.ended {
            let offset = translation.x
            let swipeDirection = offset > 0 ? CardSwipeDirection.right : CardSwipeDirection.left
            let pointBreak = 96.0 as CGFloat
            let shouldDismissCard = abs(offset) > pointBreak
            if shouldDismissCard {
                self.animateFlyOff(cardView: cardView, from: swipeDirection)
            } else {
                // We go back to the original posiition if pan is not far enough for us to decide a direction
                if 16 < abs(Int(translation.x)) {
                    self.shakeBack(cardView: cardView, offset: offset, duration: 0.20)
                } else {
                    self.moveBack(cardView: cardView, duration: 0.20)
                }
            }
        }
    }
    
    public func cardViewIsDismissed(cardView: CardView) {
        
    }

    private func animateFlyOff(cardView: CardView, from: CardSwipeDirection) -> Void {
        let xBound = UIScreen.main.bounds.width * (from == .right ? 1 : -1)
        UIView.animate(withDuration: 0.30,
                       animations: {
                        let newTranslationXY = CGAffineTransform(
                            translationX:  xBound,
                            y: xBound / 15
                        )
                        let newRotation = CGAffineTransform(
                            rotationAngle: 0
                        )
                        
                        let newTransform = newRotation.concatenating(newTranslationXY)
                        cardView.transform = newTransform
        }, completion: { (finished) in
            if finished {
//                self.postSwipe()
            }
        })
    }
    
    
    private func shakeBack(cardView: CardView, offset: CGFloat, duration: TimeInterval) -> Void {
        let direction = offset > 0 ? CardSwipeDirection.left : CardSwipeDirection.right
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
            self.shake(view: cardView, direction: direction, offset: offset / 2 * CGFloat(BBUtil.goldenRatio))
        }, completion: { finished in
            if finished {
                self.moveBack(cardView: cardView, duration: 0.18)
            }
        })
    }
    
    private func moveBack(cardView: CardView, duration: TimeInterval) -> Void {
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
            cardView.centerCardPosition()
        }, completion: { finished in
            if finished {
                cardView.showQuestion()
            }
            
        })
    }
    
    
    private func shake(view: UIView, direction: CardSwipeDirection, offset: CGFloat) -> Void {
        let offsetInDirection = abs(offset) * (direction == .right ? 1 : -1)
        let newTranslationXY = CGAffineTransform(
            translationX: offsetInDirection,
            y: -abs(offset) / 15
        )
        let newRotation = CGAffineTransform(
            rotationAngle: -offsetInDirection / 1500
        )
        
        let newTransform = newRotation.concatenating(newTranslationXY)
        view.transform = newTransform
    }
}
