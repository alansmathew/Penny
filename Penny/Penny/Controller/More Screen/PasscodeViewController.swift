//
//  PasscodeViewController.swift
//  Penny
//
//  Created by user207265 on 27/07/22.
//
import LocalAuthentication
import UIKit

class PasscodeViewController: UIViewController {

    
    
//    @IBAction func FaceIDFunction(_ sender: Any) {
//        if FaceID.isOn==true{
//            let context = LAContext()
//            var error: NSError? = nil
//            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
//                let reason = "Please authorize with touch ID"
//                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
//                                       { [weak self] success,error in
//                    DispatchQueue.main.async {
//                        guard success, error == nil else{
//                            let alert = UIAlertController(title: "Fail to Authenticate ", message: "Please try again", preferredStyle: .alert)
//                            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
//
//                            self?.present(alert,animated: true)
//                            return
//                    }
//                    /*let vc = UIViewController()
//                        vc.title = "Welcome"*/
//                    }
//
//                }
//
//    }
//            else{
//                let alert = UIAlertController(title: "Unavailable", message: "You can't use this feature", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
//                present(alert,animated: true)
//            }
//    }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

