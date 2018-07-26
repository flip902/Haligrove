//
//  ExtractsCell.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-26.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit
import FoldingCell
import EasyPeasy

class ExtractsCell: FoldingCell, NSCacheDelegate {
    
    // MARK: - Property Declarations
    var product: Product?
    weak var delegate: ExtractsFavoriteDelegate?
    
    // Foreground cell UI Items
    var imageContainer = CustomCacheImageView()
    var productNameLabel = UILabel()
    var typeLabel = UILabel()
    var pricePerGramLabel = UILabel()
    var qtyPriceLabel = UILabel()
    var inventoryBar = CustomCacheImageView()
    var saleLabel = UILabel()
    var newLabel = UILabel()
    var favoritesButton = UIButton(type: .custom)
    var isFavorite: Bool?
    
    // TODO: - ContainerView
    // ContainerView UI Items
    
    // MARK: - Initializers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        containerView = createContainerView()
        foregroundView = createForegroundView()
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Class Methods
    override func animationDuration(_ itemIndex: NSInteger, type: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.33, 0.26, 0.26]
        return durations[itemIndex]
    }
    
    func setupFoldingCell(product: Product) {
        self.product = product
        
        // Foreground View
        guard let imageSourceString = product.src else { return }
        imageContainer.loadImageUsingUrlString(urlString: imageSourceString)
        imageContainer.contentMode = .scaleToFill
        imageContainer.layer.cornerRadius = 5
        imageContainer.layer.masksToBounds = true
        
        productNameLabel.text = product.name
        productNameLabel.adjustsFontSizeToFitWidth = true
        productNameLabel.layer.masksToBounds = true
        productNameLabel.minimumScaleFactor = 0.2
        productNameLabel.font = Font(.installed(.bakersfieldBold), size: .custom(23)).instance
        productNameLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        productNameLabel.numberOfLines = 1
        
        typeLabel.text = product.type
        typeLabel.font = Font(.installed(.bakersfieldBold), size: .custom(18)).instance
        typeLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        guard let pricePerGram = product.pricePerGram else { return }
        pricePerGramLabel.text = "$\(Int(pricePerGram)) ea."
        pricePerGramLabel.font = Font(.installed(.bakersfieldBold), size: .custom(26)).instance
        pricePerGramLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        guard let price = product.priceForFive else { return }
        guard let qty = product.id else { return }
        qtyPriceLabel.text = "\(qty) for $\(Int(price))"
        qtyPriceLabel.font = Font(.installed(.bakersfieldLight), size: .custom(16)).instance
        qtyPriceLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        inventoryBar.contentMode = .scaleToFill
        let inventory = product.inventory
        switch inventory {
        case "full":
            inventoryBar.image = #imageLiteral(resourceName: "full")
        case "threeQuarters":
            inventoryBar.image = #imageLiteral(resourceName: "threeQuarters")
        case "med":
            inventoryBar.image = #imageLiteral(resourceName: "half")
        case "low":
            inventoryBar.image = #imageLiteral(resourceName: "oneQuarter")
        case "empty":
            inventoryBar.image = #imageLiteral(resourceName: "empty")
        default:
            inventoryBar.image = #imageLiteral(resourceName: "full")
        }
        
        saleLabel.font = Font(.installed(.bakersfieldBold), size: .custom(16)).instance
        saleLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        saleLabel.text = " sale "
        saleLabel.backgroundColor = #colorLiteral(red: 0.6196078431, green: 0.3529411765, blue: 0.8352941176, alpha: 1)
        saleLabel.layer.cornerRadius = 5
        saleLabel.clipsToBounds = true
        if product.sale == "sale" {
            saleLabel.isHidden = false
        } else {
            saleLabel.isHidden = true
        }
        
        newLabel.font = Font(.installed(.bakersfieldBold), size: .custom(16)).instance
        newLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        newLabel.text = " new "
        newLabel.backgroundColor = #colorLiteral(red: 0.9185019135, green: 0.9065433741, blue: 0.3068211675, alpha: 1)
        newLabel.layer.cornerRadius = 5
        newLabel.clipsToBounds = true
        if product.isNew == "new" {
            newLabel.isHidden = false
        } else {
            newLabel.isHidden = true
        }
        
        let image: UIImage = #imageLiteral(resourceName: "star")
        favoritesButton.setImage(image, for: .normal)
        favoritesButton.addTarget(self, action: #selector(favoritedStrain), for: .touchUpInside)
    }
    
    @objc func favoritedStrain() {
        delegate?.didTapExtractFavoritesButton(in: self)
    }
    
    func createForegroundView() -> RotatedView {
        let foregroundView = RotatedView(frame: .zero)
        foregroundView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        foregroundView.translatesAutoresizingMaskIntoConstraints = false
        foregroundView.layer.cornerRadius = 5
        
        let inventoryLabel = UILabel()
        inventoryLabel.font = Font(.installed(.bakersfieldLight), size: .custom(12)).instance
        inventoryLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        inventoryLabel.text = "inventory"
        
        contentView.addSubview(foregroundView)
        
        foregroundView.addSubview(imageContainer)
        foregroundView.addSubview(productNameLabel)
        foregroundView.addSubview(typeLabel)
        foregroundView.addSubview(pricePerGramLabel)
        foregroundView.addSubview(qtyPriceLabel)
        foregroundView.addSubview(inventoryBar)
        foregroundView.addSubview(inventoryLabel)
        foregroundView.addSubview(saleLabel)
        foregroundView.addSubview(newLabel)
        foregroundView.addSubview(favoritesButton)
        
        imageContainer.anchor(top: foregroundView.topAnchor, right: nil, bottom: foregroundView.bottomAnchor, left: foregroundView.leftAnchor, paddingTop: 8, paddingRight: 0, paddingBottom: 8, paddingLeft: 8, width: 120, height: foregroundView.frame.height)
        productNameLabel.anchor(top: imageContainer.topAnchor, right: foregroundView.rightAnchor, bottom: nil, left: imageContainer.rightAnchor, paddingTop: -4, paddingRight: 0, paddingBottom: 0, paddingLeft: 8, width: 0, height: 0)
        typeLabel.anchor(top: productNameLabel.bottomAnchor, right: nil, bottom: nil, left: imageContainer.rightAnchor, paddingTop: -4, paddingRight: 0, paddingBottom: 0, paddingLeft: 8, width: 0, height: 0)
        pricePerGramLabel.anchor(top: typeLabel.bottomAnchor, right: nil, bottom: nil, left: imageContainer.rightAnchor, paddingTop: 4, paddingRight: 0, paddingBottom: 0, paddingLeft: 8, width: 0, height: 0)
        qtyPriceLabel.anchor(top: pricePerGramLabel.bottomAnchor, right: nil, bottom: nil, left: pricePerGramLabel.leftAnchor, paddingTop: 4, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
        inventoryBar.anchor(top: qtyPriceLabel.bottomAnchor, right: foregroundView.rightAnchor, bottom: imageContainer.bottomAnchor, left: imageContainer.rightAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 9)
        inventoryLabel.anchor(top: nil, right: inventoryBar.rightAnchor, bottom: inventoryBar.topAnchor, left: nil, paddingTop: 0, paddingRight: 8, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
        newLabel.anchor(top: typeLabel.topAnchor, right: nil, bottom: typeLabel.bottomAnchor, left: typeLabel.rightAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 8, width: 0, height: 0)
        saleLabel.anchor(top: typeLabel.topAnchor, right: nil, bottom: typeLabel.bottomAnchor, left: typeLabel.rightAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 8, width: 0, height: 0)
        favoritesButton.anchor(top: productNameLabel.bottomAnchor, right: productNameLabel.rightAnchor, bottom: nil, left: nil, paddingTop: 0, paddingRight: 8, paddingBottom: 0, paddingLeft: 0, width: 30, height: 30)
        
        foregroundView.easy.layout([
            Height(120),
            Left(8),
            Right(8),
            ])
        
        let top = (foregroundView.easy.layout([Top(8)])).first
        top?.identifier = "ForegroundViewTop"
        self.foregroundViewTop = top
        foregroundView.layoutIfNeeded()
        return foregroundView
    }
    
    private func createContainerView() -> UIView {
        let containerView = UIView(frame: .zero)
        containerView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        itemCount = 3
        contentView.addSubview(containerView)
        containerView.easy.layout([
            Height(CGFloat(120 * itemCount)),
            Left(8),
            Right(8),
            ])
        let top = (containerView.easy.layout([Top(8)])).first
        top?.identifier = "ContainerViewTop"
        self.containerViewTop = top
        containerView.layoutIfNeeded()
        return containerView
    }
    
}
