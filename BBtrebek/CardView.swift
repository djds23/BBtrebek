//
//  Rect.swift
//  BBtrebek
//
//  Created by Dean Silfen on 10/21/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

public class CardView: UIView {
    
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
        let color: UIColor = BBColor.white
        let innerRect = self.bezzelRect(outerHeight: rect.height, outerWidth: rect.width)
        let bpath: UIBezierPath = UIBezierPath(rect: innerRect)
        color.set()
        bpath.stroke()
    }
    
    private func bezzelRect(outerHeight: CGFloat, outerWidth: CGFloat) -> CGRect {
        return CGRect(
            x: (outerWidth * 0.25),
            y: (outerHeight * 0.25),
            width: (outerWidth * 0.5),
            height: (outerHeight * 0.5)
        )
    }
}


