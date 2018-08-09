//
//  SalesPopover.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-08-02.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit

class SalesPopover: NSObject {
    
    static var instance = SalesPopover()
    
    // MARK: - Properties
    let fadeView = UIView()
    lazy var popoverView = UIView()
    lazy var pickItemsLabel = UILabel()
    lazy var radioButton = RadioButton(type: .system)
    var product: Product?
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.tintColor = #colorLiteral(red: 0.7163612247, green: 0.1086136475, blue: 0.1066852286, alpha: 1)
        button.titleLabel?.font = Font(.installed(.bakersfieldBold), size:.custom(28)).instance
        button.layer.cornerRadius = 15
        button.layer.borderColor = #colorLiteral(red: 0.7163612247, green: 0.1086136475, blue: 0.1066852286, alpha: 1)
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        button.titleLabel?.font = Font(.installed(.bakersfieldBold), size:.custom(28)).instance
        button.layer.cornerRadius = 15
        button.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(submitToCart), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    lazy var fadeViewDismissViewTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
    
    override init() {
        super.init()
    }
    
    func showPopover(product: Product) {
        self.product = product
        if let window = UIApplication.shared.keyWindow {
            fadeView.backgroundColor = UIColor(white: 0, alpha: 0.75)
            fadeView.frame = window.frame
            fadeView.alpha = 0
            fadeView.addGestureRecognizer(fadeViewDismissViewTapGesture)
            
            popoverView.frame = CGRect(x: window.center.x - 150, y: window.frame.height, width: 300, height: 300)
            popoverView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            popoverView.layer.cornerRadius = 15
            
            pickItemsLabel.text = "Which sale would you like to add to cart?"
            pickItemsLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            pickItemsLabel.textAlignment = .center
            pickItemsLabel.numberOfLines = 0
            pickItemsLabel.font = Font(.installed(.bakersfieldBold), size: .custom(22)).instance
            
            window.addSubview(fadeView)
            window.addSubview(popoverView)
            popoverView.addSubview(pickItemsLabel)
            
            popoverView.addSubview(cancelButton)
            popoverView.addSubview(submitButton)
            popoverView.addSubview(radioButton)
            
            cancelButton.anchor(top: nil, right: nil, bottom: popoverView.bottomAnchor, left: popoverView.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 16, paddingLeft: 16, width: (popoverView.frame.width / 2) - 48, height: 0)
            submitButton.anchor(top: nil, right: popoverView.rightAnchor, bottom: popoverView.bottomAnchor, left: nil, paddingTop: 0, paddingRight: 16, paddingBottom: 16, paddingLeft: 0, width: (popoverView.frame.width / 2) - 48, height: 0)
            pickItemsLabel.anchor(top: popoverView.safeAreaLayoutGuide.topAnchor, right: popoverView.safeAreaLayoutGuide.rightAnchor, bottom: nil, left: popoverView.safeAreaLayoutGuide.leftAnchor, paddingTop: 8, paddingRight: 8, paddingBottom: 0, paddingLeft: 8, width: 0, height: 0)
            radioButton.anchor(top: pickItemsLabel.bottomAnchor, right: nil, bottom: nil, left: popoverView.leftAnchor, paddingTop: 16, paddingRight: 0, paddingBottom: 0, paddingLeft: 16, width: 0, height: 0)
            
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: [.curveEaseOut], animations: {
                self.fadeView.alpha = 1
                self.popoverView.frame = CGRect(x: window.center.x - 150, y: window.center.y - 150, width: 300, height: 300)
            }, completion: nil)
        }
    }
    
    @objc func submitToCart() {
        
    }
    
    @objc func handleDismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.fadeView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.popoverView.frame = CGRect(x: window.center.x - 150, y: window.frame.height, width: (self.popoverView.frame.width), height: (self.popoverView.frame.height))
            }
        }) { (_) in
            self.popoverView.removeFromSuperview()
            self.fadeView.removeFromSuperview()
        }
    }
    
}
