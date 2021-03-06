//
//  CartViewController.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-26.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit
import MessageUI

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    // MARK: - Class Properties
    var cartTableView: UITableView!
    let cartIdentifier = "cartIdentifier"
    
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
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }()
    
    // TODO: - Fix label bouncing when cell is deleted
    var totalCostsLabel: UILabel = {
        let label = UILabel()
        label.font = Font(.installed(.bakersfieldBold), size: .custom(32.0)).instance
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.textAlignment = .right
        return label
    }()
    
    // Number Formatter
    lazy var itemPriceFormatter: NumberFormatter = {
        let itemPriceFormatter = NumberFormatter()
        itemPriceFormatter.numberStyle = .currency
        itemPriceFormatter.locale = Locale.current
        return itemPriceFormatter
    }()
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkEmptyStateOfCart()
        animateTableView()
        updateTotalCostsLabel()
    }
    
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
        cartTableView?.delegate = self
        cartTableView?.dataSource = self
        view.addSubview(cartTableView)
        cartTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
        emptyView.addSubview(defaultLabel)
        view.addSubview(emptyView)
        emptyView.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
        defaultLabel.anchor(top: emptyView.topAnchor, right: emptyView.rightAnchor, bottom: emptyView.bottomAnchor, left: emptyView.leftAnchor, paddingTop: 0, paddingRight: 16, paddingBottom: 0, paddingLeft: 16, width: 0, height: 0)
        cartTableFooterView.addSubview(totalCostsLabel)
        totalCostsLabel.anchor(top: cartTableFooterView.topAnchor, right: cartTableFooterView.rightAnchor, bottom: cartTableFooterView.bottomAnchor, left: cartTableFooterView.leftAnchor, paddingTop: 8, paddingRight: 8, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
    }
    
    func checkEmptyStateOfCart() {
        setEmptyViewVisible(CartManager.instance.numberOfItemsInCart() == 0)
    }
    
    fileprivate func animateTableView() {
        cartTableView.reloadWithAnimation()
        cartTableFooterView.alpha = 0
        UIView.animate(withDuration: 1.3) {
            self.cartTableFooterView.alpha = 1
        }
    }
    
    func updateTotalCostsLabel() {
        totalCostsLabel.text = "Total: \(itemPriceFormatter.string(from: NSNumber(value: CartManager.instance.totalPriceInCart())) ?? "")"
    }
    
    func clearCart() {
        CartManager.instance.clearCart()
        cartTableView.reloadData()
        UIApplication.mainTabBarController()?.viewControllers?[4].tabBarItem.badgeValue = nil
        setEmptyViewVisible(true)
    }
    
    func setEmptyViewVisible(_ visible: Bool) {
        emptyView.isHidden = !visible
        if visible {
            clearButton.isEnabled = false
            submitButton.isEnabled = false
            self.view.bringSubview(toFront: emptyView)
            self.tabBarItem.badgeValue = nil
            
        } else {
            clearButton.isEnabled = true
            submitButton.isEnabled = true
            self.view.sendSubview(toBack: emptyView)
        }
    }
    
    // TODO: - Submit order to firebase and send order to email
    @objc func submitButtonPressed() {
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
    
    // MARK: - tableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartManager.instance.numberOfItemsInCart()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView?.dequeueReusableCell(withIdentifier: cartIdentifier, for: indexPath) as! CartCell
        let item = CartManager.instance.itemAtIndexPath(indexPath: indexPath)
        cell.itemNameLabel.text = item.name
        cell.itemPriceLabel.text = itemPriceFormatter.string(from: NSNumber(value: item.price))
        cell.itemCount.text = String(item.qty)
        tableView.separatorStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = CartManager.instance.itemAtIndexPath(indexPath: indexPath)
            let successful = CartManager.instance.removeItem(item: item)
            if successful == true {
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .right)
                tableView.endUpdates()
                if CartManager.instance.numberOfItemsInCart() == 0 {
                    UIApplication.mainTabBarController()?.viewControllers?[4].tabBarItem.badgeValue = nil
                } else {
                    UIApplication.mainTabBarController()?.viewControllers?[4].tabBarItem.badgeValue = String(CartManager.instance.numberOfItemsInCart())
                }
            }
            checkEmptyStateOfCart()
            updateTotalCostsLabel()
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            tableView.dataSource?.tableView!(tableView, commit: .delete, forRowAt: indexPath)
            return
        }
        deleteButton.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        return [deleteButton]
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return cartTableFooterView
    }
}
