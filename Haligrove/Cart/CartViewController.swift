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
    var emptyView = UIView()
    var totalCostsLabel = UILabel()
    lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var clearButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Clear All", style: .plain, target: self, action: #selector(clearAllButtonPressed))
        return button
    }()
    
    let cartTableFooterView: UIView = {
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
            self.view.bringSubview(toFront: emptyView)
        } else {
            clearButton.isEnabled = true
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
        cartTableView.reloadData()
        updateTotalCostsLabel()
    }
    
}
