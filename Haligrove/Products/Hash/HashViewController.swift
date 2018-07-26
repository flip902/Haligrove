//
//  HashViewController.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-26.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit
import FoldingCell

// TODO: - Refactor All Product viewControllers into template using generics
class HashViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HashFavoriteDelegate {
    
    // MARK: - Property Declarations
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    var hashTableView: UITableView!
    var hashProducts = [Product]()
    
    let closeHeight: CGFloat = 136
    let openHeight: CGFloat = 375
    var rowsCount: Int = 50
    var itemHeight: [CGFloat] = []
    
    let reuseIdentifier = "hashCell"
    let urlString = "http://app.haligrove.com/hashData.json"
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHashTableView()
        setup()
    }
    
    // MARK: - Class Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ApiService.shared.fetchJson(from: urlString) { [weak self] (data: [Product]) in
            self?.hashProducts = data
            self?.activityIndicator.stopAnimating()
            self?.hashTableView.reloadData()
        }
    }
    
    func setupHashTableView() {
        navigationItem.title = "Hash"
        hashTableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), style: .plain)
        hashTableView.register(HashCell.self, forCellReuseIdentifier: reuseIdentifier)
        hashTableView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        hashTableView.dataSource = self
        hashTableView.delegate = self
        hashTableView.separatorStyle = .none
        self.view.addSubview(hashTableView)
        self.view.addSubview(activityIndicator)
        self.view.bringSubview(toFront: activityIndicator)
        activityIndicator.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        hashTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
    }
    
    private func setup() {
        itemHeight = Array(repeating: closeHeight, count: rowsCount)
        hashTableView.estimatedRowHeight = closeHeight
        hashTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - Delegate Methods
    func didTapHashFavoritesButton(in cell: HashCell) {
        guard let indexTapped = hashTableView.indexPath(for: cell) else { return }
        let thisProduct = hashProducts[indexTapped.row]
        guard let hasFavorited = thisProduct.isFavorite else { return }
        hasFavorited ? removeFromFavorites(thisProduct) : addToFavorites(thisProduct)
        cell.favoritesButton.imageView?.tintColor = hasFavorited ?  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) : .orange
        hashProducts[indexTapped.row].isFavorite = !hasFavorited
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
        return hashProducts.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as HashCell = cell else { return }
        if itemHeight[indexPath.row] == closeHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = hashTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! HashCell
        var hash: Product
        cell.delegate = self
        hash = hashProducts[indexPath.row]
        let savedProducts = UserDefaults.standard.savedProducts(for: UserDefaults.favoriteKey)
        let hasFavorited = savedProducts.index(where: { $0.name == hash.name && $0.src == hash.src }) != nil
        if hasFavorited {
            cell.favoritesButton.imageView?.tintColor = .orange
            hash.isFavorite = true
        }
        guard let isFavorite = hash.isFavorite else { return cell }
        cell.favoritesButton.imageView?.tintColor = isFavorite ? .orange : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cell.setupFoldingCell(product: hash)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return itemHeight[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! HashCell
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

// MARK: - Protocols
protocol HashFavoriteDelegate: class {
    func didTapHashFavoritesButton(in cell: HashCell)
}

