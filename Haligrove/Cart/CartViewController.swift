//
//  CartViewController.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-26.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var cartTableView: UITableView!
    let cartIdentifier = "cartIdentifier"
    
    // TODO: - Set attributes on properties and add them to UI
    var totalCostsLabel = UILabel()
    
    var emptyView: UIView = {
        let defaultView = UIView()
        defaultView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return defaultView
    }()
    
    let defaultLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Font(.installed(.bakersfieldBold), size: .custom(18.0)).instance
        label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.textAlignment = .center
        
        let imageSize = CGRect(x: 0, y: -5, width: 30, height: 30)
        let addToCartButtonImage = UIImage(named: "buy")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = addToCartButtonImage
        imageAttachment.bounds = imageSize
        let completeText = NSMutableAttributedString(string: "")
        let textBeforeImage = NSMutableAttributedString(string: "Press the")
        let attachmentImageString = NSAttributedString(attachment: imageAttachment)
        let textAfterImage = NSMutableAttributedString(string: " button in the product foldout to add items to Cart")
        completeText.append(textBeforeImage)
        completeText.append(attachmentImageString)
        completeText.append(textAfterImage)
        
         label.attributedText = completeText
        
        
        return label
    }()
    
    lazy var submitButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitButtonPressed))
        let font = Font(.installed(.bakersfieldLight), size: .custom(18)).instance
        button.setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font], for: .disabled)
        return button
    }()
    
    lazy var clearButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Clear All", style: .plain, target: self, action: #selector(clearAllButtonPressed))
        let font = Font(.installed(.bakersfieldLight), size: .custom(18)).instance
        button.setTitleTextAttributes([NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): font], for: .disabled)
        return button
    }()
    
    let cartTableFooterView: UIView = {
        // TODO: - Put total in here?
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }()
    
    // MARK: - Class Methods
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationController?.navigationBar.tintColor = .gray
        navigationController?.navigationBar.barStyle = .black
        navigationItem.rightBarButtonItem = submitButton
        navigationItem.leftBarButtonItem = clearButton
    }
    
    func setupTableView() {
        cartTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), style: .plain)
        cartTableView.tableFooterView = cartTableFooterView
        cartTableView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        cartTableView?.register(CartCell.self, forCellReuseIdentifier: cartIdentifier)
        cartTableView.estimatedRowHeight = 100
        cartTableView.rowHeight = UITableViewAutomaticDimension
        cartTableView?.delegate = self
        cartTableView?.dataSource = self
        view.addSubview(cartTableView)
        cartTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
        emptyView.addSubview(defaultLabel)
        view.addSubview(emptyView)
        emptyView.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
        defaultLabel.anchor(top: emptyView.topAnchor, right: emptyView.rightAnchor, bottom: emptyView.bottomAnchor, left: emptyView.leftAnchor, paddingTop: 0, paddingRight: 16, paddingBottom: 0, paddingLeft: 16, width: 0, height: 0)
    }
    
    // Number Formatter
    lazy var itemPriceFormatter: NumberFormatter = {
        let itemPriceFormatter = NumberFormatter()
        itemPriceFormatter.numberStyle = .currency
        itemPriceFormatter.locale = Locale.current
        return itemPriceFormatter
    }()
    
    @objc func submitButtonPressed() {
        // TODO: - Submit order to firebase and send order to email
        print("submit button pressed")
    }
    
    @objc func clearAllButtonPressed() {
        let alertView = UIAlertController(title: "Clear all?", message: "Do you really want to clear all items from your cart?", preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alertView.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { (alertAction) -> Void in
            self.clearCart()
        }))
        present(alertView, animated: true, completion: nil)
    }
    
    func clearCart() {
        CartManager.instance.clearCart()
        cartTableView.reloadData()
        setEmptyViewVisible(true)
    }
    
    func setEmptyViewVisible(_ visible: Bool) {
        emptyView.isHidden = !visible
        if visible {
            clearButton.isEnabled = false
            submitButton.isEnabled = false
            self.view.bringSubview(toFront: emptyView)
            
        } else {
            clearButton.isEnabled = true
            submitButton.isEnabled = true
            self.view.sendSubview(toBack: emptyView)
        }
    }
    
    func updateTotalCostsLabel() {
        totalCostsLabel.text = itemPriceFormatter.string(from: NSNumber(value: CartManager.instance.totalPriceInCart()))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartManager.instance.numberOfItemsInCart()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView?.dequeueReusableCell(withIdentifier: cartIdentifier, for: indexPath) as! CartCell
        let item = CartManager.instance.itemAtIndexPath(indexPath: indexPath)
        cell.itemNameLabel.text = item.name
        cell.itemPriceLabel.text = itemPriceFormatter.string(from: NSNumber(value: item.price))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = CartManager.instance.itemAtIndexPath(indexPath: indexPath)
            let successful = CartManager.instance.removeItem(item: item)
            if successful == true {
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .right)
                tableView.endUpdates()
            }
            checkEmptyStateOfCart()
        }
    }
    
    func checkEmptyStateOfCart() {
        setEmptyViewVisible(CartManager.instance.numberOfItemsInCart() == 0)
    }
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkEmptyStateOfCart()
        cartTableView.reloadWithAnimation()
        updateTotalCostsLabel()
    }
    
}
