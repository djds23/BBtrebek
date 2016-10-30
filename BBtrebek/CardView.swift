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
        let borderBezel = self.roundedBezel(rect: rect)
        let backgroundRect = self.bezzelRect(outerHeight: rect.height, outerWidth: rect.width)
        let outerBezzelPath = self.roundedBezel(rect: backgroundRect)
        let innerRect = self.innerRect(outerRect: backgroundRect)
        let innerBezzelPath = self.roundedBezel(rect: innerRect)
        color.set()
        borderBezel.stroke()
        outerBezzelPath.stroke()
        innerBezzelPath.stroke()
        let categoryFrame = self.categoryRect(outerRect: innerRect)
        self.setClueLabels(cardRect:
            categoryRect(outerRect: categoryFrame)
        )
        
    }

    private func setClueLabels(cardRect: CGRect) -> Void {
        if self.clue != nil {
            let unwrappedClue = self.clue!
            let textAtrributes = [
                NSFontAttributeName: BBFont.main
            ]
            let categoryText =  unwrappedClue.categoryTitle()
            var frame = categoryText.boundingRect(
                with: cardRect.size,
                attributes: textAtrributes,
                context: nil
            )
            frame.origin.x = cardRect.origin.x
            frame.origin.y = cardRect.origin.y
            
            let categoryLabel = UILabel(frame: frame)
            categoryLabel.text = categoryText
            categoryLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            categoryLabel.numberOfLines = 3
            self.addSubview(categoryLabel)
            
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

    private func innerRect(outerRect: CGRect) -> CGRect {
        return CGRect(
            x: outerRect.origin.x,
            y: outerRect.origin.y,
            width: outerRect.width,
            height: outerRect.height * CGFloat(0.25)
        )
    }
    
    private func categoryRect(outerRect: CGRect) -> CGRect {
        return CGRect(
            x: outerRect.origin.x + 12,
            y: outerRect.origin.y + 10,
            width: outerRect.width - 20,
            height: outerRect.height - (outerRect.height * 0.75)
        )
        
    }
    private func roundedBezel(rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: CGFloat(10))
        path.lineWidth = CGFloat(10)
        return path
    }
}
