//
//  Rect.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/21/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

protocol CardViewDelegate {
    func updatesCardView(cardView: CardView, newCard: Card)
    func cardViewDidAppear(cardView: CardView, card: Card)
    func cardViewWillAppear(cardView: CardView, card: Card)
    func cardViewIsPanned(cardView: CardView, sender: UIPanGestureRecognizer)
    func cardViewIsDismissed(cardView: CardView)
}

@IBDesignable
public class CardView: UIView {
    
    var card: Card?
    var delegate: CardViewDelegate?
    
    enum CardViewState {
        case answer
        case question
    }
    var showing = CardViewState.question
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var holdForAnswerLabel: UILabel!
    @IBOutlet weak var divider: UIView!
    @IBOutlet weak var backgroundContainer: UIView!
    @IBOutlet weak var questionContainer: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var categoryContainer: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet var cardView: UIView!
    
    public static func initWithCard(card: Card) -> CardView{
        let newFileOwnerView = CardView()
        newFileOwnerView.card = card
        newFileOwnerView.setCardLabels(card: card)
        newFileOwnerView.setCardColors(containter: BBColor.cardWhite, textColor: BBColor.black)
        return newFileOwnerView
    }
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        Bundle.main.loadNibNamed("CardView", owner: self, options: nil)
        self.addSubview(self.cardView)
        cardView.frame = self.bounds
        self.setupCardView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("CardView", owner: self, options: nil)
        self.addSubview(self.cardView)
        cardView.frame = self.bounds
        self.setupCardView()
    }
    
    public func setupCardView() {
        self.addSwipeGestureRecognizers()
    }

    private func addSwipeGestureRecognizers() -> Void {
        let panRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(CardView.handlePan(sender:))
        )
        self.addGestureRecognizer(panRecognizer)
    }
    
    @IBAction func handlePan(sender: UIPanGestureRecognizer) {
        self.delegate?.cardViewIsPanned(cardView: self, sender: sender)
    }

    public func setCardLabels(card: Card) -> Void {
        self.card = card
        self.categoryLabel.text = card.categoryTitle().titleize()
        self.questionLabel.text = card.question
        self.showing = CardViewState.question
    }
    
    public func hideLabels() -> Void {
        self.categoryLabel.alpha = 0
        self.questionLabel.alpha = 0
        self.holdForAnswerLabel.alpha = 0
    }
    
    public func showLabels() -> Void {
        self.categoryLabel.alpha = 1
        self.questionLabel.alpha = 1
        self.holdForAnswerLabel.alpha = 1
    }
    
    public func setCardColors(containter: UIColor, textColor: UIColor) -> Void {
        self.setContainerColors(color: containter)
        self.setCardTextColors(color: textColor)
    }
    
    private func setContainerColors(color: UIColor) -> Void {
        self.questionContainer.backgroundColor = color
        self.categoryContainer.backgroundColor = color
        self.backgroundContainer.backgroundColor = color
    }
    
    private func setCardTextColors(color: UIColor) -> Void {
        self.questionLabel.textColor = color
        self.categoryLabel.textColor = color
        self.divider.backgroundColor = color
    }
    
    public func whileHidden(perform: @escaping ((Void) -> Void)) -> Void{
        if !self.isHidden {
            self.isHidden = true
        }
        perform()
        self.isHidden = false
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.updateState(toShow: CardViewState.answer)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.updateState(toShow: CardViewState.question)
    }

    private func updateState(toShow: CardViewState) {
        UIView.animate(withDuration: (0.16 * BBUtil.goldenRatio), animations: {
            if toShow == CardViewState.question {
                self.showQuestion()
            } else if toShow == CardViewState.answer {
                self.showAnswer()
            }
        })
    }
    
    public func addDropShadow() -> Void {
        self.cardView.layer.shadowColor = UIColor.gray.cgColor
        self.cardView.layer.shadowOpacity = 0.4
        self.cardView.layer.shadowOffset = CGSize.zero
        self.cardView.layer.shadowRadius = 4
        
        let pathRect = self.cardView.bounds.insetBy(
            dx: self.cardView.bounds.maxX + 10,
            dy: 0
        )
        self.cardView.layer.shadowPath = UIBezierPath(rect: pathRect).cgPath
    }
    
    public func hideDropShadow() -> Void {
        self.cardView.layer.shadowOpacity = 0.0
    }
    
    public func showDropShadow() -> Void {
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = 0.0
        animation.toValue = 0.4
        animation.duration = BBUtil.goldenRatio
        self.cardView.layer.add(animation, forKey: "shadowOpacity")
        self.cardView.layer.shadowOpacity = 0.4
    }

    public func showAnswer() -> Void {
        UIView.animate(withDuration: (0.16 * BBUtil.goldenRatio), animations: {
            self.questionLabel.text = self.card?.answer
            self.setCardTextColors(color: BBColor.cardWhite)
            self.setContainerColors(color: BBColor.tcSeafoamBlue)
            self.holdForAnswerLabel.textColor = BBColor.tcLightgreytext
            self.holdForAnswerLabel.isHidden = true
            self.showing = CardViewState.answer
        })
    }
    
    public func showQuestion() -> Void {
        UIView.animate(withDuration: (0.16 * BBUtil.goldenRatio), animations: {
            self.questionLabel.text = self.card?.question
            self.setCardTextColors(color: BBColor.black)
            self.setContainerColors(color: BBColor.cardWhite)
            self.holdForAnswerLabel.isHidden = false
            self.showing = CardViewState.question
        })
    }
    
    
    public func centerCardPosition() -> Void {
        let newTranslationXY = CGAffineTransform(translationX: CGFloat(0), y: CGFloat(0))
        let newRotation = CGAffineTransform(rotationAngle: 0)
        let newTransform = newRotation.concatenating(newTranslationXY)
        self.transform = newTransform
    }
}
