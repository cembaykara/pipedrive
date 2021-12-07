//
//  PhotoViewFront.swift
//  pinboard
//
//  Created by Baris Cem Baykara on /18/18.
//  Copyright © 2018 Baris Cem Baykara. All rights reserved.
//

import UIKit

class PhotoViewFront: UIView {
    
    let containerView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        return view
    }()
    
    let name : UILabel = {
        let text = UILabel()
        return text
    }()
    
    let photo : UIImageView = {
        let view = UIImageView()
        view.contentMode = UIView.ContentMode.scaleAspectFit
        return view
    }()
    
    var centerPoint: CGPoint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        containerView.addSubview(photo)
        containerView.addSubview(name)
        addSubview(containerView)
        
        createShadow()
    }
    
    // MARK: Constraints for subview
    private var didSetupConstraints = false
    override func updateConstraints() {
        
        if (!didSetupConstraints) {
            
            autoPinEdgesToSuperviewEdges()
            containerView.autoPinEdgesToSuperviewEdges()
            photo.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: .bottom)
            photo.autoPinEdge(toSuperviewEdge: .bottom, withInset: 50)
            name.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: .top)
            name.autoPinEdge(.top, to: .bottom, of: photo, withOffset: 8.0)

            didSetupConstraints = true
        }
        super.updateConstraints()
    }
}
