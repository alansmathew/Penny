//
//  MainCurrencyViewController.swift
//  Penny
//
//  Created by user207265 on 27/07/22.
//

import UIKit

class MainCurrencyViewController: UIViewController {
    
    @IBOutlet weak var currentCurrencyView: UIView!
    @IBOutlet weak var currencyTableView: UITableView!
   
    @IBOutlet weak var currentCurrencyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyTableView.delegate = self
        currencyTableView.dataSource = self
        
        currentCurrencyView.layer.cornerRadius = 10
        currentCurrencyView.layer.shadowColor = UIColor.black.cgColor;
        currentCurrencyView.layer.shadowOffset = CGSize(width: 0, height: 2)
        currentCurrencyView.layer.shadowOpacity = 0.2;
        currentCurrencyView.layer.shadowRadius = 10.0;
        currentCurrencyView.layer.masksToBounds = false;
        currentCurrencyLabel.text = "\(currencyCounrty[defaultCurrencyIndex]) \(defaultCurrency)"
    }
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }

}
extension MainCurrencyViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyCounrty.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = currencyTableView.dequeueReusableCell(withIdentifier: "currency", for: indexPath) as! CustomCurrencyCell
        cell.countryLabel.text = currencyCounrty[indexPath.row]
        cell.currencySymbol.text = currencySymbol[indexPath.row]
        return cell
    }
}

extension MainCurrencyViewController :  UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defaultCurrency = currencySymbol[indexPath.row]
        defaultCurrencyIndex = indexPath.row
        UserDefaults.standard.set(currencySymbol[indexPath.row], forKey: "CURRENCY_SYMBOL")
        UserDefaults.standard.set(indexPath.row, forKey: "CURRENCY_INDEX")
        currentCurrencyLabel.text = "\(currencyCounrty[defaultCurrencyIndex]) \(defaultCurrency)"
        tableView.deselectRow(at: indexPath, animated: true)
//        print(UserDefaults.standard.string(forKey: "CURRENCY_SYMBOL"))
    }
}

class CustomCurrencyCell : UITableViewCell{
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var currencySymbol: UILabel!
}
