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
        menuTableView.delegate = self
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

//MARK: - table view delegate
extension MenuViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row){
            case 0:
                let storyboard = UIStoryboard(name: "MoreScreen", bundle: nil)
                let viewC = storyboard.instantiateViewController(withIdentifier: "MainCurrencyViewController") as! MainCurrencyViewController
                navigationController?.pushViewController(viewC, animated: true)
                break
            case 1:
                let storyboard = UIStoryboard(name: "MoreScreen", bundle: nil)
                let viewC = storyboard.instantiateViewController(withIdentifier: "PasscodeViewController") as! PasscodeViewController
                navigationController?.pushViewController(viewC, animated: true)
                break
            case 2:
                let storyboard = UIStoryboard(name: "MoreScreen", bundle: nil)
                let viewC = storyboard.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
                navigationController?.pushViewController(viewC, animated: true)
                break
            case 3:
                let storyboard = UIStoryboard(name: "MoreScreen", bundle: nil)
                let viewC = storyboard.instantiateViewController(withIdentifier: "FeedbackViewController") as! FeedbackViewController
                navigationController?.pushViewController(viewC, animated: true)
                break
            default:
                break
            }
        }
}
