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
    

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordsTableView.dataSource = self
        recordsTableView.delegate = self
        
        let tablefooter = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 90))
        recordsTableView.tableFooterView = tablefooter
        
        addButton.layer.cornerRadius = addButton.frame.size.height / 2
        addButton.layer.shadowColor = UIColor.black.cgColor;
        addButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        addButton.layer.shadowOpacity = 0.5;
        addButton.layer.shadowRadius = 10.0;
        addButton.layer.masksToBounds = false;
        
        getDefaultCurrency()
//        print(defaultCurrency);
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        tabBarController?.tabBar.isHidden = false
        recordsTableView.reloadData()
        
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
        totalAmountLabel.text = "\(defaultCurrency)\(totalAmount)"
        totalIncomeLabel.text = "⬆️ \(defaultCurrency)\(totalIncome)"
        totalExpenseLabel.text = "⬇️ \(defaultCurrency)\(totalExpense)"
        
        listDatabaseData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func removeData(){
        listDatabaseData()
        var removeItem = databaseData![0]
        context.delete(removeItem)
        do{
            try context.save()
        }
        catch{}
        listDatabaseData()
        removeItem = databaseData![1]
        context.delete(removeItem)
        do{
            try context.save()
        }
        catch{}
        listDatabaseData()
        
    }
    
    func listDatabaseData(){
        
        let fetchRequest = NSFetchRequest<Trans>(entityName: "Trans")
        let sort = NSSortDescriptor(key: #keyPath(Trans.date), ascending:false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            databaseData = try context.fetch(fetchRequest)
        } catch {}
        recordsTableView.reloadData()
    }
    
    func getDefaultCurrency(){
        if let currency = UserDefaults.standard.string(forKey: "CURRENCY_SYMBOL"){
            defaultCurrency = currency
            defaultCurrencyIndex = UserDefaults.standard.integer(forKey: "CURRENCY_INDEX")
        }
        else{
            defaultCurrency = "$"
        }
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
        databaseData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let data = databaseData
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            let removeItem = databaseData![indexPath.row]
            self.context.delete(removeItem)
            do{
                try self.context.save()
                databaseData?.remove(at: indexPath.row)
            }
            catch{}
            self.recordsTableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [action])
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
    }

}

// title case in transaction cells
// shadows in cells


