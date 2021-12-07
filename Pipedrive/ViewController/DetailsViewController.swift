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
    
    private var prepredDta: [[Any]]?

    var fetchedData: Object? {
        didSet {
            //In case needed
            tableView.reloadData()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViewController()
        // Do any additional setup after loading the view.
    }
    
    func prepareViewController(){
        navigationItem.title = "Name"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
    }

}

extension DetailsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchedData = fetchedData else {return 0}
        if section == 2 {
            return fetchedData.phone!.count
        }else if section == 3 {
            return fetchedData.email!.count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var text : String
        
        //MARK: TODO - More time better code
        if indexPath.section == 0 {
            text = (fetchedData?.firstName)!
        }else if (indexPath.section == 1){
            text = (fetchedData?.lastName)!
        }else if (indexPath.section == 2){
            text = (fetchedData?.phone![indexPath.row].value)!
        }else {
            text = (fetchedData?.email![indexPath.row].value)!
        }
        
        cell.textLabel?.text = text
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
