//
//  ViewController.swift
//  Pipedrive
//
//  Created by Baris Cem Baykara on 05.12.2021.
//

import UIKit

class PeopleViewController: UITableViewController, DataDelegate {
    
    var fetchedData: Person? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        navigationItem.title = "People"
        navigationController?.navigationBar.prefersLargeTitles = true
        didRefresh()
        
    }
    
}



extension PeopleViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchedData = fetchedData else {return 0}
        return fetchedData.data?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = fetchedData?.data?[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewController = DetailsViewController()
        detailsViewController.fetchDelegate = self
        detailsViewController.fetchedData = fetchedData?.data?[indexPath.row]
        self.navigationController?.pushViewController(detailsViewController, animated: true)
        //self.navigationController?.present(detailsViewController, animated: true, completion: nil)
    }
    
    
    //MARK: TODO - Deal with network handling in the NavigationViewController instead of here
    func didRefresh() {
        
        let networkHandler = NetworkHandler()
        networkHandler.fetch(from: .persons) { [self] (data: Person?, error) in
                guard let receivedData = data else {
                    if let error = error {
                        print("\(error.description)")
                    }
                    return
                }
                fetchedData = receivedData

            }
    }
    
}
