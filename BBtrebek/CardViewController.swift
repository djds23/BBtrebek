//
//  CardHolderViewController.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/17/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

protocol CardViewControllerDelegate {
    func cardWasDismissed(cardViewController: CardViewController) -> Void
}

enum CardSwipeDirection {
    case left
    case right
}

class CardViewController: UIViewController {
    
    var cardGroup = CardGroup()
    var delegate: CardViewControllerDelegate?
    
    @IBOutlet weak var barProgressView: UIProgressView!
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var bottomCardView: CardView!
    
    public func setCategory(_ category: Category) -> Void {
        self.cardGroup = CardGroup(category: category)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For pinning view beneath nav controller
        self.edgesForExtendedLayout = []
        
        self.fetchCards()
        self.setCardViewLables()
        self.addFlagCardButtonToNavBar()
        self.addSwipeGestureRecognizers()
        self.cardView.activityIndicator.isHidden = false
        self.cardView.activityIndicator.startAnimating()
        self.cardView.addDropShadow()
        self.bottomCardView.addDropShadow()
        self.bottomCardView.activityIndicator.isHidden = true
        self.bottomCardView.isUserInteractionEnabled = false
        if self.cardGroup.isRandom() {
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
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
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
            message: "Flag a card to let us know that the content should be reviewed, and potentially removed from the deck.",
            preferredStyle: UIAlertControllerStyle.actionSheet
        )
        reasons.forEach { (flagReason) in
            let alertAction = UIAlertAction(
                title: flagReason.displayName,
                style: UIAlertActionStyle.default,
                handler: { alert in
                    self.handleFlagCard(
                        card: self.cardView.card!,
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
        alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        self.present(alertController, animated: true)
    }

    public func handleFlagCard(card: Card, reason: FlagReason) -> Void {
        DisableCardService(card: card, reason: reason).disable(
            success: { (card) in
                BBUtil.alert(title: "Card Flagged", message: "Card was successfully flagged", viewController: self)
            },
            failure: { data, urlResponse, error in
                BBUtil.alert(title: "Error Flagging Card", message: "Please try again", viewController: self)
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
        let currentCard = self.cardView.card!
        if self.cardGroup.isReady() && currentCard.category != nil {
            cardViewController.setCategory(currentCard.category!)
            self.navigationController?.pushViewController(cardViewController, animated: true)
        }
    }
    
    public func shakeCard() -> Void {
        let duration = 0.20
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
            self.shake(view: self.cardView, direction: .left, offset: CGFloat(40) / CGFloat(BBUtil.goldenRatio))
            
        }, completion: { (finished) in
            if finished {
                UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                    self.shake(view: self.cardView, direction: .right, offset: CGFloat(60)  / CGFloat(BBUtil.goldenRatio))
                }, completion: { (finished) in
                    UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                        self.centerCardPosition()
                    })
                })
            }
        })
    }
    
    public func isRandom() -> Bool {
        return self.cardGroup.isRandom()
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
            let offset = translation.x
            let swipeDirection = offset > 0 ? CardSwipeDirection.right : CardSwipeDirection.left
            let pointBreak = 96.0 as CGFloat
            let shouldDismissCard = abs(offset) > pointBreak
            if shouldDismissCard {
                self.animateFlyOff(from: swipeDirection)
            } else {
                // We go back to the original posiition if pan is not far enough for us to decide a direction
                if 16 < abs(Int(translation.x)) {
                    self.shakeBack(offset: offset, duration: 0.20)
                } else {
                    self.moveBack(duration: 0.20)
                }
            }
        }
    }
    
    private func shakeBack(offset: CGFloat, duration: TimeInterval) -> Void {
        let direction = offset > 0 ? CardSwipeDirection.left : CardSwipeDirection.right
        UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
            self.shake(view: self.cardView, direction: direction, offset: offset / 2 * CGFloat(BBUtil.goldenRatio))
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
    
    private func animateFlyOff(from: CardSwipeDirection) -> Void {
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
        self.cardView.hideDropShadow()
        self.cardGroup.next()
        self.centerCardPosition()
        self.setCardViewLables()
        self.cardView.holdForAnswerLabel.isHidden = false
        self.cardView.setCardColors(containter: BBColor.cardWhite, textColor: BBColor.black)
        UIView.animate(
            withDuration: BBUtil.goldenRatio,
            delay: 0.0,
            options: UIViewAnimationOptions.allowUserInteraction,
            animations: {
                self.cardView.showQuestion()
            },
            completion: { finished in
                if finished {
                    self.cardView.showDropShadow()
                }
            }
        )
        self.delegate?.cardWasDismissed(cardViewController: self)
        if self.cardGroup.failedToFetch() {
            self.fetchCards()
        }
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
    
    private func setCardViewLables(animate: Bool = false) -> Void {
        if self.cardGroup.isFinished() {
            self.cardView.setCardLabels(card: Card.outOfCards())
        } else if self.cardGroup.isReady() {
            self.cardView.setCardLabels(card: self.cardGroup.current()!)
        } else if self.cardGroup.isLoading() {
            self.cardView.hideLabels()
        }

        if let onDeckCard = self.cardGroup.onDeck() {
            self.bottomCardView.setCardLabels(card: onDeckCard)
        } else {
            self.bottomCardView.setCardLabels(card: Card.outOfCards())
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
    
    private func fetchCards() -> Void {
        self.cardGroup.fetch(
            success: { (cardGroup) in
                self.cardGroup = cardGroup
                self.cardView.activityIndicator.stopAnimating()
                self.cardView.activityIndicator.isHidden = true
                self.cardView.hideLabels()
                self.setCardViewLables()
                UIView.animate(withDuration: (0.10 * BBUtil.goldenRatio), delay: 0.0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                    self.cardView.showLabels()
                })
                self.perform(#selector(CardViewController.cardsHaveBeenFetched), with: self, afterDelay: 0.6)
            },
            failure: { (data, urlResponse, error) in
                NSLog("Error Fetching Data!")
            }
        )
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
