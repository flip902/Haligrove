//
//  PopoverCell.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-08-15.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit

class PopoverCell: UITableViewCell {
    
    var radioButton: RadioButton?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
