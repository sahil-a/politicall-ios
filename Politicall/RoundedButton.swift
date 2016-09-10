//
//  RoundedButton.swift
//  Politicall
//
//  Created by Sahil Ambardekar on 9/10/16.
//  Copyright © 2016 Pennhacks. All rights reserved.
//

import UIKit

@IBDesignable class RoundedButton: UIView {
    
    
    @IBInspectable var isBorderButton: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var text: String = "Button" {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var label: UILabel
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        layer.cornerRadius = self.frame.height / 2
        let blue = UIColor(colorLiteralRed: 38 / 255, green: 133 / 255, blue: 169 / 255, alpha: 1)
        let border = UIBezierPath(roundedRect: CGRect(x: 2, y: 2, width: bounds.width - 4, height: bounds.height - 4), cornerRadius: layer.cornerRadius)
        border.lineWidth = 2
        blue.set()
        if isBorderButton {
            border.stroke()
        } else {
            border.fill()
        }
        setupLabel()
        super.drawRect(rect)
    }
    
    override init(frame: CGRect) {
        label = UILabel(frame: frame)
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        label = UILabel(frame: CGRectZero)
        super.init(coder: aDecoder)
        label.frame = self.frame
        setupLabel()
    }
    
    func setupLabel() {
        label.frame = CGRect(x: 0, y: (frame.height / 2) - 10, width: frame.width, height: 20)
        label.text = text
        label.removeFromSuperview()
        let blue = UIColor(colorLiteralRed: 38 / 255, green: 133 / 255, blue: 169 / 255, alpha: 1)
        let textColor = !isBorderButton ? UIColor.whiteColor() : blue
        label.textColor = textColor
        label.textAlignment = .Center
        addSubview(label)
    }
}
