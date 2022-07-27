//
//  MenuViewController.swift
//  Penny
//
//  Created by user207265 on 7/27/22.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var menuTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    



}

// MARK: - Table Data source

extension MenuViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants().menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        let data = Constants().menuItems
        if data.count > indexPath.row{
            cell.textLabel?.text = "\(data[indexPath.row])"
        }
        return cell
    }
    
    
}
