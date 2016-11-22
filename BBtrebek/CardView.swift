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
        if self.alpha != 0 {
            self.alpha = 0
        }
        perform()
        self.alpha = 1
    }
    
    public func toggleAnswer() {
        UIView.animate(withDuration: (0.10 * 1.61803398875), animations: {
            if self.showing == CardViewState.question {
                self.questionLabel.text = self.clue?.answer
                self.setCardTextColors(color: BBColor.cardWhite)
                self.setContainerColors(color: BBColor.tcSeafoamBlue)
                self.showing = CardViewState.answer
            } else if self.showing == CardViewState.answer {
                self.questionLabel.text = self.clue?.question
                self.showing = CardViewState.question
                self.setCardTextColors(color: BBColor.black)
                self.setContainerColors(color: BBColor.cardWhite)
            }
        })
    }
    

    func valueText() -> String {
        var text: String = ""
        if self.clue?.value != nil {
            text = String(describing: self.clue!.value!)
        }
        return text
    }
}
