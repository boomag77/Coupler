//
//  MeaningLabel.swift
//  Coupler
//
//  Created by Sergey on 5/11/23.
//

import UIKit

class MeaningLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var padding = UIEdgeInsets(top: -10, left: 10, bottom: -10, right: 10)

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let paddedBounds = bounds.inset(by: padding)
        let textRect = super.textRect(forBounds: paddedBounds, limitedToNumberOfLines: numberOfLines)
        let unpaddedRect = textRect.inset(by: padding)
        return unpaddedRect
    }

    override func drawText(in rect: CGRect) {
        let paddedRect = rect.inset(by: padding)
        super.drawText(in: paddedRect)
    }

}
