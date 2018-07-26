//
//  ParaphernaliaViewController.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-26.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit

// TODO: - Refactor All Product viewControllers into template using generics
class ParaphernaliaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ParaphernaliaFavoriteDelegate {
    
    // MARK: - Property Declarations
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    var paraphernaliaTableView: UITableView!
    var products = [Product]()
    
    let closeHeight: CGFloat = 136
    let openHeight: CGFloat = 375
    var rowsCount: Int = 50
    var itemHeight: [CGFloat] = []
    
    var reuseIdentifier = "paraphernaliaCell"
    let urlString = "http://app.haligrove.com/paraphernaliaData.json"
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ApiService.shared.fetchJson(from: urlString) { [weak self](data: [Product]) in
            self?.products = data
            self?.activityIndicator.stopAnimating()
            self?.paraphernaliaTableView.reloadData()
        }
    }
    
    // MARK: - Class Methods
    func setupTableView() {
        navigationItem.title = "Paraphernalia"
        paraphernaliaTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), style: .plain)
        paraphernaliaTableView.register(ParaphernaliaCell.self, forCellReuseIdentifier: reuseIdentifier)
        paraphernaliaTableView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        paraphernaliaTableView.dataSource = self
        paraphernaliaTableView.delegate = self
        paraphernaliaTableView.separatorStyle = .none
        self.view.addSubview(paraphernaliaTableView)
        self.view.addSubview(activityIndicator)
        self.view.bringSubview(toFront: activityIndicator)
        activityIndicator.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        paraphernaliaTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
    }
    
    func setup() {
        itemHeight = Array(repeating: closeHeight, count: rowsCount)
        paraphernaliaTableView.estimatedRowHeight = closeHeight
        paraphernaliaTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        paraphernaliaTableView.reloadData()
    }
    
    // MARK: - Delegate Methods
    func didTapParaphernaliaFavoritesButton(in cell: ParaphernaliaCell) {
        guard let indexTapped = paraphernaliaTableView.indexPath(for: cell) else { return }
        let thisProduct = products[indexTapped.row]
        guard let hasFavorited = thisProduct.isFavorite else { return }
        hasFavorited ? removeFromFavorites(thisProduct) : addToFavorites(thisProduct)
        cell.favoritesButton.imageView?.tintColor = hasFavorited ? #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) : .orange
        products[indexTapped.row].isFavorite = !hasFavorited
    }
    
    func removeFromFavorites(_ product: Product) {
        UserDefaults.standard.deleteProduct(product: product, key: UserDefaults.favoriteKey)
    }
    
    func addToFavorites(_ product: Product) {
        var listOfProducts = UserDefaults.standard.savedProducts(for: UserDefaults.favoriteKey)
        listOfProducts.append(product)
        let data = NSKeyedArchiver.archivedData(withRootObject: listOfProducts)
        UserDefaults.standard.set(data, forKey: UserDefaults.favoriteKey)
        showBadgeHighlight()
    }
    
    fileprivate func showBadgeHighlight() {
        UIApplication.mainTabBarController()?.viewControllers?[0].tabBarItem.badgeColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        UIApplication.mainTabBarController()?.viewControllers?[0].tabBarItem.badgeValue = "new"
    }
    
    // MARK: - TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as ParaphernaliaCell = cell else { return }
        if itemHeight[indexPath.row] == closeHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = paraphernaliaTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ParaphernaliaCell
        var product: Product
        cell.delegate = self
        
        product = products[indexPath.row]
        
        let savedProducts = UserDefaults.standard.savedProducts(for: UserDefaults.favoriteKey)
        let hasFavorited = savedProducts.index(where: { $0.name == product.name && $0.src == product.src }) != nil
        if hasFavorited {
            cell.favoritesButton.imageView?.tintColor = .orange
            product.isFavorite = true
        }
        guard let isFavorite = product.isFavorite else { return cell }
        cell.favoritesButton.imageView?.tintColor = isFavorite ? .orange : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cell.setupFoldingCell(product: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return itemHeight[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ParaphernaliaCell
        if cell.isAnimating() {
            return
        }
        var duration = 0.0
        if itemHeight[indexPath.row] == closeHeight {
            itemHeight[indexPath.row] = openHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            itemHeight[indexPath.row] = closeHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 1.1
        }
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
}

// MARK: - Protocol
protocol ParaphernaliaFavoriteDelegate: class {
    func didTapParaphernaliaFavoritesButton(in cell: ParaphernaliaCell)
}
