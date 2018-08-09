//
//  RadioButton.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-08-08.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit

@IBDesignable
class RadioButton: UIButton {
    
    @IBInspectable
    var size: CGSize = CGSize(width: 25, height: 25) {
        didSet {
            if size.width > size.height {
                size.height = size.width
            }else{
                 size.width = size.height
            }
            self.frame.size = size
            self.setNeedsLayout()
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var gap: CGFloat = 8 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var buttonColor: UIColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var isOn: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        self.contentMode = .scaleAspectFill
        drawCircles(rect: rect)
    }
    
    // Drawing inner and outer circles
    func drawCircles(rect: CGRect) {
        var path = UIBezierPath()
        path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = path.cgPath
        circleLayer.lineWidth = 3
        circleLayer.strokeColor = buttonColor.cgColor
        circleLayer.fillColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).cgColor
        layer.addSublayer(circleLayer)
        
        if isOn {
            let innerCircleLayer = CAShapeLayer()
            let rectForInnerCircle = CGRect(x: gap, y: gap, width: rect.width - 2 * gap, height: rect.height - 2 * gap)
            innerCircleLayer.path = UIBezierPath(ovalIn: rectForInnerCircle).cgPath
            innerCircleLayer.fillColor = buttonColor.cgColor
            layer.addSublayer(innerCircleLayer)
        }
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.nativeScale
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isOn = !isOn
        self.setNeedsDisplay()
    }
}
