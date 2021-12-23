//
//  PinboardCollectionView.swift
//  pinboard
//
//  Created by Baris Cem Baykara on /266/18.
//  Copyright © 2018 Baris Cem Baykara. All rights reserved.
//

import UIKit

protocol CollectionViewDataFetcherDelegate: class {
    func didRefresh()
}

class PinboardCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let refresher: UIRefreshControl = {
        let controller = UIRefreshControl()
        controller.attributedTitle = NSAttributedString(string: "Refreshing")
        controller.addTarget(self, action: #selector(willFetch), for: .valueChanged)
        return controller
    }()

    var fetchedData: People? {
        didSet {
            self.reloadData()
        }
    }

    weak var fetchDelegate: CollectionViewDataFetcherDelegate?
    
    private func setupProperties() {
        allowsMultipleSelection = false
        delegate = self
        dataSource = self
        contentInset = UIEdgeInsets(top: 6.0, left: 0.0, bottom: 12.0, right: 0.0)
        register(PhotoViewCell.self, forCellWithReuseIdentifier: "photoCell")
        backgroundColor = .white
        self.alwaysBounceVertical = true
        addSubview(refresher)
    }
    
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupProperties()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func willFetch(){
        fetchDelegate?.didRefresh()
    }
}

extension PinboardCollectionView {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let fetchedData = fetchedData else {return 0}
        return fetchedData.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoViewCell
        
        cell.centerPoint = cell.center
        
        let frontView = cell.sides.frontView as! PhotoViewFront
        let backView = cell.sides.backView as! PhotoViewBack
        

        frontView.photo.image = #imageLiteral(resourceName: "contact")
        frontView.name.text = fetchedData?.data?[indexPath.row].name
        backView.userName.text = fetchedData?.data?[indexPath.row].name
        
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            cell.alpha = 1
            cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoViewCell
        cell.flipState.flip()
    }
}
