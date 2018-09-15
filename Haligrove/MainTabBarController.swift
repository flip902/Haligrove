//
//  MainTabBarController.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-25.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
                return
            }
        }
    }
    
    //TODO: - reconstruct each navController without default NavController
    func setupViewControllers() {
        
        // Dependency Injection
        let apiService = ApiService.shared
        // Home
        let homeNavController = templateController(for: HomeViewController(apiService: apiService), title: "Home", image: #imageLiteral(resourceName: "home"))
        
        // Products
        let productsNavController = templateController(for: ProductsTableViewController(), title: "Products", image: #imageLiteral(resourceName: "strains"))
        
        // Info
        let infoNavController = templateController(for: MessageTableViewController(), title: "Message", image: #imageLiteral(resourceName: "about"))
        
        // Sales
        let salesNavController = templateController(for: SalesViewController(collectionViewLayout: UICollectionViewFlowLayout()), title: "Sales", image: #imageLiteral(resourceName: "money"))
        
        // Cart
        let cartNavController = templateController(for: CartViewController(), title: "Cart", image: #imageLiteral(resourceName: "shopping_cart"))
        
        tabBar.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        tabBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tabBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        viewControllers = [homeNavController, productsNavController, infoNavController, salesNavController, cartNavController]
        
    }
    
    fileprivate func templateController(for rootViewController: UIViewController = UIViewController(), title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        return navController
    }
}


