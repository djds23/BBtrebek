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
    
    // CGFloat for fly off start
    let pointBreak = 96.0 as CGFloat
    let goldenRatio = 1.61803398875
    
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var bottomCardView: CardView!
    
    public func setCategory(_ category: Category) -> Void {
        self.clueGroup = ClueGroup(category: category)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For pinning view beneath nav controller
        self.edgesForExtendedLayout = []
        
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.fetchClues()
        self.setCardViewLables()
        self.addFlagCardButtonToNavBar()
        self.addSwipeGestureRecognizers()
        self.cardView.activityIndicator.isHidden = false
        self.cardView.activityIndicator.startAnimating()
        self.bottomCardView.addDropShadow()
        self.bottomCardView.activityIndicator.isHidden = true
        self.bottomCardView.isUserInteractionEnabled = false
        if self.clueGroup.isRandom() {
            self.addCategoryMoreFromButton()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addFlagCardButtonToNavBar() -> Void {
        let flag = UIImage(named: "flag")
        let button = UIButton(type: UIButtonType.custom)
        button.setImage(flag, for: UIControlState.normal)
        button.setTitle("Flag Content", for: UIControlState.normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(14)
        button.setTitleColor(BBColor.tcLightgreytext, for: UIControlState.normal)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 20)
        button.addTarget(self,
                         action: #selector(CardViewController.handleFlagCardButton(sender:)),
                         for: UIControlEvents.touchUpInside
        )
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
    }
    
    public func handleFlagCardButton(sender: UIButton) {
        FlagReasonsService().fetch(success: { (flagReasons) in
            self.presentFlagActionController(reasons: flagReasons)
        }, failure: { data, urlResponse, error in
        
        })
    }
    
    private func presentFlagActionController(reasons: Array<FlagReason>) -> Void {
        let alertController = UIAlertController(
            title: "Flag Card",
            message: "Flagging a card will cause Trivia Cards to review its content and possibly remove it from the category. Why are you flagging it today?",
            preferredStyle: UIAlertControllerStyle.actionSheet
        )
        reasons.forEach { (flagReason) in
            let alertAction = UIAlertAction(
                title: flagReason.displayName,
                style: UIAlertActionStyle.default,
                handler: { alert in
                    self.handleFlagCard(
                        card: self.cardView.clue!,
                        reason: flagReason
                    )
                }
            )
            alertController.addAction(alertAction)
        }

        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.cancel,
            handler: { alert in }
        )
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }

    public func handleFlagCard(card: Clue, reason: FlagReason) -> Void {
        DisableClueService(clue: card, reason: reason).disable(
            success: { (card) in
                alert(title: "Card Flagged", message: "Card was successfully flagged", viewController: self)
            },
            failure: { data, urlResponse, error in
                alert(title: "Error Flagging Card", message: "Please try again", viewController: self)
            }
        )
    }

    private func addCategoryMoreFromButton() -> Void {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(CardViewController.categoryViewWasTapped(sender:))
        )
        self.cardView.categoryContainer.addGestureRecognizer(tap)
    }

    public func categoryViewWasTapped(sender: Any?) -> Void {
        let cardViewController = CardViewController(nibName: "CardViewController", bundle: Bundle.main)
        let currentClue = self.cardView.clue!
        if self.clueGroup.isReady() && currentClue.category != nil {
            cardViewController.setCategory(currentClue.category!)
            self.navigationController?.pushViewController(cardViewController, animated: true)
        }
    }
    
    public func shakeCard() -> Void {
        let duration = 0.20
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
            self.shake(view: self.cardView, direction: .left, offset: CGFloat(40) / CGFloat(self.goldenRatio))
            
        }, completion: { (finished) in
            if finished {
                UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                    self.shake(view: self.cardView, direction: .right, offset: CGFloat(60)  / CGFloat(self.goldenRatio))
                }, completion: { (finished) in
                    UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                        self.centerCardPosition()
                    })
                })
            }
        })
    }
    
    public func isRandom() -> Bool {
        return self.clueGroup.isRandom()
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
            self.shake(view: self.cardView, direction: direction, offset: offset / 2 * CGFloat(self.goldenRatio))
        }, completion: { finished in
            if finished {
                self.moveBack(duration: 0.18)
            }
        })
    }
    
    private func moveBack(duration: TimeInterval) -> Void {
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
            self.centerCardPosition()
        }, completion: { finished in
            if finished {
                self.cardView.showQuestion()
            }
            
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
    
    private func postSwipe() -> Void {
        self.clueGroup.next()
        self.centerCardPosition()
        self.setCardViewLables()
        self.cardView.holdForAnswerLabel.isHidden = false
        self.cardView.setClueColors(containter: BBColor.cardWhite, textColor: BBColor.black)
        UIView.animate(withDuration: (1 * self.goldenRatio), delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
            self.cardView.showQuestion()
        })
        
        if self.clueGroup.failedToFetch() {
            self.fetchClues()
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
    
    private func setCardViewLables(animate: Bool = false) -> Void {
        if self.clueGroup.isFinished() {
            self.cardView.setClueLabels(clue: Clue.outOfClues())
        } else if self.clueGroup.isReady() {
            self.cardView.setClueLabels(clue: self.clueGroup.current()!)
        } else if self.clueGroup.isLoading() {
            self.cardView.hideLabels()
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
    
    public func cardsHaveBeenFetched(sender: Any?) -> Void {
        self.shakeCard()
    }
    
    private func fetchClues() -> Void {
        self.clueGroup.fetch(
            success: { (clueGroup) in
                self.clueGroup = clueGroup
                self.clueGroup.next()
                self.cardView.activityIndicator.stopAnimating()
                self.cardView.activityIndicator.isHidden = true
                self.cardView.hideLabels()
                self.setCardViewLables()
                UIView.animate(withDuration: (0.10 * self.goldenRatio), delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                    self.cardView.showLabels()
                })
                self.perform(#selector(CardViewController.cardsHaveBeenFetched), with: self, afterDelay: 0.6)
            },
            failure: { (data, urlResponse, error) in
                NSLog("Error Fetching Data!")
            }
        )
    }

    override public func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            // self.prevClue()
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
