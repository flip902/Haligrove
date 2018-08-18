//
//  SalesCell.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-30.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit

class SalesCell: UICollectionViewCell {
    
    weak var salesPopoverDelegate: PopoverDelegate?
    
    lazy var saleImage = CustomCacheImageView()
    lazy var saleTitle = UILabel()
    lazy var saleDescriptionLabel = UILabel()
    var label: UILabel?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(salesItem: Product) {
        layer.cornerRadius = 15
        backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        guard let urlString = salesItem.src else { return }
        saleImage.loadImageUsingUrlString(urlString: urlString)
        saleImage.layer.cornerRadius = 5
        saleImage.layer.masksToBounds = true
        saleImage.contentMode = .scaleToFill
        
        saleTitle.text = salesItem.name
        saleTitle.font = Font(.installed(.bakersfieldBold), size: .custom(23)).instance
        saleTitle.layer.shadowColor = #colorLiteral(red: 0.07843137255, green: 0.06666666667, blue: 0.05098039216, alpha: 1)
        saleTitle.layer.shadowRadius = 1.0
        saleTitle.layer.shadowOpacity = 1.0
        saleTitle.layer.shadowOffset = CGSize(width: 3, height: 3)
        saleTitle.layer.masksToBounds = true
        saleTitle.textAlignment = .center
        saleTitle.adjustsFontSizeToFitWidth = true
        saleTitle.textColor = #colorLiteral(red: 0.6196078431, green: 0.3529411765, blue: 0.8352941176, alpha: 1)
        
        saleDescriptionLabel.text = salesItem.productDescription
        saleDescriptionLabel.numberOfLines = 0
        saleDescriptionLabel.font = Font(.installed(.bakersfieldBold), size: .custom(18)).instance
        saleDescriptionLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        saleDescriptionLabel.layer.masksToBounds = true
        saleDescriptionLabel.adjustsFontSizeToFitWidth = true
        
        addSubview(saleImage)
        saleImage.anchor(top: topAnchor, right: nil, bottom: bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, paddingTop: 8, paddingRight: 0, paddingBottom: 8, paddingLeft: 8, width: self.frame.width / 3, height: self.frame.height - 16)
        addSubview(saleTitle)
        saleTitle.anchor(top: topAnchor, right: safeAreaLayoutGuide.rightAnchor, bottom: nil, left: saleImage.safeAreaLayoutGuide.rightAnchor, paddingTop: 8, paddingRight: 4, paddingBottom: 0, paddingLeft: 4, width: 0, height: 0)
        addSubview(saleDescriptionLabel)
        saleDescriptionLabel.anchor(top: saleTitle.topAnchor, right: safeAreaLayoutGuide.rightAnchor, bottom: bottomAnchor, left: saleImage.rightAnchor, paddingTop: 0, paddingRight: 8, paddingBottom: 8, paddingLeft: 8, width: 0, height: 0)
    }
}
