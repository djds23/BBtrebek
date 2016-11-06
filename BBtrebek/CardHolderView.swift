//
//  CardHolderView.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/2/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

class CardHolderView: UIView {
    
    enum Direction {
        case left
        case right
    }

    var clueGroup = ClueGroup()
    
    // CGFloat where we decide enimation starts
    let pointBreak = 120.0 as CGFloat
    
    @IBOutlet weak var bottomCardView: CardView!
    @IBOutlet weak var cardView: CardView!
    @IBOutlet var cardHolderView: UIView!

    public override init(frame: CGRect){
        super.init(frame: frame)
        Bundle.main.loadNibNamed("CardHolderView", owner: self, options: nil)
        self.addSubview(self.cardHolderView)
        cardHolderView.frame = self.bounds
        self.setUpClues()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("CardHolderView", owner: self, options: nil)
        self.addSubview(self.cardHolderView)
        cardHolderView.frame = self.bounds
        self.setUpClues()
    }
    
    public func setUpClues(clueGroup: ClueGroup? = nil) -> Void {
        if clueGroup != nil {
            self.clueGroup = clueGroup!
        } else {
            self.fetchClues()
        }
        self.setCardViewLables()
        self.addSwipeGestureRecognizers()
    }
    
    public func prevClue() -> Void {
        self.clueGroup.prev()
        self.animateFlyBack()
    }
    
    @IBAction func handlePan(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.cardView)
        let newTranslationXY = CGAffineTransform(
            translationX: translation.x,
            y: -abs(translation.x) / 15
        )
        let newRotation = CGAffineTransform(
            rotationAngle: -translation.x / 1500
        )

        let newTransform = newRotation.concatenating(newTranslationXY)
        self.cardView.transform = newTransform
        
        if sender.state == UIGestureRecognizerState.ended {
            if (translation.x > self.pointBreak) {
                self.animateFlyOff(from: Direction.right)
            } else {
                if (translation.x < -self.pointBreak) {
                    self.animateFlyOff(from: Direction.left)
                } else {
                    // We go back to the original posiition if pan is not far enough for us to decide a direction
                    UIView.animate(withDuration: 0.15, animations: {
                        self.centerCardPosition()
                    })
                }
            }
        }
    }

    private func centerCardPosition() -> Void {
        self.cardView.transform = CGAffineTransform(translationX: CGFloat(0), y: CGFloat(0))
        self.cardView.transform = CGAffineTransform(rotationAngle: 0)
    }
    
    private func animateFlyOff(from: Direction) -> Void {
        let xBound = UIScreen.main.bounds.width * (from == .right ? 1.2 : -1.2)
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
            self.cardView.transform = newTransform
        }, completion: { (finished) in
            if finished {
                // pass
            }
        })
    }
    
    private func animateFlyBack() -> Void {
        let xBound = UIScreen.main.bounds.width * 1.2
        UIView.animate(withDuration: 0.30,
                       animations: {
                        let newTranslationXY = CGAffineTransform(
                            translationX:  0,
                            y: xBound / 15
                        )
                        let newRotation = CGAffineTransform(
                            rotationAngle: 0
                        )
                        
                        let newTransform = newRotation.concatenating(newTranslationXY)
                        self.cardView.transform = newTransform
        }, completion: { (finished) in
            if finished {
                self.postSwipe()
            }
        })
    }
    
    private func postSwipe() -> Void {
        self.cardView.alpha = 0
        self.clueGroup.next()
        self.setCardViewLables()
        self.centerCardPosition()
        self.cardView.alpha = 1
        
        if self.clueGroup.failedToFetch() {
            self.fetchClues()
        }
    }
    
    private func setCardViewLables() -> Void {
        self.cardView.setClueLabels(clue: self.clueGroup.current())
        self.bottomCardView.setClueLabels(clue: self.clueGroup.onDeck())
    }

    private func addSwipeGestureRecognizers() -> Void {
        let panRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(CardHolderView.handlePan(sender:))
        )
        self.cardView.addGestureRecognizer(panRecognizer)
    }
    
    private func fetchClues() -> Void {
        self.clueGroup.fetch(
            success: { (clueGroup) in
                self.clueGroup = clueGroup
                self.setCardViewLables()
            },
            failure: { (data, urlResponse, error) in
                NSLog("Error Fetching Data!")
            }
        )
    }
}
