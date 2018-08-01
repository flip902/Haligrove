//
//  HomeViewController.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-26.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Property Declarations
    var favoritedProducts = UserDefaults.standard.savedProducts(for: UserDefaults.favoriteKey)
    var newArrrivals = [Product]()
    var specials = [Product]()
    var suggestions = [Product]()
    
    let apiService: ApiService
    
    init(apiService: ApiService) {
        self.apiService = apiService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .clear
        return sv
    }()
    
    let shim: UILabel = {
        let label = UILabel()
        label.text = " "
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let homeFavoritesCellIdentifier = "favoritesCell"
    fileprivate let newArrivalsCellIdentifier = "newArrivalsCell"
    fileprivate let specialsCellIdentifier = "specialsCell"
    fileprivate let suggestionsCellIdentifier = "suggestionsCell"
    
    let newArrivalsUrl = "http://app.haligrove.com/newArrivals.json"
    let specialsUrl = "http://app.haligrove.com/specials.json"
    let suggestionsUrl = "http://app.haligrove.com/suggestions.json"
    
    // Favorites
    let homeFavoritesLabel: UILabel = {
        let label = UILabel()
        label.text = "Favorites"
        label.font = Font(.installed(.bakersfieldBold), size: .custom(26.0)).instance
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    let favoritesContainerView: UIView = {
        let cv = UIView()
        cv.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return cv
    }()
    
    let favoritesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.indicatorStyle = .white
        return cv
    }()
    
    let defaultLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Font(.installed(.bakersfieldBold), size: .custom(18.0)).instance
        label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    // New Arrivals
    let newArrivalsLabel: UILabel = {
        let label = UILabel()
        label.text = "New Arrivals"
        label.font = Font(.installed(.bakersfieldBold), size: .custom(26.0)).instance
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    let newArrivalsContainerView: UIView = {
        let cv = UIView()
        cv.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return cv
    }()
    
    let newArrivalsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.indicatorStyle = .white
        return cv
    }()
    
    // Specials
    let specialsLabel: UILabel = {
        let label = UILabel()
        label.text = "Specials"
        label.font = Font(.installed(.bakersfieldBold), size: .custom(26.0)).instance
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    let specialsContainerView: UIView = {
        let cv = UIView()
        cv.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return cv
    }()
    
    let specialsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.indicatorStyle = .white
        return cv
    }()
    
    // Suggestions
    let suggestionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Suggestions"
        label.font = Font(.installed(.bakersfieldBold), size: .custom(26.0)).instance
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    let suggestionsContainerView: UIView = {
        let cv = UIView()
        cv.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return cv
    }()
    
    let suggestionsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.indicatorStyle = .white
        return cv
    }()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewSetup()
        layoutViews()
        setupDefaultLabel()
        setupLogoutButton()
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateData()
    }
    
    // MARK: - Class Methods
    private func homeViewSetup() {
        
        view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationController?.navigationBar.tintColor = .gray
        navigationController?.navigationBar.barStyle = .black
        
        favoritesCollectionView.register(FavoritesCell.self, forCellWithReuseIdentifier: homeFavoritesCellIdentifier)
        favoritesCollectionView.delegate = self
        favoritesCollectionView.dataSource = self
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        favoritesCollectionView.addGestureRecognizer(longPressGesture)
        
        newArrivalsCollectionView.register(NewArrivalsCell.self, forCellWithReuseIdentifier: newArrivalsCellIdentifier)
        newArrivalsCollectionView.delegate = self
        newArrivalsCollectionView.dataSource = self
        
        specialsCollectionView.register(SpecialsCell.self, forCellWithReuseIdentifier: specialsCellIdentifier)
        specialsCollectionView.delegate = self
        specialsCollectionView.dataSource = self
        
        suggestionsCollectionView.register(SuggestionsCell.self, forCellWithReuseIdentifier: suggestionsCellIdentifier)
        suggestionsCollectionView.delegate = self
        suggestionsCollectionView.dataSource = self
    }
    
    fileprivate func populateData() {
        favoritedProducts = UserDefaults.standard.savedProducts(for: UserDefaults.favoriteKey)
        
        if favoritedProducts.count < 1 {
            defaultLabel.isHidden = false
        } else {
            defaultLabel.isHidden = true
        }
        
        favoritesCollectionView.reloadData()
        UIApplication.mainTabBarController()?.viewControllers?[0].tabBarItem.badgeValue = nil
        
        apiService.fetchJson(from: newArrivalsUrl) { [weak self](data: [Product]) in
            self?.newArrrivals = data
            self?.newArrivalsCollectionView.reloadData()
        }
        
        apiService.fetchJson(from: specialsUrl) { [weak self](data: [Product]) in
            self?.specials = data
            self?.specialsCollectionView.reloadData()
        }
        
        apiService.fetchJson(from: suggestionsUrl) { [weak self](data: [Product]) in
            self?.suggestions = data
            self?.suggestionsCollectionView.reloadData()
        }
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: favoritesCollectionView)
        guard let selectedIndexPath = favoritesCollectionView.indexPathForItem(at: location) else { return }
        let alertController = UIAlertController(title: "Remove Product from Favorites?", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            let selectedProduct = self.favoritedProducts[selectedIndexPath.item]
            self.favoritedProducts.remove(at: selectedIndexPath.item)
            self.favoritesCollectionView.deleteItems(at: [selectedIndexPath])
            UserDefaults.standard.deleteProduct(product: selectedProduct, key: UserDefaults.favoriteKey)
            if self.favoritedProducts.count < 1 {
                self.defaultLabel.isHidden = false
            } else {
                self.defaultLabel.isHidden = true
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    private func layoutViews() {
        
        self.view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: view.frame.width, height: 0)
        
        // Favorites
        scrollView.addSubview(homeFavoritesLabel)
        homeFavoritesLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0).isActive = true
        homeFavoritesLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16.0).isActive = true
        homeFavoritesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.addSubview(favoritesContainerView)
        favoritesContainerView.anchor(top: homeFavoritesLabel.safeAreaLayoutGuide.bottomAnchor, right: scrollView.safeAreaLayoutGuide.rightAnchor, bottom: nil, left: scrollView.safeAreaLayoutGuide.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: view.frame.width, height: 280)
        favoritesContainerView.addSubview(favoritesCollectionView)
        favoritesCollectionView.anchor(top: favoritesContainerView.topAnchor, right: favoritesContainerView.rightAnchor, bottom: favoritesContainerView.bottomAnchor, left: favoritesContainerView.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
        
        // New Arrivals
        scrollView.addSubview(newArrivalsLabel)
        newArrivalsLabel.anchor(top: favoritesContainerView.safeAreaLayoutGuide.bottomAnchor, right: scrollView.safeAreaLayoutGuide.rightAnchor, bottom: nil, left: scrollView.safeAreaLayoutGuide.leftAnchor, paddingTop: 16, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
        scrollView.addSubview(newArrivalsContainerView)
        newArrivalsContainerView.anchor(top: newArrivalsLabel.bottomAnchor, right: scrollView.safeAreaLayoutGuide.rightAnchor, bottom: nil, left: scrollView.safeAreaLayoutGuide.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: view.frame.width, height: 280)
        newArrivalsContainerView.addSubview(newArrivalsCollectionView)
        newArrivalsCollectionView.anchor(top: newArrivalsContainerView.topAnchor, right: newArrivalsContainerView.rightAnchor, bottom: newArrivalsContainerView.bottomAnchor, left: newArrivalsContainerView.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
        
        // Specials
        scrollView.addSubview(specialsLabel)
        specialsLabel.anchor(top: newArrivalsContainerView.bottomAnchor, right: scrollView.safeAreaLayoutGuide.rightAnchor, bottom: nil, left: scrollView.safeAreaLayoutGuide.leftAnchor, paddingTop: 16, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
        scrollView.addSubview(specialsContainerView)
        specialsContainerView.anchor(top: specialsLabel.bottomAnchor, right: scrollView.safeAreaLayoutGuide.rightAnchor, bottom: nil, left: scrollView.safeAreaLayoutGuide.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: view.frame.width, height: 280)
        specialsContainerView.addSubview(specialsCollectionView)
        specialsCollectionView.anchor(top: specialsContainerView.topAnchor, right: specialsContainerView.rightAnchor, bottom: specialsContainerView.bottomAnchor, left: specialsContainerView.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
        
        // Suggestions
        scrollView.addSubview(suggestionsLabel)
        suggestionsLabel.anchor(top: specialsContainerView.bottomAnchor, right: scrollView.safeAreaLayoutGuide.rightAnchor, bottom: nil, left: scrollView.safeAreaLayoutGuide.leftAnchor, paddingTop: 16, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
        scrollView.addSubview(suggestionsContainerView)
        suggestionsContainerView.anchor(top: suggestionsLabel.bottomAnchor, right: scrollView.safeAreaLayoutGuide.rightAnchor, bottom: nil, left: scrollView.safeAreaLayoutGuide.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: view.frame.width, height: 280)
        suggestionsContainerView.addSubview(suggestionsCollectionView)
        suggestionsCollectionView.anchor(top: suggestionsContainerView.topAnchor, right: suggestionsContainerView.rightAnchor, bottom: suggestionsContainerView.bottomAnchor, left: suggestionsContainerView.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
        
        // Shim
        scrollView.addSubview(shim)
        shim.anchor(top: scrollView.topAnchor, right: scrollView.rightAnchor, bottom: scrollView.bottomAnchor, left: scrollView.leftAnchor, paddingTop: 1268, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: scrollView.frame.width, height: 0)
    }
    
    func setupDefaultLabel() {
        let imageSize = CGRect(x: 0, y: -5, width: 30, height: 30)
        let favoriteButtonImage = UIImage(named: "star")
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = favoriteButtonImage
        imageAttachment.bounds = imageSize
        let completeText = NSMutableAttributedString(string: "")
        let textBeforeImage = NSMutableAttributedString(string: "Press the ")
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let textAfterImage = NSMutableAttributedString(string: " icon next to products to add items to favorites.")
        
        completeText.append(textBeforeImage)
        completeText.append(attachmentString)
        completeText.append(textAfterImage)
        
        self.defaultLabel.attributedText = completeText
        
        favoritesContainerView.addSubview(defaultLabel)
        defaultLabel.anchor(top: favoritesContainerView.topAnchor, right: favoritesContainerView.rightAnchor, bottom: favoritesContainerView.bottomAnchor, left: favoritesContainerView.leftAnchor, paddingTop: 0, paddingRight: 20, paddingBottom: 0, paddingLeft: 20, width: favoritesContainerView.bounds.width, height: favoritesContainerView.bounds.height)
    }
    
    fileprivate func setupLogoutButton() {
        let logoutButton = UIBarButtonItem(image: #imageLiteral(resourceName: "logOut").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    @objc func handleLogout() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            } catch let signoutError {
                print("Failed to sign out: ", signoutError)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {        favoritesCollectionView.reloadData()
    }
    
    // MARK: - CollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case self.favoritesCollectionView:
            return favoritedProducts.count
        case self.newArrivalsCollectionView:
            return newArrrivals.count
        case self.specialsCollectionView:
            return specials.count
        case self.suggestionsCollectionView:
            return suggestions.count
        default:
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case self.favoritesCollectionView:
            let favoritesCell = favoritesCollectionView.dequeueReusableCell(withReuseIdentifier: homeFavoritesCellIdentifier, for: indexPath) as! FavoritesCell
            favoritesCell.product = self.favoritedProducts[indexPath.item]
            return favoritesCell
        case self.newArrivalsCollectionView:
            let newArrivalsCell = newArrivalsCollectionView.dequeueReusableCell(withReuseIdentifier: newArrivalsCellIdentifier, for: indexPath) as! NewArrivalsCell
            newArrivalsCell.product = self.newArrrivals[indexPath.item]
            return newArrivalsCell
        case self.specialsCollectionView:
            let specialsCell = specialsCollectionView.dequeueReusableCell(withReuseIdentifier: specialsCellIdentifier, for: indexPath) as! SpecialsCell
            specialsCell.product = self.specials[indexPath.item]
            return specialsCell
        case self.suggestionsCollectionView:
            let suggestionsCell = suggestionsCollectionView.dequeueReusableCell(withReuseIdentifier: suggestionsCellIdentifier, for: indexPath) as! SuggestionsCell
            suggestionsCell.product = self.suggestions[indexPath.item]
            return suggestionsCell
        default:
            let cell = UICollectionViewCell()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (favoritesContainerView.frame.width - 3 * 8) / 2
        let height = favoritesContainerView.frame.height * 0.90
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    // Display Popover
    let popover = Popover()
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.favoritesCollectionView:
            let cell = collectionView.cellForItem(at: indexPath) as! FavoritesCell
            popover.showPopover(product: cell.product)
        case self.newArrivalsCollectionView:
            let cell = collectionView.cellForItem(at: indexPath) as! NewArrivalsCell
            popover.showPopover(product: cell.product)
        case self.specialsCollectionView:
            let cell = collectionView.cellForItem(at: indexPath) as! SpecialsCell
            popover.showPopover(product: cell.product)
        case self.suggestionsCollectionView:
            let cell = collectionView.cellForItem(at: indexPath) as! SuggestionsCell
            popover.showPopover(product: cell.product)
        default:
            print("Error")
        }
    }
}
