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
    
    @IBOutlet weak var questionContainer: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet var cardView: UIView!
    public static func initWithClue(clue: Clue) -> CardView{
        let newFileOwnerView = CardView()
        newFileOwnerView.clue = clue
        newFileOwnerView.setClueLabels(clue: clue)
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
        self.valueLabel.text = String(clue.value)
        self.categoryLabel.text = clue.categoryTitle().titleize()
        self.questionLabel.text = clue.question
        self.questionLabel.textColor = BBColor.white
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(self.handleTap(sender:))
            
        )
        questionContainer.addGestureRecognizer(tap)
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if self.questionLabel.text == self.clue?.question {
                self.questionLabel.text = self.clue?.answer
                self.questionLabel.textColor = BBColor.valueGold
            } else {
                self.questionLabel.text = self.clue?.question
                self.questionLabel.textColor = BBColor.white
            }
        }
    }
}
