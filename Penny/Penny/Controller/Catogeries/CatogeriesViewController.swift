//
//  CatogeriesViewController.swift
//  Penny
//
//  Created by Anu Benoy on 19/07/22.
//

import UIKit

class CatogeriesViewController: UIViewController {

    @IBOutlet weak var catogeriesCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        catogeriesCollectionView.dataSource = self
        catogeriesCollectionView.delegate = self
    }

}

//MARK: - catogeries dataSorce
extension CatogeriesViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Constants().catogeries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = catogeriesCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewIdentifier", for: indexPath) as! catogeryCollectionViewCell
        let data = Constants().catogeries
        if indexPath.row < data.count {
            cell.titleLabel.text = data[indexPath.row]
            cell.collectionView.layer.borderWidth = 0.3
            cell.collectionView.layer.borderColor = Constants().greenColor.cgColor
            cell.collectionView.layer.cornerRadius = 5
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
        selectedCatogery = Constants().catogeries[indexPath.row]
        self.navigationController?.popViewController(animated: true)
    }
}

