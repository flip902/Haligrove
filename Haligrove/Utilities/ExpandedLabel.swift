//
//  ExpandedLabel.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-26.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit

class ExpandedLabel: UILabel {
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let addedWidth = font.pointSize * 0.3
        return CGSize(width: size.width + addedWidth, height: size.height)
    }
}
