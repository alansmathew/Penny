//
//  AddCatogeryViewController.swift
//  Penny
//
//  Created by Anu Benoy on 19/07/22.
//

import UIKit
import Charts

class AddCatogeryViewController: UIViewController {

    @IBOutlet weak var catogeryTableView: UITableView!
    @IBOutlet weak var addCatogryButton: UIButton!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var editCategoryLabel: UILabel!
    
    var isEditingCatogeryIndex = -1
    var selectedIndex : IndexPath?
    
    var catogeriess = ["Food", "Grocery", "Gas","Medicines","Shopping"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        catogeryTableView.dataSource = self
        catogeryTableView.delegate = self
        
        categoryTextField.delegate = self
        
        addCatogryButton.layer.borderColor = UIColor.red.cgColor
        addCatogryButton.layer.borderWidth = 0.5
        addCatogryButton.layer.cornerRadius = 5

        // Do any additional setup after loading the view.
    }
    
    @IBAction func savebuttonClick(_ sender: UIButton) {
        if let data = categoryTextField.text, data.trimmingCharacters(in: .whitespacesAndNewlines).count > 0{
            if isEditingCatogeryIndex > -1 && isEditingCatogeryIndex < catogeriess.count{
                catogeriess[isEditingCatogeryIndex] = data.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            else{
                catogeriess.append(data.trimmingCharacters(in: .whitespacesAndNewlines))
            }
            catogeryTableView.reloadData()
            categoryTextField.text = ""
        }
        categoryTextField.text = ""
        selectedIndex = nil
    }
    
    
}

//MARK: - add Catogery datasorce
extension AddCatogeryViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catogeriess.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = catogeryTableView.dequeueReusableCell(withIdentifier: "catogeryIdentifier", for: indexPath) as! customAddCatogeryCell
        let data = catogeriess
        if indexPath.row < data.count{
            cell.catogoryLabel.text = data[indexPath.row]
        }
        return cell
    }
}

//MARK: - add Catogery delegate
extension AddCatogeryViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        editCategoryLabel.text = "Edit caregory"
        categoryTextField.text = catogeriess[indexPath.row];
        isEditingCatogeryIndex = indexPath.row
        selectedIndex = indexPath
        
        categoryTextField.becomeFirstResponder()
//        addCatogryButton.setTitle("Edit", for: .normal);
//        addCatogryButton.layer.borderColor = UIColor.green.cgColor
        //print(indexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            self.catogeriess.remove(at: indexPath.row)
            self.catogeryTableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}

//MARK: - catogery text field edit change
extension AddCatogeryViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.count == 0 {
            editCategoryLabel.text = "New catogery"
            if let index = selectedIndex {
                catogeryTableView.deselectRow(at:index, animated: true)
            }
            selectedIndex = nil
            isEditingCatogeryIndex = -1
            
        }
    }
}
 
class customAddCatogeryCell : UITableViewCell{
    @IBOutlet weak var catogoryLabel: UILabel!
}

