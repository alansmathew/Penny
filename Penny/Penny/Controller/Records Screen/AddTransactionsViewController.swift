//
//  AddTransactionsViewController.swift
//  Penny
//
//  Created by user206161 on 7/26/22.
//

import UIKit
import CoreLocation

class AddTransactionsViewController: UIViewController {

    @IBOutlet weak var dateTime: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var catogeryLabel: UILabel!
    @IBOutlet weak var noteTextField: UITextField!
    
    @IBOutlet weak var catogeryView: UIView!
    @IBOutlet weak var setLocation: UIButton!
    @IBOutlet weak var getLocation: UIButton!
    @IBOutlet weak var addExpenseButton: UIButton!
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var tempCounter = 0
    var location : CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addExpenseButton.layer.borderWidth = 0.3
        addExpenseButton.layer.cornerRadius = 10
        addExpenseButton.layer.borderColor = Constants().redColor.cgColor
        addExpenseButton.layer.shadowColor = UIColor.black.cgColor;
        addExpenseButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        addExpenseButton.layer.shadowOpacity = 0.2;
        addExpenseButton.layer.shadowRadius = 10.0;
        addExpenseButton.layer.masksToBounds = false;
        
        getLocation.layer.cornerRadius = 5
        setLocation.layer.cornerRadius = 5
        setLocation.layer.borderWidth = 0.5
        setLocation.layer.borderColor = UIColor.link.cgColor
        
        catogeryView.layer.borderColor = UIColor.gray.cgColor
        catogeryView.layer.borderWidth = 0.15
        catogeryView.layer.cornerRadius = 5
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        locationManager.delegate = self
    }
    
    @IBAction func getUserLocationButton(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func addRecordsClick(_ sender: UIButton) {
        if let date = dateTime, let title = titleTextField.text, let amount = amountTextField.text{
            let catag = catogeryLabel.text ?? "Food"
            let data = RecordsModel(date: date.date, name: title, amount: (amount as NSString).doubleValue, catagory: catag, note: noteTextField.text, type: "income",location:location)
            redorderData.insert(data, at: 0)
            navigationController?.popViewController(animated: true)
        }
    }
    
    
}
extension AddTransactionsViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            tempCounter += 1
            if tempCounter == 6 {
                location = locations[0].coordinate
                currentLocationLabel.text = "Current location :  \(location!.latitude),\(location!.longitude)"
                locationManager.stopUpdatingLocation()
                tempCounter = 0
            }
        }
    }
}


// if location on go to maps to show details on the map
// else same page and so details.
