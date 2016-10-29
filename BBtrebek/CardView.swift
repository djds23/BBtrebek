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
    
    public static func initWithClue(clue: Clue, frame: CGRect) -> CardView{
        let cardView = CardView(frame: frame)
        cardView.clue = clue
        return cardView
    }
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = BBColor.cardBlue
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func draw(_ rect: CGRect) {
        let color: UIColor = BBColor.borderBlack
        let innerRect = self.bezzelRect(outerHeight: rect.height, outerWidth: rect.width)
        let outerBezzelPath = self.outerBezzel(rect: innerRect)
        let innerBezzelPath = self.innerBezzel(rect: innerRect)
        color.set()
        outerBezzelPath.stroke()
        innerBezzelPath.stroke()
        self.setClueLabels()
        
    }

    private func setClueLabels() -> Void {
        if self.clue != nil {
            let unwrappedClue = self.clue!
        }
    }
    
    private func bezzelRect(outerHeight: CGFloat, outerWidth: CGFloat) -> CGRect {
        return CGRect(
            x: (outerWidth * 0.15),
            y: (outerHeight * 0.05),
            width: (outerWidth * 0.7),
            height: (outerHeight * 0.90)
        )
    }

    private func outerBezzel(rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: CGFloat(10))
        path.lineWidth = CGFloat(10)
        return path
    }

    private func innerBezzel(rect: CGRect) -> UIBezierPath {
        let panelRect = CGRect(
            x: rect.origin.x,
            y: rect.origin.y,
            width: rect.width,
            height: rect.height * CGFloat(0.25)
        )
        
        let path = UIBezierPath(roundedRect: panelRect, cornerRadius: CGFloat(10))
        path.lineWidth = CGFloat(10)
        return path
    }
}
