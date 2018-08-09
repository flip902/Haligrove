//
//  SalesViewController.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-30.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit

private let reuseIdentifier = "salesCell"

class SalesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, PopoverDelegate {
    
    var salesItems = [Product]()
    private let urlString = "http://app.haligrove.com/sales.json"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(SalesCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ApiService.shared.fetchJson(from: urlString) { [weak self] (data: [Product]) in
            self?.salesItems = data
            self?.collectionView?.reloadData()
        }
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationController?.navigationBar.tintColor = .gray
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return salesItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SalesCell
        
        let salesItem = salesItems[indexPath.row]
        cell.setupCell(salesItem: salesItem)
        cell.salesPopoverDelegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width)
        let height = (width / 2)
        return CGSize(width: width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = salesItems[indexPath.row]
        didHandlePopover(product: product)
    }
    
    let salesPopover = SalesPopover.instance
    func didHandlePopover(product: Product) {
        salesPopover.showPopover(product: product)
    }

}
