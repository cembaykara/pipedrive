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
    
    private let sections = ["First Name","Last Name", "Phone", "Email"]

    var fetchedData: Object? {
        didSet {
            //In case needed
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

}

extension DetailsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchedData = fetchedData else {return 0}
        if section == 2 {
            return fetchedData.phone?.count ?? 0
        }else if section == 3 {
            return fetchedData.email?.count ?? 0
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

            if let fetchedData = fetchedData {
            
                if indexPath.section == 0 {
                cell.textLabel?.text = fetchedData.firstName
            }else if (indexPath.section == 1){
                cell.textLabel?.text = fetchedData.lastName
            }else if (indexPath.section == 2){
                cell.textLabel?.text = (fetchedData.phone?[indexPath.row].value)
            }else {
                cell.textLabel?.text = (fetchedData.email?[indexPath.row].value)
            }
        
        }
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = sections[section]
        label.backgroundColor = UIColor.lightGray
        return label
    }
}
