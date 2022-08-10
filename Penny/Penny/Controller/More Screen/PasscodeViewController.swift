//
//  PasscodeViewController.swift
//  Penny
//
//  Created by user207265 on 27/07/22.
//
import UIKit
import LocalAuthentication

class PasscodeViewController: UIViewController {

    @IBOutlet weak var authSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        // changing Auth switch state accordin to saved data
        if UserDefaults.standard.bool(forKey: "AUTH") {
            authSwitch.isOn = true
        }
        else{
            authSwitch.isOn = false
        }
    }
    
    @IBAction func faceIdSwitch(_ sender: UISwitch) {
        if sender.isOn {
            let context = LAContext()
            var error: NSError? = nil
            // asking privicy permission
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
                let reason = "Please authorize with touch ID"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
                { [weak self] success,error in
                    if success{
//                      saving if sucesssfully evuvalated faceID
                        UserDefaults.standard.set(true, forKey: "AUTH")
                    }
                }
            }
        }
        // works when its turened is turned off
        else{
            UserDefaults.standard.set(false, forKey: "AUTH")
        }
    }
    

}

