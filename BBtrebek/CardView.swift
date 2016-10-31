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
    let padding = CGFloat(12)
    
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
        self.setClueLabels(rect: innerRect)
        
    }

    private func setClueLabels(rect: CGRect) -> Void {
        if self.clue != nil {
            let unwrappedClue = self.clue!
            let categoryText =  unwrappedClue.categoryTitle()
            
            let categoryFrame = self.categoryRect(outerRect: rect)
            let newCategoryLabel = self.categoryLabel(frame: categoryFrame, categoryText: categoryText)
            
            let valueFrame = self.valueRect(outerRect: rect)
            let newValueLable = self.valueLabel(frame: valueFrame, value: unwrappedClue.value)
            
            self.addSubview(newCategoryLabel)
            self.addSubview(newValueLable)
            
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
            x: outerRect.origin.x + self.padding,
            y: outerRect.origin.y + self.padding,
            width: outerRect.width - 20,
            height: outerRect.height - (outerRect.height * 0.50)
        )
    }
    
    private func valueRect(outerRect: CGRect) -> CGRect {
        return CGRect(
            x: outerRect.origin.x + self.padding,
            y: (outerRect.origin.y + outerRect.height) + self.padding,
            width: outerRect.width,
            height: outerRect.height * CGFloat(0.25)
        )
    }

    private func roundedBezel(rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: CGFloat(10))
        path.lineWidth = CGFloat(10)
        return path
    }
    
    private func categoryLabel(frame: CGRect, categoryText: String) -> UILabel {
        let categoryLabel = UILabel(frame: frame)
        categoryLabel.text = categoryText
        categoryLabel.textColor = BBColor.plainWhite
        categoryLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        categoryLabel.numberOfLines = 3
        categoryLabel.textAlignment = NSTextAlignment.center
        categoryLabel.sizeToFit()
        return categoryLabel
    }
    
    private func valueLabel(frame: CGRect, value: Int) -> UILabel  {
        let valueLabel = UILabel(frame: frame)
        valueLabel.text = String(value)
        valueLabel.textColor = BBColor.valueText
        valueLabel.numberOfLines = 1
        valueLabel.textAlignment = NSTextAlignment.center
        valueLabel.sizeToFit()
        return valueLabel
    }
}
