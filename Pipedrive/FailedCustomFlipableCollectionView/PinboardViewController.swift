//
//  ViewController.swift
//  pinboard
//
//  Created by Baris Cem Baykara on /116/18.
//  Copyright © 2018 Baris Cem Baykara. All rights reserved.
//

import UIKit
import CoreLocation

class PinboardViewController: UIViewController, CollectionViewDataFetcherDelegate {
    
    var fetchedData: People? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "People"
        navigationController?.navigationBar.prefersLargeTitles = true
        createCollectionView()
        didRefresh()
    }
    
    
    //MARK: Setup CollectionView
    var collectionView: PinboardCollectionView!
    
    func createCollectionView() {
        let layout = Layout(xSpacing: 12, ySpacing: 12.0, columnCount: 2)
        collectionView = PinboardCollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.fetchDelegate = self
        view.addSubview(collectionView)
    }
    
}

extension PinboardViewController {
    
    
    func didRefresh() {
        
        let networkHandler = NetworkHandler()
        networkHandler.fetch(from: .persons) { [self] (data: People?, error) in
                guard let receivedData = data else {
                    if let error = error {
                        print("\(error.description)")
                    }
                    return
                }
                fetchedData = receivedData
            self.collectionView.fetchedData = fetchedData
            self.collectionView.refresher.endRefreshing()
            }
    }
}
