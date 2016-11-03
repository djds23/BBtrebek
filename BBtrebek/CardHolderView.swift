//
//  CardHolderView.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/2/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

class CardHolderView: UIView {

    var clues: Array<Clue> = []
    var currentIndex: Int = 0
    
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
    
    public func setUpClues(clues: Array<Clue>? = nil) -> Void {
        if clues != nil {
            self.clues = clues!
        } else {
            let clue = self.firstClue()
            self.clues.append(clue)
            self.fetchClues()
        }
        self.cardView.setClueLabels(clue: self.currentClue())
        self.addSwipeGestureRecognizers()
    }
    
    @IBAction func handlePan(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.cardView)
        let newTranslationXY = CGAffineTransform(
            translationX: translation.x,
            y: -abs(translation.x) / 15
        )
        print(-translation.x)
        let newRotation = CGAffineTransform(
            rotationAngle: -translation.x / 1500
        )
        
        let newTransform = newRotation.concatenating(newTranslationXY)
        self.cardView.transform = newTransform
        let newTranslation = sqrt(newTransform.b * newTransform.b + newTransform.d * newTransform.d)
        
        if sender.state == UIGestureRecognizerState.ended {
            if (translation.x > self.pointBreak) {
                self.animateFlyOff(translation: newTranslation)
                self.handleSwipe()
            } else {
                if (translation.x < -self.pointBreak) {
                    self.animateFlyOff(translation: newTranslation)
                    self.handleSwipe()
                } else {
                    // We go back to the original posiition if pan is not far enough for us to decide a direction
                    self.centerCardPosition()
                }
            }
        }
    }
    
    private func animateFlyOff(translation: CGFloat) -> Void {
        print("At final animation")
        UIView.animate(withDuration: 1, animations: {
            let newTranslationXY = CGAffineTransform(
                translationX: -320,
                y: -abs(self.frame.origin.x) / 15
            )
            let newRotation = CGAffineTransform(
                rotationAngle: 320 / 1500
            )
            
            let newTransform = newRotation.concatenating(newTranslationXY)
            self.cardView.transform = newTransform
        })
    }
    
    private func fadeInCard() -> Void {
        self.cardView.alpha = 1
    }
    
    private func centerCardPosition() -> Void {
        self.cardView.transform = CGAffineTransform(translationX: CGFloat(0), y: CGFloat(0))
        self.cardView.transform = CGAffineTransform(rotationAngle: 0)
    }
    
    private func handleSwipe() -> Void {
        self.popClue()
        self.postSwipe()
    }
    
    private func postSwipe() -> Void {
        self.setClueLables()
        self.centerCardPosition()
        self.fadeInCard()
        
    }
    
    private func popClue() -> Void {
        if self.hasMoreClues() {
            self.currentIndex += 1
        } else {
            self.fetchClues()
        }
    }
    
    private func hasMoreClues() -> Bool {
        return (self.currentIndex <= self.clues.count - 1)
    }
    
    private func setClueLables() -> Void {
        let currentClue = self.currentClue()
        let nextClue = self.nextClue()
        self.cardView.setClueLabels(clue: currentClue)
        self.bottomCardView.setClueLabels(clue: nextClue)
    }
    
    
    private func currentClue() -> Clue {
        return self.clues[self.currentIndex]
    }
    
    private func nextClue() -> Clue {
        if self.hasMoreClues() {
            return self.clues[self.currentIndex + 1]
        } else {
            return self.firstClue()
        }
    }
    
    private func addSwipeGestureRecognizers() -> Void {
        let panRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(CardHolderView.handlePan(sender:))
        )
        self.cardView.addGestureRecognizer(panRecognizer)
    }
    
    private func firstClue() -> Clue {
        let clue = Clue(
            answer: "Coney Island Hot Dog",
            question: "A favorite food amongst the Detropians, this dish is named after a neighborhood in NYC.",
            value: 400,
            airdate: "2008-03-20T12:00:00.000Z",
            id: 100
        )
        clue.category = Category(title: "Coney Island Hot Dog ajdaksjdhakjd ajskhdkjahsdkj lkajsdlakjsd laksjdlkasjd", id: 42)
        return clue
        
    }
    
    private func fetchClues() -> Void {
        FetchClueService(count: 500).fetch(
                success: { (newClues) in
                    // it is possible the server sent duplicates back, make sure to de-dup this list
                    self.clues += newClues
                    self.setClueLables()
            },
                failure: { (data, urlResponse, error) in
                    NSLog("Error Fetching Data!")
            }
        )
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
