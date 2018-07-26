//
//  Popover.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-26.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit

class Popover: NSObject, UITextFieldDelegate {
    
    // MARK: - Properties
    let fadeView = UIView()
    var popoverView: UIView = UIView()
    let productNameLabel = UILabel()
    let howManyLabel = UILabel()
    let likeToOrderLabel = UILabel()
    let popoverTextField = UITextField()
    var priceLabel = UILabel()
    var product: Product?
    
    lazy var fadeViewDismissViewTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
    lazy var popoverViewDismissKeyboardTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.tintColor = #colorLiteral(red: 0.7163612247, green: 0.1086136475, blue: 0.1066852286, alpha: 1)
        button.titleLabel?.font = Font(.installed(.bakersfieldBold), size:.custom(22)).instance
        button.layer.cornerRadius = 5
        button.layer.borderColor = #colorLiteral(red: 0.7163612247, green: 0.1086136475, blue: 0.1066852286, alpha: 1)
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        button.titleLabel?.font = Font(.installed(.bakersfieldBold), size:.custom(22)).instance
        button.layer.cornerRadius = 5
        button.layer.borderColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(submitToCart), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Object Methods
    func showPopover(product: Product) {
        // TODO: - Refactor this Massive Method
        self.product = product
        if let window = UIApplication.shared.keyWindow {
            fadeView.backgroundColor = UIColor(white: 0, alpha: 0.75)
            fadeView.frame = window.frame
            fadeView.alpha = 0
            fadeView.addGestureRecognizer(fadeViewDismissViewTapGesture)
            
            popoverView.frame = CGRect(x: window.center.x - 150, y: window.frame.height, width: 300, height: 300)
            popoverView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            popoverView.layer.cornerRadius = 5
            popoverView.addGestureRecognizer(popoverViewDismissKeyboardTapGesture)
            
            howManyLabel.text = "How many grams of"
            howManyLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            howManyLabel.textAlignment = .center
            howManyLabel.font = Font(.installed(.bakersfieldBold), size: .custom(22)).instance
            
            productNameLabel.text = product.name
            productNameLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            productNameLabel.textAlignment = .center
            productNameLabel.font = Font(.installed(.bakersfieldBold), size: .custom(33)).instance
            productNameLabel.adjustsFontSizeToFitWidth = true
            productNameLabel.layer.shadowColor = #colorLiteral(red: 0.07843137255, green: 0.06666666667, blue: 0.05098039216, alpha: 1)
            productNameLabel.layer.shadowRadius = 1.0
            productNameLabel.layer.shadowOpacity = 1.0
            productNameLabel.layer.shadowOffset = CGSize(width: 3, height: 3)
            productNameLabel.layer.masksToBounds = true
            
            likeToOrderLabel.text = "would you like to order?"
            likeToOrderLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            likeToOrderLabel.textAlignment = .center
            likeToOrderLabel.numberOfLines = 0
            likeToOrderLabel.font = Font(.installed(.bakersfieldBold), size: .custom(22)).instance
            
            popoverTextField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            popoverTextField.layer.borderWidth = 1
            popoverTextField.layer.cornerRadius = 15
            popoverTextField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            popoverTextField.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            popoverTextField.font = Font(.installed(.bakersfieldBold), size: .custom(33)).instance
            popoverTextField.isUserInteractionEnabled = true
            popoverTextField.placeholder = "Qty" // "\(product.id ?? "")"
            popoverTextField.keyboardType = UIKeyboardType.numbersAndPunctuation
            self.popoverTextField.delegate = self
            popoverTextField.textAlignment = .center
            popoverTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: popoverTextField.frame.height))
            popoverTextField.leftViewMode = .always
            popoverTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: popoverTextField.frame.height))
            popoverTextField.rightViewMode = .always
            popoverTextField.adjustsFontSizeToFitWidth = true
            popoverTextField.addTarget(self, action: #selector(Popover.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
            
            priceLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            priceLabel.textAlignment = .center
            priceLabel.font = Font(.installed(.bakersfieldBold), size: .custom(28)).instance
            guard let textEntry = popoverTextField.text else { return }
            priceLabel.text = "Price: $\(Int(calculatePrice(entry: textEntry)))"
            
            let stackView = UIStackView(arrangedSubviews: [howManyLabel, productNameLabel, likeToOrderLabel])
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.spacing = 8.0
            
            window.addSubview(fadeView)
            window.addSubview(popoverView)
            popoverView.addSubview(stackView)
            popoverView.addSubview(popoverTextField)
            popoverView.addSubview(priceLabel)
            popoverView.addSubview(cancelButton)
            popoverView.addSubview(submitButton)
            
            stackView.anchor(top: popoverView.topAnchor, right: popoverView.rightAnchor, bottom: nil, left: popoverView.leftAnchor, paddingTop: 8, paddingRight: 8, paddingBottom: 0, paddingLeft: 8, width: 0, height: 0)
            popoverTextField.anchor(top: stackView.bottomAnchor, right: nil, bottom: nil, left: nil, paddingTop: 8, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 55)
            popoverTextField.centerXAnchor.constraint(equalTo: popoverView.centerXAnchor).isActive = true
            priceLabel.anchor(top: popoverTextField.bottomAnchor, right: popoverView.rightAnchor, bottom: nil, left: popoverView.leftAnchor, paddingTop: 8, paddingRight: 8, paddingBottom: 0, paddingLeft: 8, width: 0, height: 0)
            cancelButton.anchor(top: nil, right: nil, bottom: popoverView.bottomAnchor, left: popoverView.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 16, paddingLeft: 16, width: (popoverView.frame.width / 2) - 48, height: 0)
            submitButton.anchor(top: nil, right: popoverView.rightAnchor, bottom: popoverView.bottomAnchor, left: nil, paddingTop: 0, paddingRight: 16, paddingBottom: 16, paddingLeft: 0, width: (popoverView.frame.width / 2) - 48, height: 0)
            
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: [.curveEaseOut], animations: {
                self.fadeView.alpha = 1
                self.popoverView.frame = CGRect(x: window.center.x - 150, y: window.center.y - 150, width: 300, height: 300)
            }, completion: nil)
        }
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
            self.popoverTextField.text = ""
        }
    }
    
    func calculatePrice(entry: String) -> Float {
        guard let pricePerOunce = product?.pricePerOunce else { return 0 }
        guard let intEntry = Int(entry) else { return 0}
        guard let product = product else { return 0}
        guard let priceOfFive = product.priceForFive else { return 0 }
        guard let pricePerGram = product.pricePerGram else { return 0 }
        
        var price = 0
        
        switch intEntry {
        case let val where val > 28:
            price = Int(pricePerOunce / 28)
            return Float(intEntry * price)
        case let val where val == 28:
            return pricePerOunce
        case let val where val < 28 && val > 5:
            price = Int(priceOfFive) / 5
            return Float(intEntry * price)
        case let val where val == 5:
            price = Int(priceOfFive)
            return Float(price)
        case let val where val < 5:
            price = Int(pricePerGram)
            return Float(intEntry * price)
        default:
            return 0
        }
    }
    
    @objc func submitToCart() {
        guard let asInt = Int(popoverTextField.text!) else { return }
        if asInt <= 0 { return }
        guard let name = product?.name else { return }
        guard let qty = popoverTextField.text else { return }
        let priceToPutInCart = calculatePrice(entry: qty)
        
        let cartItem = CartItem(id: 1, name: name, qty: Int(qty)!, price: priceToPutInCart)
        
        print("Added \(cartItem.qty) grams of \(cartItem.name) with a price of $\(cartItem.price) to Cart")
        
        // TODO: - Submit order to Cart
        CartManager.instance.addItem(item: cartItem)
        
        // TODO: - dismiss popover and animate into Cart
        
        // TODO: - display item badge in Cart tab
        
    }
    
    // MARK: - Init
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: NSNotification.Name.UIKeyboardWillHide
            , object: nil)
    }
    
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.popoverView.frame.origin.y -= (100)
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.popoverView.frame.origin.y += (100)
        }
    }
    
    @objc func hideKeyboard() {
        popoverView.endEditing(true)
    }
    
    // MARK: - textField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = popoverTextField.text else { return true }
        let length = (text.count) - range.length + string.count
        guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) && length <= 3 else {
            return false
        }
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        priceLabel.text = "Price: $\(Int(calculatePrice(entry: text)))"
        let isValid = text.count > 0
        if isValid {
            submitButton.isEnabled = true
        } else {
            submitButton.isEnabled = false
        }
    }
}



