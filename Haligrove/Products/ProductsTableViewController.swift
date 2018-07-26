//
//  ProductsTableViewController.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-26.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit

class ProductsTableViewController: UITableViewController {
    
    struct ProductsInfo {
        var image: String?
        var title: String?
    }
    
    let products = [
        ProductsInfo(image: "strainsIcon", title: "Strains"),
        ProductsInfo(image: "hashIcon", title: "Hash"),
        ProductsInfo(image: "extractsIcon", title: "Extracts"),
        ProductsInfo(image: "ediblesIcon", title: "Edibles"),
        ProductsInfo(image: "paraphernaliaIcon", title: "Paraphernalia")
    ]
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        tableView.reloadData()
    }
    
    fileprivate func setupTableView() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationController?.navigationBar.barStyle = .black
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        tableView.register(ProductsCell.self, forCellReuseIdentifier: "ProductsTableView")
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screen = view.frame.height
        let navBar = UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height)!
        let tabBar = tabBarController?.tabBar.frame.size.height
        return (screen - navBar - tabBar!) / 5
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductsTableView", for: indexPath) as! ProductsCell
        guard let image = products[indexPath.row].image else { return cell }
        cell.productImageView.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
        cell.productLabel.text = products[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = products[indexPath.row]
        if selectedCell.title == "Strains" {
            let strainsController = StrainsViewController()
            self.navigationController?.pushViewController(strainsController, animated: true)
        }
        
        if selectedCell.title == "Hash" {
            let hashController = HashViewController()
            self.navigationController?.pushViewController(hashController, animated: true)
        }
        
        if selectedCell.title == "Extracts" {
            let extractsController = ExtractsViewController()
            self.navigationController?.pushViewController(extractsController, animated: true)
        }
        
        if selectedCell.title == "Edibles" {
            let ediblesController = EdiblesViewController()
            self.navigationController?.pushViewController(ediblesController, animated: true)
        }
        
        if selectedCell.title == "Paraphernalia" {
            let paraphernaliaController = ParaphernaliaViewController()
            self.navigationController?.pushViewController(paraphernaliaController, animated: true)
        }
    }
    
}

