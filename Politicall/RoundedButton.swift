//
//  RoundedButton.swift
//  Politicall
//
//  Created by Sahil Ambardekar on 9/10/16.
//  Copyright © 2016 Pennhacks. All rights reserved.
//

import UIKit

@IBDesignable class RoundedButton: UIView {
    
    
    @IBInspectable var isBorderButton: Bool = false
    var label: UILabel
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        layer.cornerRadius = self.frame.height / 2
        let blue = UIColor(colorLiteralRed: 38 / 255, green: 133 / 255, blue: 169 / 255, alpha: 1)
        layer.backgroundColor = isBorderButton ? UIColor.whiteColor().CGColor : blue.CGColor
        let textColor = !isBorderButton ? UIColor.whiteColor().CGColor : blue.CGColor
        
    }
    
    override init(frame: CGRect) {
        label = UILabel(frame: frame)
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        label = UILabel(frame: CGRectZero)
        super.init(coder: aDecoder)
        label.frame = self.frame
        setupLabel()
    }
}
