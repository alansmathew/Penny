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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    override func viewDidAppear(_ animated: Bool) {
        fetchCategory()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            self.view.endEditing(true)
    }
    
    func fetchCategory(){
        do{
            categoryData = try context.fetch(CategoryTable.fetchRequest())
            catogeryTableView.reloadData()
        }
        catch{}
    }
    
    @IBAction func savebuttonClick(_ sender: UIButton) {
        if let data = categoryTextField.text, data.trimmingCharacters(in: .whitespacesAndNewlines).count > 0{
            if isEditingCatogeryIndex > -1 && isEditingCatogeryIndex < categoryData?.count ?? 0{
                let updateData = categoryData![isEditingCatogeryIndex]
                updateData.name = data.trimmingCharacters(in: .whitespacesAndNewlines)
                do{
                    try context.save()
                    fetchCategory()
                }catch{}
            }
            else{
                let newCategory = CategoryTable(context: self.context)
                newCategory.name = data.trimmingCharacters(in: .whitespacesAndNewlines)
                do{
                    try context.save()
                    fetchCategory()
                }catch{}
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
        return categoryData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = catogeryTableView.dequeueReusableCell(withIdentifier: "catogeryIdentifier", for: indexPath) as! customAddCatogeryCell
        if let data = categoryData{
            if indexPath.row < data.count{
                cell.catogoryLabel.text = data[indexPath.row].name
            }
        }
        return cell
    }
}

//MARK: - add Catogery delegate
extension AddCatogeryViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        editCategoryLabel.text = "Edit Category"
        categoryTextField.text = categoryData?[indexPath.row].name ?? "";
        isEditingCatogeryIndex = indexPath.row
        selectedIndex = indexPath
        
        categoryTextField.becomeFirstResponder()
        
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
//            let removeItem = categoryData![indexPath.row]
//            self.context.delete(removeItem)
//            do{
//                try self.context.save()
//            }
//            catch{}
//            self.fetchCategory()
//        }
//        return UISwipeActionsConfiguration(actions: [action])
//    }
}

//MARK: - catogery text field edit change
extension AddCatogeryViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.count == 0 {
            editCategoryLabel.text = "New Category"
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

