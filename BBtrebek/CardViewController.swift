//
//  CardHolderViewController.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/17/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit


enum CardSwipeDirection {
    case left
    case right
}

class CardViewController: UIViewController {
    
    var cardGroup = CardGroup()
    
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
        self.cardView.delegate = CardHandler()
        self.fetchCards()
        self.setCardViewLables()
        self.addFlagCardButtonToNavBar()
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
                        self.cardView.centerCardPosition()
                    })
                })
            }
        })
    }
    
    public func isRandom() -> Bool {
        return self.cardGroup.isRandom()
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
            self.cardView.centerCardPosition()
        }, completion: { finished in
            if finished {
                self.cardView.showQuestion()
            }
            
        })
    }
    
    private func postSwipe() -> Void {
        self.cardView.hideDropShadow()
        self.cardGroup.next()
        self.cardView.centerCardPosition()
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
        self.updateProgressView()
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
    
    public func cardsHaveBeenFetched(sender: Any?) -> Void {
        self.shakeCard()
    }
    
    
    private func updateProgressView() -> Void {
        let cardGroup = self.cardGroup
        if cardGroup.isFinished() {
            self.barProgressView.setProgress(1, animated: true)
        } else {
            let percentFinished = Float(cardGroup.currentIndex) / Float(cardGroup.cards.count)
            UIView.animate(withDuration: BBUtil.goldenRatio / 4, animations: {
                self.barProgressView.setProgress(percentFinished, animated: true)
            })
        }
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
