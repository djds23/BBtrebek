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

    enum InView {
        case answer
        case question
    }
    var showing = InView.question
    
    @IBOutlet weak var questionContainer: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var categoryContainer: UIView!
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
        
        self.categoryLabel.text = clue.categoryTitle().titleize()
        self.questionLabel.text = clue.question
        self.questionLabel.textColor = BBColor.black
        self.showing = InView.question

        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(self.handleTap(sender:))
            
        )
        questionContainer.addGestureRecognizer(tap)
    }
    
    public func whileHidden(perform: @escaping ((Void) -> Void)) -> Void{
        if self.alpha != 0 {
            self.alpha = 0
        }
        perform()
        self.alpha = 1
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if self.showing == InView.question {
                self.questionLabel.text = self.clue?.answer
                self.questionLabel.textColor = BBColor.valueGold
                self.showing = InView.answer
            } else if self.showing == InView.answer {
                self.questionLabel.text = self.clue?.question
                self.questionLabel.textColor = BBColor.black
                self.showing = InView.question
            }
        }
    }
    
    func valueText() -> String {
        var text: String = ""
        if self.clue?.value != nil {
            text = String(describing: self.clue!.value!)
        }
        return text
    }
}
