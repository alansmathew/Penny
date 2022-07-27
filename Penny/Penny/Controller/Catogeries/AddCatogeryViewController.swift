//
//  AddCatogeryViewController.swift
//  Penny
//
//  Created by Anu Benoy on 19/07/22.
//

import UIKit

class AddCatogeryViewController: UIViewController {

    @IBOutlet weak var catogeryTableView: UITableView!
    @IBOutlet weak var addCatogryButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        catogeryTableView.dataSource = self
        
        addCatogryButton.layer.borderColor = UIColor.red.cgColor
        addCatogryButton.layer.borderWidth = 0.5
        addCatogryButton.layer.cornerRadius = 5

        // Do any additional setup after loading the view.
    }
}

//MARK: - add Catogery datasorce
extension AddCatogeryViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants().catogeries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = catogeryTableView.dequeueReusableCell(withIdentifier: "catogeryIdentifier", for: indexPath) as! customAddCatogeryCell
        let data = Constants().catogeries
        if indexPath.row < data.count{
            cell.catogoryLabel.text = data[indexPath.row]
        }
        return cell
    }
    
    
}
 
class customAddCatogeryCell : UITableViewCell{
    
    @IBOutlet weak var catogoryLabel: UILabel!
}

