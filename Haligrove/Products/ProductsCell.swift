//
//  ProductsCell.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-26.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit

class ProductsCell: UITableViewCell {
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowColor = #colorLiteral(red: 0.07843137255, green: 0.06666666667, blue: 0.05098039216, alpha: 1)
        view.layer.shadowOpacity = 0.6
        view.layer.shadowRadius = 1
        return view
    }()
    
    let rightArrow: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "rightArrow").withRenderingMode(.alwaysTemplate))
        iv.contentMode = .scaleAspectFit
        iv.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return iv
    }()
    
    let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return iv
    }()
    
    let productLabel: ExpandedLabel = {
        let label = ExpandedLabel()
        label.text = "Products"
        label.font = Font(.installed(.bakersfieldBold), size: .custom(36.0)).instance
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var labelStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [productImageView, productLabel])
        sv.alignment = .fill
        sv.distribution = .equalSpacing
        sv.axis = .horizontal
        sv.spacing = 12
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        selectionStyle = .none
        addSubview(cellView)
        cellView.addSubview(rightArrow)
        cellView.addSubview(labelStackView)
        
        cellView.anchor(top: safeAreaLayoutGuide.topAnchor, right: safeAreaLayoutGuide.rightAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, paddingTop: 4, paddingRight: 4, paddingBottom: 4, paddingLeft: 4, width: 0, height: 0)
        rightArrow.anchor(top: nil, right: cellView.rightAnchor, bottom: nil, left: nil, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 30, height: 30)
        rightArrow.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        productImageView.anchor(top: nil, right: nil, bottom: nil, left: nil, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 50, height: 50)
        labelStackView.anchor(top: nil, right: nil, bottom: nil, left: cellView.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 8, width: 0, height: 0)
        labelStackView.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        
    }
    
    
}

