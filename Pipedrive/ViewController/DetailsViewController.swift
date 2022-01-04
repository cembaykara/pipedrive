//
//  DetailsViewController.swift
//  Pipedrive
//
//  Created by Baris Cem Baykara on 06.12.2021.
//

import UIKit

protocol DataDelegate: class {
    func didRefresh()
}

class DetailsViewController: UITableViewController {
    
    //In case needed
    weak var fetchDelegate: DataDelegate?
    
    private let sections = ["First Name","Last Name", "Email", "Phone"]
    private var data = [[Any]]()

    var fetchedData: Object? {
        didSet {
            //In case needed
            prepareData()
            tableView.reloadData()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViewController()
    }
    
    func prepareViewController(){
        navigationItem.title = fetchedData?.name
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
    }
    
    func prepareData(){
        data.append( [fetchedData?.firstName as Any])
        data.append([fetchedData?.lastName as Any])
        data.append(fetchedData?.email?.compactMap{$0.value} ?? [])
        data.append(fetchedData?.phone?.compactMap{$0.value} ?? [])
    }
}

extension DetailsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = data[indexPath.section][indexPath.row] as? String
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = sections[section]
        label.backgroundColor = UIColor.lightGray
        return label
    }
}
