//
//  initalTabBarContorller.swift
//  Penny
//
//  Created by Alan S Mathew on 09/08/22.
//

import UIKit

class initalTabBarContorller: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //setting up potrate lock orientation for iPhone
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
     }
    
}
