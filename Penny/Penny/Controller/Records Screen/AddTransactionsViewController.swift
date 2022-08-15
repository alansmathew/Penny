//
//  AddTransactionsViewController.swift
//  Penny
//
//  Created by user206161 on 7/26/22.
//

import UIKit
import CoreLocation

class AddTransactionsViewController: UIViewController {

    @IBOutlet weak var segnment: UISegmentedControl!
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
    
    var dataFromRecords : Trans?
    var tempTypedData : RecordsDataModel?
    var comingFromMap = false
    var locationOnEmptyAdd : CLLocationCoordinate2D?
    // We set locationManager object to the CLLocationmanager -Delegat
    let locationManager = CLLocationManager()
    var tempCounter = 0
    var location : CLLocationCoordinate2D?
    var loading : (UIActivityIndicatorView,UIView)?
    //We set context by adding core data to app
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        
        dateTime.maximumDate = Date()
    }
    
    //Dismiss keyboard with Tap
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            self.view.endEditing(true)
        }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        catogeryLabel.text = selectedCatogery
        
        if let dataRecord = dataFromRecords{
            setupEditScreen(data: dataRecord)
        }
        
        if let data = tempTypedData, comingFromMap{
            setupTypedData(data: data)
            print("this happens")
        }
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager.delegate = self
        if let loc = locationOnEmptyAdd{
            location = loc
            getAdress(Lat: "\(loc.latitude)", Long: "\(loc.longitude)")
        }
 
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        selectedCatogery = ""
    }
    
    //Edit transactions this only works when the dataFromRecords is not nil
    func setupEditScreen(data : Trans){
        segnment.selectedSegmentIndex = data.type == "income" ? 0 : 1
        dateTime.date = data.date!
        titleTextField.text = data.name
        amountTextField.text = "\(data.amount)"
        catogeryLabel.text = selectedCatogery.count > 0 ? selectedCatogery : data.catagory!
        noteTextField.text = data.note ?? ""
        addExpenseButton.setTitle("Edit Record", for: .normal)
        if let lat = data.lat, let long = data.long {
            location = CLLocationCoordinate2D(latitude: Double(lat) ?? 0.0, longitude: Double(long) ?? 0.00)
            getAdress(Lat: lat, Long: long)
        }
    }
    
    //storing typed data
    func setupTypedData(data : RecordsDataModel){
        segnment.selectedSegmentIndex = data.type == "income" ? 0 : 1
        dateTime.date = data.date!
        titleTextField.text = data.name
        amountTextField.text = "\(data.amount!)"
        catogeryLabel.text = selectedCatogery.count > 0 ? selectedCatogery : data.category
        noteTextField.text = data.note ?? ""
        comingFromMap = false
    }
    
    
    @IBAction func getUserLocationButton(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        loading = customAnimation()               //--- when u want to start loading
        loadingProtocol(with: loading! , true)     //--- above same time
    }
    
    @IBAction func addRecordsClick(_ sender: UIButton) {
        if let date = dateTime, let title = titleTextField.text, let amount = amountTextField.text,
           titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 0, amountTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 0,
           let cat = catogeryLabel.text,catogeryLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 0{
            
            if let data = dataFromRecords{
                data.name = title.trimmingCharacters(in: .whitespacesAndNewlines)
                data.catagory = cat
                data.date = date.date
                data.amount = Double(amount) ?? 0.0
                //fetch the value of segment controller and assign to type variable
                data.type = segnment.selectedSegmentIndex == 0 ? "income" : "expense"
                data.note = noteTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if let loc = location{
                    data.lat = "\(loc.latitude)"
                    data.long = "\(loc.longitude)"
                }
            }
            else{
                let newRecord = Trans(context: self.context)
                newRecord.name = title.trimmingCharacters(in: .whitespacesAndNewlines)
                newRecord.catagory = cat
                newRecord.date = date.date
                newRecord.amount = Double(amount) ?? 0.0
                //fetch the value of segment controller and assign to type variable
                newRecord.type = segnment.selectedSegmentIndex == 0 ? "income" : "expense"
                newRecord.note = noteTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if let loc = location{
                    newRecord.lat = "\(loc.latitude)"
                    newRecord.long = "\(loc.longitude)"
                }
                
            }
            do {
                try self.context.save()
                navigationController?.popToRootViewController(animated: true)
            }
            catch {
                //alert the user when they miss required fields
                showAlert(title: "Something Went Wrong", message:"Sorry we cannot add data to database!! Please try again")
            }
        }
        else
        {
            showAlert(title:"Invalid Input", message: "Date,Title,Amount and Category are required fields!!")
        }
    }
    
    //set location of previous transactions
    @IBAction func setLocationButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AddTransaction", bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier: "ShowMapViewController") as! ShowMapViewController
     
        //storing typed data and passing it to next screen
        tempTypedData = RecordsDataModel()
        tempTypedData?.name = titleTextField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        tempTypedData?.category = catogeryLabel.text ?? ""
        tempTypedData?.date = dateTime.date
        tempTypedData?.amount = Double(amountTextField?.text ?? "0") ?? 0.0
        tempTypedData?.type = segnment.selectedSegmentIndex == 0 ? "income" : "expense"
        tempTypedData?.note = noteTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        viewC.tempTypedData = tempTypedData
            
        viewC.setLocationData = dataFromRecords
        navigationController?.pushViewController(viewC, animated: true)
    }
    
    //function for getting alert
    func showAlert(title : String, message : String){
            let alertmessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertmessage.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alertmessage ,animated: true, completion: nil)
        }
    
    //function for getting address of the location
    func getAdress(Lat : String, Long : String){
        let session = URLSession(configuration: .default)
        let url = "https://open.mapquestapi.com/geocoding/v1/reverse?key=gHjgNhdtZj9B9WiAbYvSDvmo1NU61hWi&location="+Lat+",%20"+Long+"&includeNearestIntersection=true"

        let mainUrl = URL(string: url)
        if let tempUrl = mainUrl {
            let networkTask = session.dataTask(with: tempUrl) { data, respose, e in
                let decoder = JSONDecoder()
                if let tempdata = data{
                    do {
                        let decodedData = try decoder.decode(AdressModel.self, from: tempdata)
                        if let data = decodedData.results?.first?.locations?[0]{
                            let adress = "\(data.street ?? ""), \(data.adminArea5 ?? ""), \(data.postalCode ?? "")"
                            DispatchQueue.main.async{
                                // getting onto main thread
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
            // temp counter is for increesed accuracy of lat and long
//            tempCounter += 1
            if tempCounter == 0 {
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

