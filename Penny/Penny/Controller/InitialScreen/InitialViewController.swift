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
//                            print("5")
//                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                            let viewC = storyboard.instantiateViewController(withIdentifier: "initalTabBarContorller") as! initalTabBarContorller
//                            self?.navigationController?.pushViewController(viewC, animated: true)
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
