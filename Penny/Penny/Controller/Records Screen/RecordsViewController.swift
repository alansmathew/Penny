//
//  RecordsViewController.swift
//  Penny
//
//  Created by Alan S Mathew on 19/07/22.
//

import UIKit

class RecordsViewController: UIViewController {

    @IBOutlet weak var recordsTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordsTableView.dataSource = self
        
        addButton.layer.cornerRadius = addButton.frame.size.height / 2
//        addButton.layer.borderColor = UIColor.red.cgColor
//        addButton.layer.borderWidth = 1
        addButton.layer.shadowColor = UIColor.black.cgColor;
        addButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        addButton.layer.shadowOpacity = 0.5;
        addButton.layer.shadowRadius = 10.0;
        addButton.layer.masksToBounds = false;
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = false
        recordsTableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
//MARK: - Buttons
    @IBAction func addTrunsactionClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddTransaction", bundle: nil)
        
        let viewC = storyboard.instantiateViewController(withIdentifier: "AddTransactionsViewController") as! AddTransactionsViewController
        navigationController?.pushViewController(viewC, animated: true)
    }

}

// MARK: - Records DataSorce
extension RecordsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        redorderData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = redorderData
        let cell = recordsTableView.dequeueReusableCell(withIdentifier: "recordsCell", for: indexPath) as! RecordsTableViewCell
        if data.count > indexPath.row{
            cell.nameLabel?.text = data[indexPath.row].name
            cell.dateLabel.text = Date.getDayOnly(date: data[indexPath.row].date!)
            cell.timeLabel.text = Date.getTime(date: data[indexPath.row].date!)
            cell.priceLabel.textColor = data[indexPath.row].type == "income" ? Constants().greenColor : Constants().redColor
            cell.priceLabel.text = "$ \((data[indexPath.row].amount! * 100).rounded()/100)"
        }
       
        return cell
    }
    
}

// MARK: - Records Cell
class RecordsTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateTimeView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        dateTimeView.layer.cornerRadius = 6
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



// title case in transaction cells
// shadows in cells
