//
//  CatogeriesViewController.swift
//  Penny
//
//  Created by Anu Benoy on 19/07/22.
//

import UIKit

class CatogeriesViewController: UIViewController {

    @IBOutlet weak var catogeriesCollectionView: UICollectionView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        catogeriesCollectionView.dataSource = self
        catogeriesCollectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        addCategory()
        fetchCategory()
    }
    
    //func to fetch categories from db
    func fetchCategory(){
        do{
            categoryData = try context.fetch(CategoryTable.fetchRequest())
            catogeriesCollectionView.reloadData()
        }
        catch{}
    }
    
    //save new categories in db
    func addCategory(){
        let newCategory = CategoryTable(context: self.context)
        newCategory.name = "Grocery"
        do{
            try context.save()
        }catch{}
    }

}

//MARK: - catogeries dataSorce
extension CatogeriesViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoryData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = catogeriesCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewIdentifier", for: indexPath) as! catogeryCollectionViewCell
        if let data = categoryData {
            if indexPath.row < data.count {
                cell.titleLabel.text = data[indexPath.row].name
                cell.collectionView.layer.borderWidth = 0.3
                cell.collectionView.layer.borderColor = Constants().greenColor.cgColor
                cell.collectionView.layer.cornerRadius = 5
            }
        }
        return cell
    }
    
    
}

//MARK: - catogeries layout size
extension CatogeriesViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width/3)-15, height: 60)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
}

class catogeryCollectionViewCell : UICollectionViewCell{
    @IBOutlet weak var collectionView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
}

//MARK: - collection view delegate
extension CatogeriesViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCatogery = categoryData?[indexPath.row].name ?? ""
        self.navigationController?.popViewController(animated: true)
    }
}

