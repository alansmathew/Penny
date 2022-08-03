//
//  MainCurrencyViewController.swift
//  Penny
//
//  Created by user207265 on 27/07/22.
//

import UIKit

class MainCurrencyViewController: UIViewController {


    
    @IBOutlet weak var currencyTableView: UITableView!
    let currencies = ["IND","USD","CAD","AUD","AED","EUR","CHF","JPY","NZD","GBP","CNH","RUB"]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyTableView.delegate = self
        currencyTableView.dataSource = self
        
    }
    
    
   
}
extension MainCurrencyViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selcted  \(currencies[indexPath.row])")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = currencyTableView.dequeueReusableCell(withIdentifier: "currency", for: indexPath)
        cell.textLabel?.text = currencies[indexPath.row]
        
        return  cell
    }
}
