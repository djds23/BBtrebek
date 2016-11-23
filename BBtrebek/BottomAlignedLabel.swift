//
//  BottomAlignedLabel.swift
//  BBtrebek
//
//  Created by Dean Silfen on 11/22/16.
//  Copyright © 2016 Dean Silfen. All rights reserved.
//

import UIKit

public class BottomAlignedLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func drawText(in rect: CGRect) {
        let height = self.sizeThatFits(rect.size).height
        let y = rect.origin.y + rect.height - height
        super.drawText(in: CGRect(x: rect.origin.x, y: y, width: rect.width, height: height))
    }
}
