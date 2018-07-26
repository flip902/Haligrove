//
//  FavoritesCell.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-26.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit

// TODO: - Refactor out cells into one template cell
class FavoritesCell: UICollectionViewCell {
    
    // MARK: - Property Declarations
    var cellImageView = CustomCacheImageView()
    var nameLabel = UILabel()
    var singlePrice = UILabel()
    var typeLabel = UILabel()
    var for5Label = UILabel()
    
    var product: Product! {
        didSet {
            cellImageView.loadImageUsingUrlString(urlString: product.src ?? "")
            nameLabel.text = product.name
            singlePrice.text = "$\(Int(product.pricePerGram ?? 0.00))"
            typeLabel.text = "\(product.type ?? product.category ?? "")"
            for5Label.text = "5 for $\(Int(product.priceForFive ?? 0.00))"
        }
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        layoutViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell Methods
    private func setupCell() {
        self.layer.cornerRadius = 15
        self.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        cellImageView.contentMode = .scaleToFill
        cellImageView.layer.cornerRadius = 15
        cellImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cellImageView.layer.masksToBounds = true
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.font = Font(.installed(.bakersfieldBold), size: .custom(18)).instance
        nameLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        nameLabel.adjustsFontSizeToFitWidth = true
        
        singlePrice.font = Font(.installed(.bakersfieldBold), size: .custom(22)).instance
        singlePrice.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        typeLabel.font = Font(.installed(.bakersfieldBold), size: .custom(16)).instance
        typeLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        for5Label.font = Font(.installed(.bakersfieldLight), size: .custom(16)).instance
        for5Label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    private func layoutViews() {
        addSubview(cellImageView)
        cellImageView.anchor(top: topAnchor, right: rightAnchor, bottom: nil, left: leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
        cellImageView.heightAnchor.constraint(equalTo: cellImageView.widthAnchor).isActive = true
        
        addSubview(nameLabel)
        nameLabel.anchor(top: cellImageView.bottomAnchor, right: cellImageView.rightAnchor, bottom: nil, left: cellImageView.leftAnchor, paddingTop: 8, paddingRight: 0, paddingBottom: 0, paddingLeft: 8, width: 0, height: 0)
        
        addSubview(typeLabel)
        typeLabel.anchor(top: nameLabel.bottomAnchor, right: nameLabel.rightAnchor, bottom: nil, left: nameLabel.leftAnchor, paddingTop: 4, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
        
        addSubview(for5Label)
        for5Label.anchor(top: typeLabel.bottomAnchor, right: nil, bottom: nil, left: typeLabel.leftAnchor, paddingTop: 4, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
        
        addSubview(singlePrice)
        singlePrice.anchor(top: nil, right: rightAnchor, bottom: bottomAnchor, left: nil, paddingTop: 0, paddingRight: 8, paddingBottom: 8, paddingLeft: 0, width: 0, height: 0)
    }
}
