//
//  PhotoViewCell.swift
//  pinboard
//
//  Created by Baris Cem Baykara on /48/18.
//  Copyright © 2018 Baris Cem Baykara. All rights reserved.
//

import UIKit

class PhotoViewCell: FlipableCollectionViewCell {
    
    var centerPoint: CGPoint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sides.frontView = PhotoViewFront()
        sides.backView = PhotoViewBack()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Constraints for subview
    private var didSetupConstraints = false

    override func updateConstraints() {

        if (!didSetupConstraints) {
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
}
