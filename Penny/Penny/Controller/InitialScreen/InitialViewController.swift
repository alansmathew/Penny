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
        
        // checking if the user is opening app for the first time
        // if yes the user catogery database will get added some default catogeries
        // and sets true so that this wont ever happen again (uses USERDEFAULTS TO STORE DATA)
        
        if !UserDefaults.standard.bool(forKey: "FIRST"){
            UserDefaults.standard.set(true, forKey: "FIRST")
            let defaultCatogeries = ["Gas","Shopping","Medicine","Grocery","Transport"]
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            // adding defaultCatogeries to database Catogery
            for x in defaultCatogeries{
                let newCategory = CategoryTable(context: context)
                newCategory.name = x
                do{
                    try context.save()
                }catch{}
            }
            
            // fetching database and storing it in categoryData CONSTANTS FILE
            do{
                categoryData = try context.fetch(CategoryTable.fetchRequest())
            }
            catch{}
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // checking AUTHY key from USERDEFAULTS to know if user enabled faceid authentication
        // if yes asks for faceID Authentication
        if UserDefaults.standard.bool(forKey: "AUTH"){
            let context = LAContext()
            var error: NSError? = nil
            
            // privicy permission
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
                let reason = "Please authorize with touch ID"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
                { [weak self] success,error in
                    
                    // navegating to tab bar controller if sucess
                    if success{
                        DispatchQueue.main.async {
                            self!.performSegue(withIdentifier: "auth", sender: nil)
                        }
                    }
                }
            }
        }
        // this else world only if faceid authentications is turend off
        else{
            performSegue(withIdentifier: "auth", sender: nil)
        }
    }

}
