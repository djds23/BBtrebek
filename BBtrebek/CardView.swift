//
//  Rect.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/21/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

public class CardView: UIView {
    var clue: Clue?

    enum CardViewState {
        case answer
        case question
    }
    var showing = CardViewState.question
    
    
    @IBOutlet weak var holdForAnswerLabel: UILabel!
    @IBOutlet weak var divider: UIView!
    @IBOutlet weak var backgroundContainer: UIView!
    @IBOutlet weak var questionContainer: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var categoryContainer: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet var cardView: UIView!
    
    public static func initWithClue(clue: Clue) -> CardView{
        let newFileOwnerView = CardView()
        newFileOwnerView.clue = clue
        newFileOwnerView.setClueLabels(clue: clue)
        newFileOwnerView.setClueColors(containter: BBColor.cardWhite, textColor: BBColor.black)
        return newFileOwnerView
    }
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        Bundle.main.loadNibNamed("CardView", owner: self, options: nil)
        self.addSubview(self.cardView)
        cardView.frame = self.bounds
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("CardView", owner: self, options: nil)
        self.addSubview(self.cardView)
        cardView.frame = self.bounds
    }

    public func setClueLabels(clue: Clue) -> Void {
        self.clue = clue
        self.categoryLabel.text = clue.categoryTitle().titleize()
        self.questionLabel.text = clue.question
        self.showing = CardViewState.question
    }
    
    public func setClueColors(containter: UIColor, textColor: UIColor) -> Void {
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
        UIView.animate(withDuration: (0.16 * 1.61803398875), animations: {
            if toShow == CardViewState.question {
                self.showQuestion()
            } else if toShow == CardViewState.answer {
                self.showAnswer()
            }
        })
    }

    public func showAnswer() -> Void {
        UIView.animate(withDuration: (0.16 * 1.61803398875), animations: {
            self.questionLabel.text = self.clue?.answer
            self.setCardTextColors(color: BBColor.cardWhite)
            self.setContainerColors(color: BBColor.tcSeafoamBlue)
            self.holdForAnswerLabel.textColor = BBColor.tcLightgreytext
            self.holdForAnswerLabel.isHidden = true
            self.showing = CardViewState.answer
        })
    }
    
    public func showQuestion() -> Void {
        UIView.animate(withDuration: (0.16 * 1.61803398875), animations: {
            self.questionLabel.text = self.clue?.question
            self.setCardTextColors(color: BBColor.black)
            self.setContainerColors(color: BBColor.cardWhite)
            self.holdForAnswerLabel.isHidden = false
            self.showing = CardViewState.question
        })
    }
}
