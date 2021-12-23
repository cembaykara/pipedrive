//
//  ViewController.swift
//  Pipedrive
//
//  Created by Baris Cem Baykara on 05.12.2021.
//

import UIKit

class PeopleViewController: UITableViewController, DataDelegate {
    
    var fetchedData: People? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        // MARK: TODO Get user's name
        navigationItem.title = "People"
        navigationController?.navigationBar.prefersLargeTitles = true
        didRefresh()
    }
}



extension PeopleViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = fetchedData?.data {
            self.tableView.restore()
            return data.count
        }else {
            self.tableView.setEmptyMessage("No Data Available")
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = fetchedData?.data?[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewController = DetailsViewController()
        detailsViewController.fetchDelegate = self
        
        if let fetchedData = fetchedData {
            detailsViewController.fetchedData = fetchedData.data?[indexPath.row]
            self.navigationController?.pushViewController(detailsViewController, animated: true)
            //self.navigationController?.present(detailsViewController, animated: true, completion: nil)
        }else {
                let alert = UIAlertController(title: "Oops", message: "There are no details for this contact.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: TODO - Deal with network handling in the NavigationViewController instead of here
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
            }
    }
}

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
