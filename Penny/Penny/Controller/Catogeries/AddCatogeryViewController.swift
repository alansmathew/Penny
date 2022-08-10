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
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var editCategoryLabel: UILabel!
    
    var isEditingCatogeryIndex = -1
    var selectedIndex : IndexPath?
    
    //setting context to APPDATA of the app thus helps to fetch and save data from and to COREDATA
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        catogeryTableView.dataSource = self
        catogeryTableView.delegate = self
        
        // delegate ro setup new and edit Catogery
        categoryTextField.delegate = self
        
        //sstyling addCatogryButton
        addCatogryButton.layer.borderColor = UIColor.red.cgColor
        addCatogryButton.layer.borderWidth = 0.5
        addCatogryButton.layer.cornerRadius = 5
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchCategory()
    }
    
    // overiding touch so that the keyboard dismises
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            self.view.endEditing(true)
    }
    
    //fetching data from database and storing it in Constants
    func fetchCategory(){
        do{
            categoryData = try context.fetch(CategoryTable.fetchRequest())
            catogeryTableView.reloadData()
        }
        catch{}
    }
    
    @IBAction func savebuttonClick(_ sender: UIButton) {
        if let data = categoryTextField.text, data.trimmingCharacters(in: .whitespacesAndNewlines).count > 0{
            
            // checks of the edetig is going or not
            if isEditingCatogeryIndex > -1 && isEditingCatogeryIndex < categoryData?.count ?? 0{
                let updateData = categoryData![isEditingCatogeryIndex]
                updateData.name = data.trimmingCharacters(in: .whitespacesAndNewlines)
                do{
                    try context.save()
                    fetchCategory()
                }catch{}
            }
            // not editing, adding new catogery
            else{
                var flag = true
                let value = data.trimmingCharacters(in: .whitespacesAndNewlines)
//              cehcking for duplicate records
                if let catogery = categoryData{
                    for x in catogery{
                        if x.name?.lowercased() == value.lowercased() {
                            flag = false
                        }
                    }
                }
                // adds data is its not present in DB
                if flag{
                    let newCategory = CategoryTable(context: self.context)
                    newCategory.name = data.trimmingCharacters(in: .whitespacesAndNewlines)
                    do{
                        try context.save()
                        fetchCategory()
                    }catch{}
                }
//                      showing user alert about catogery
                else{
                    showAlert(title: "Already Added !", message: "The catogery you are trying to add is already in the list.")
                }
            }
            catogeryTableView.reloadData()
            categoryTextField.text = ""
        }
        categoryTextField.text = ""
        selectedIndex = nil
    }
    
    // error message prompt
    func showAlert(title : String, message : String){
            let alertmessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertmessage.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alertmessage ,animated: true, completion: nil)
        }
    
}

//MARK: - add Catogery datasorce
extension AddCatogeryViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = catogeryTableView.dequeueReusableCell(withIdentifier: "catogeryIdentifier", for: indexPath) as! customAddCatogeryCell
        let image = UIImageView(image: UIImage(named: "editIcon"))
        cell.accessoryView = image
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
    // editing is done when user select a catogery
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editCategoryLabel.text = "Edit Category"
        categoryTextField.text = categoryData?[indexPath.row].name ?? "";
        isEditingCatogeryIndex = indexPath.row
        selectedIndex = indexPath
        
        categoryTextField.becomeFirstResponder()
        
    }
    
    
// ---------- coming in next update  (deleting catogery)-------
    
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
// ------------------
}

//MARK: - catogery text field edit change
extension AddCatogeryViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    // if there is no data in textbox -> edit reocrds changes to new record
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
 
// custom class for catogery cell
class customAddCatogeryCell : UITableViewCell{
    @IBOutlet weak var catogoryLabel: UILabel!
}

