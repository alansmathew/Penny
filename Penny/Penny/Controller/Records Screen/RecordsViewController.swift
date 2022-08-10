//
//  RecordsViewController.swift
//  Penny
//
//  Created by Alan S Mathew on 19/07/22.
//

import UIKit
import CoreData

class RecordsViewController: UIViewController {

    @IBOutlet weak var recordsTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var totalExpenseLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    // setting context to APPDATA of the app thus helps to fetch and save data from and to COREDATA
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        recordsTableView.dataSource = self
        recordsTableView.delegate = self
        
        // setting some space on the bottom of the table view thus the last record wont get covered by the add button
        let tablefooter = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 90))
        recordsTableView.tableFooterView = tablefooter
        
        // setting up some styles for the button
        addButton.layer.cornerRadius = addButton.frame.size.height / 2
        addButton.layer.shadowColor = UIColor.black.cgColor;
        addButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        addButton.layer.shadowOpacity = 0.5;
        addButton.layer.shadowRadius = 10.0;
        addButton.layer.masksToBounds = false;
        
        getDefaultCurrency()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hiding the top title because first screen dosnt nees any title
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = false
        recordsTableView.reloadData()
        
        listDatabaseData()
        totalAmountLabel.text = "\(defaultCurrency)\(totalAmount)"
        totalIncomeLabel.text = "⬆️ \(defaultCurrency)\(totalIncome)"
        totalExpenseLabel.text = "⬇️ \(defaultCurrency)\(totalExpense)"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // making title not hidden when view disappears
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func listDatabaseData(){
        // fetching data from value in decending order with the date
        let fetchRequest = NSFetchRequest<Trans>(entityName: "Trans")
        let sort = NSSortDescriptor(key: #keyPath(Trans.date), ascending:false)
        fetchRequest.sortDescriptors = [sort]
        do {
            databaseData = try context.fetch(fetchRequest)
        } catch {}
        
        //calculating total income and expenses from the database data and storing it in CONSTANTS file
        totalIncome = 0.0
        totalExpense = 0.0
        if let data = databaseData{
            for x in data{
                if x.type == "income" {
                    totalIncome += x.amount
                }
                else{
                    totalExpense += x.amount
                }
            }
        }
        totalAmount = totalIncome - totalExpense
        recordsTableView.reloadData()
    }
    
    // getting default currency from the userDefaults to change the symbol in everywheer in the app
    func getDefaultCurrency(){
        if let currency = UserDefaults.standard.string(forKey: "CURRENCY_SYMBOL"){
            defaultCurrency = currency
            defaultCurrencyIndex = UserDefaults.standard.integer(forKey: "CURRENCY_INDEX")
        }
        else{
            // default currency is set to dollers
            defaultCurrency = "$"
        }
    }
    
    // when user clicks on tha add button bottom right
    @IBAction func addTrunsactionClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddTransaction", bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier: "AddTransactionsViewController") as! AddTransactionsViewController
        navigationController?.pushViewController(viewC, animated: true)
    }
}

// MARK: - Records DataSorce
extension RecordsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        databaseData?.count ?? 0
    }
    
    // setting up cells with curresponding datas
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recordsTableView.dequeueReusableCell(withIdentifier: "recordsCell", for: indexPath) as! RecordsTableViewCell
        if let items = databaseData{
            if items.count > indexPath.row{
                cell.nameLabel?.text = items[indexPath.row].name
                cell.dateLabel.text = Date.getDayOnly(date: items[indexPath.row].date!)
                cell.timeLabel.text = Date.getTime(date: items[indexPath.row].date!)
                cell.priceLabel.textColor = items[indexPath.row].type == "income" ? Constants().greenColor : Constants().redColor
                
                cell.priceLabel.text = "\(defaultCurrency) \((items[indexPath.row].amount * 100).rounded()/100)"
            }
        }
        return cell
    }
    
}

// MARK: - records delegate
extension RecordsViewController:UITableViewDelegate{
    
    // redirecting user to another page
    // if the particular record have the map location in it then the user will be redirected to ShowMapViewController
    // if not then the user will be sent to AddTransactionsViewController with data in the fields to update
    // note: this are in different storyboard!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if databaseData?.count ?? 0 > 0 {
            if let long = databaseData![indexPath.row].long, let lat = databaseData![indexPath.row].lat{
                let storyboard = UIStoryboard(name: "AddTransaction", bundle: nil)
                let viewC = storyboard.instantiateViewController(withIdentifier: "ShowMapViewController") as! ShowMapViewController
                viewC.transactionData = indexPath.row
                viewC.setLocationData = databaseData![indexPath.row]
                navigationController?.pushViewController(viewC, animated: true)
            }
            else {
                let storyboard = UIStoryboard(name: "AddTransaction", bundle: nil)
                let viewC = storyboard.instantiateViewController(withIdentifier: "AddTransactionsViewController") as! AddTransactionsViewController
                viewC.dataFromRecords = databaseData![indexPath.row]
                navigationController?.pushViewController(viewC, animated: true)
            }
        }
        
    }
    
    // swipe action setup
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            // if the clouture action is done data will get removed
            let removeItem = databaseData![indexPath.row]
            self.context.delete(removeItem)
            do{
                try self.context.save()
                databaseData?.remove(at: indexPath.row)
            }
            catch{}
            self.listDatabaseData()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

// custom cell for records data view
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
    }

}

