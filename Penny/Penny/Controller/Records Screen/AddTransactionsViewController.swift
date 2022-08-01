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
    
    var loading : (UIActivityIndicatorView,UIView)?
    
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
        catogeryLabel.text = selectedCatogery
    }
    override func viewDidAppear(_ animated: Bool) {
        locationManager.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        selectedCatogery = ""
    }
    
    @IBAction func getUserLocationButton(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        loading = customAnimation()               //--- when u want to start loading
        loadingProtocol(with: loading! , true)     //--- above same time
    }
    
    @IBAction func addRecordsClick(_ sender: UIButton) {
        if let date = dateTime, let title = titleTextField.text, let amount = amountTextField.text{
            let catag = catogeryLabel.text ?? "Food"
            let data = RecordsModel(date: date.date, name: title, amount: (amount as NSString).doubleValue, catagory: catag, note: noteTextField.text, type: "income",location:location)
            redorderData.insert(data, at: 0)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func getAdress(Lat : String, Long : String){
        let session = URLSession(configuration: .default)
        let url = "https://open.mapquestapi.com/geocoding/v1/reverse?key=gHjgNhdtZj9B9WiAbYvSDvmo1NU61hWi&location="+Lat+",%20"+Long+"&includeNearestIntersection=true"
        
//        loading = customAnimation()               //--- when u want to start loading
//        loadingProtocol(with: loading! , true)

        let mainUrl = URL(string: url)
        if let tempUrl = mainUrl {
            let networkTask = session.dataTask(with: tempUrl) { data, respose, e in
                let decoder = JSONDecoder()
                if let tempdata = data{
                    do {
                        print("done")
                        let decodedData = try decoder.decode(AdressModel.self, from: tempdata)
                        print("2")
                        if let data = decodedData.results?.first?.locations?[0]{
                            let adress = "\(data.street ?? ""), \(data.adminArea5 ?? ""), \(data.postalCode ?? "")"
                            DispatchQueue.main.async{
                                self.currentLocationLabel.text = "Current location: \(adress)"
                            }
                        }
                    }
                    catch {
                        print("error \(e)")
                    }
                }
            }
            networkTask.resume()
        }

    }
    
    
}
extension AddTransactionsViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            tempCounter += 1
            if tempCounter == 6 {
                location = locations[0].coordinate
                getAdress(Lat: "\(location!.latitude)", Long: "\(location!.longitude)")
                currentLocationLabel.text = "Current location :  \(location!.latitude),\(location!.longitude)"
                locationManager.stopUpdatingLocation()
                tempCounter = 0
                loadingProtocol(with: loading! ,false)    // --- to stop loading
            }
        }
    }
}


// if location on go to maps to show details on the map
// else same page and so details.
