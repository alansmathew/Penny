//
//  File.swift
//  Penny
//
//  Created by Alan S Mathew on 22/07/22.
//

import UIKit

extension UIViewController {
    
//    --------------------------------- usage ---------------------------------
    
//    var loading : (NVActivityIndicatorView,UIView)? ------ as in class file
//    loading = customAnimation()  --- when u want to start loading
//    loadingProtocol(with: loading! ,true)  --- above same time
//    loadingProtocol(with: loading! ,false) --- to stop loading
    
    //MARK: custom loadng view
    func customAnimation() -> (UIActivityIndicatorView,UIView){
    
    let parentView : UIView = {
        let myView = UIView()
        myView.translatesAutoresizingMaskIntoConstraints = false
        myView.backgroundColor = .white
        return myView
    }()
    let actualAnimationView : UIActivityIndicatorView = {
        let myView = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0,width: 70,height: 70))
        myView.tintColor = UIColor.blue
        myView.translatesAutoresizingMaskIntoConstraints = false
        return myView
    }()
    
    view.addSubview(parentView)
    parentView.addSubview(actualAnimationView)
    
    var constr = [NSLayoutConstraint]()
    constr.append(parentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor))
    constr.append(parentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
    constr.append(parentView.bottomAnchor.constraint(equalTo: view.superview!.bottomAnchor))
    constr.append(parentView.topAnchor.constraint(equalTo: view.superview!.topAnchor))
    
    constr.append(actualAnimationView.heightAnchor.constraint(equalToConstant: 60))
    constr.append(actualAnimationView.widthAnchor.constraint(equalToConstant: 60))
    constr.append(actualAnimationView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor))
    constr.append(actualAnimationView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor))

    NSLayoutConstraint.activate(constr)
    
    return (actualAnimationView,parentView)
}
 
    // creates a loading animation and show it into the users current screen
    func loadingProtocol(with : (UIActivityIndicatorView,UIView),_ status : Bool){
        if status {
            with.0.startAnimating()
            with.1.isHidden = false
            with.1.alpha = 0.9
        }
        else{
            with.0.stopAnimating()
            with.1.isHidden = true
        }
    }
}
