//
//  CardHolderViewController.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/17/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
    
    enum Direction {
        case left
        case right
    }
    
    var clueGroup = ClueGroup()
    
    // CGFloat where we decide animation starts
    let pointBreak = 100.0 as CGFloat
    
    
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var bottomCardView: CardView!
    
    public func setCategory(_ category: Category) -> Void {
        self.clueGroup = ClueGroup(category: category)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.fetchClues()
        self.setCardViewLables()
        self.addSwipeGestureRecognizers()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func prevClue() -> Void {
        self.clueGroup.prev()
        self.animateFlyBack()
    }
    
    public func shakeCard() -> Void {
        let duration = 0.20
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
            self.shake(view: self.cardView, direction: .left, offset: CGFloat(40) / 1.61803398875)
            
        }, completion: { (finished) in
            if finished {
                UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                    self.shake(view: self.cardView, direction: .right, offset: CGFloat(60)  / 1.61803398875)
                }, completion: { (finished) in
                    UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                        self.centerCardPosition()
                    })
                })
            }
        })
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
                    if 16 < abs(Int(translation.x)) {
                        self.shakeBack(offset: translation.x, duration: 0.20)
                    } else {
                        self.moveBack(duration: 0.20)
                    }
                }
            }
        }
    }
    
    private func shakeBack(offset: CGFloat, duration: TimeInterval) -> Void {
        let direction = offset > 0 ? Direction.left : Direction.right
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
            self.shake(view: self.cardView, direction: direction, offset: offset / 3.23606798)
        }, completion: { finished in
            self.moveBack(duration: 0.18)
        })
    }
    
    private func moveBack(duration: TimeInterval) -> Void {
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
            self.centerCardPosition()
        })
    }
    
    private func centerCardPosition() -> Void {
        let newTranslationXY = CGAffineTransform(translationX: CGFloat(0), y: CGFloat(0))
        let newRotation = CGAffineTransform(rotationAngle: 0)
        let newTransform = newRotation.concatenating(newTranslationXY)
        self.cardView.transform = newTransform
    }
    
    private func animateFlyOff(from: Direction) -> Void {
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
                        self.cardView.transform = newTransform
        }, completion: { (finished) in
            if finished {
                self.postSwipe()
            }
        })
    }
    
    private func animateFlyBack() -> Void {
        let xBound = UIScreen.main.bounds.width * 2
        self.cardView.whileHidden {
            self.cardView.transform = CGAffineTransform(translationX: xBound, y: CGFloat(0))
            self.cardView.transform = CGAffineTransform(rotationAngle: 0)
            self.setCardViewLables()
        }
        
        UIView.animate(withDuration: 0.30,
                       animations: {
                        self.centerCardPosition()
        }, completion: { (finished) in
            if finished {
                // Pass for now
            }
        })
    }
    
    private func postSwipe() -> Void {
        self.cardView.whileHidden {
            self.clueGroup.next()
            self.setCardViewLables()
            self.centerCardPosition()
        }
        
        if self.clueGroup.failedToFetch() {
            self.fetchClues()
        }
        
        if self.clueGroup.isFinished() {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func shake(view: UIView, direction: Direction, offset: CGFloat) -> Void {
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
    
    private func setCardViewLables() -> Void {
        if let currentCard = self.clueGroup.current() {
            self.cardView.setClueLabels(clue: currentCard)
        } else {
            self.cardView.setClueLabels(clue: Clue.outOfClues())
        }
        
        if let onDeckCard = self.clueGroup.onDeck() {
            self.bottomCardView.setClueLabels(clue: onDeckCard)
        } else {
            self.bottomCardView.setClueLabels(clue: Clue.outOfClues())
        }
    }
    
    private func addSwipeGestureRecognizers() -> Void {
        let panRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(CardViewController.handlePan(sender:))
        )
        self.cardView.addGestureRecognizer(panRecognizer)
    }
    
    public func delayedAppear(sender: Any?) -> Void {
        self.shakeCard()
    }
    
    private func fetchClues() -> Void {
        self.clueGroup.fetch(
            success: { (clueGroup) in
                self.clueGroup = clueGroup
                self.clueGroup.next()
                self.setCardViewLables()
                self.perform(#selector(CardViewController.delayedAppear), with: self, afterDelay: 0.6)
            },
            failure: { (data, urlResponse, error) in
                NSLog("Error Fetching Data!")
            }
        )
    }
    
    override public func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.prevClue()
        }
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
