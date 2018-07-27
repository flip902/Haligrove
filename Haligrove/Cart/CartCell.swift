//
//  CartCell.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-26.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {
    
    var itemCount: UILabel = {
        let label = UILabel()
        label.font = Font(.installed(.bakersfieldBold), size: .custom(22.0)).instance
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    var itemNameLabel: UILabel = {
        let label = UILabel()
        label.font = Font(.installed(.bakersfieldBold), size: .custom(22.0)).instance
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    var itemPriceLabel: UILabel = {
        let label = UILabel()
        label.font = Font(.installed(.bakersfieldBold), size: .custom(22.0)).instance
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
    }
    
    func setupCell() {
        self.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.layer.cornerRadius = 5
        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.borderWidth = 2
        self.selectionStyle = .none
        
        addSubview(itemCount)
        itemCount.anchor(top: topAnchor, right: nil, bottom: bottomAnchor, left: leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 8, width: 0, height: 0)
        addSubview(itemNameLabel)
        itemNameLabel.anchor(top: topAnchor, right: nil, bottom: bottomAnchor, left: itemCount.rightAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 8, width: 0, height: 0)
        addSubview(itemPriceLabel)
        itemPriceLabel.anchor(top: topAnchor, right: rightAnchor, bottom: bottomAnchor, left: nil, paddingTop: 0, paddingRight: 8, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
