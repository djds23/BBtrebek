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
        self.categoryLabel.text = clue.categoryTitle()
        self.questionLabel.text = clue.question
    }
}
