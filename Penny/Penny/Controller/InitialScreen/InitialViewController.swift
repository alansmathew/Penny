//
//  InitialViewController.swift
//  Penny
//
//  Created by Alan S Mathew on 09/08/22.
//

import UIKit
import LocalAuthentication

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UserDefaults.standard.bool(forKey: "FIRST"){
            UserDefaults.standard.set(true, forKey: "FIRST")
            let defaultCatogeries = ["Gas","Shopping","Medicine","Grocery","Transoprt"]
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            for x in defaultCatogeries{
                let newCategory = CategoryTable(context: context)
                newCategory.name = x
                do{
                    try context.save()
                }catch{}
            }
            do{
                categoryData = try context.fetch(CategoryTable.fetchRequest())
            }
            catch{}
        }
            
        
    }
    override func viewDidAppear(_ animated: Bool) {
        print(UserDefaults.standard.bool(forKey: "AUTH"))
        if UserDefaults.standard.bool(forKey: "AUTH"){
            let context = LAContext()
            var error: NSError? = nil
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
                let reason = "Please authorize with touch ID"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
                { [weak self] success,error in
                    if success{
                        DispatchQueue.main.async {
                            self!.performSegue(withIdentifier: "auth", sender: nil)
                        }
                    }
                }
            }
        }
        else{
            performSegue(withIdentifier: "auth", sender: nil)
        }
    }

}
