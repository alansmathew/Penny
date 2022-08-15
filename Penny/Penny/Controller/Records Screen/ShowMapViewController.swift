//
//  ShowMapViewController.swift
//  Penny
//
//  Created by Alan S Mathew on 03/08/22.
//

import UIKit
import CoreLocation
import MapKit

class ShowMapViewController: UIViewController{

    @IBOutlet weak var edditButton: UIButton!
    @IBOutlet weak var setLocationButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    var setLocationData : Trans?
    var tempTypedData : RecordsDataModel?
    var transactionData : Int?
    var loading : (UIActivityIndicatorView,UIView)?
    var coordinate : CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        
        // setting up styles for setlocation button and edditlocation button
        setLocationButton.layer.cornerRadius = 10
        setLocationButton.layer.shadowColor = UIColor.black.cgColor;
        setLocationButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        setLocationButton.layer.shadowOpacity = 0.2;
        setLocationButton.layer.shadowRadius = 10.0;
        setLocationButton.layer.masksToBounds = false;
        
        edditButton.layer.cornerRadius = 10
        edditButton.layer.shadowColor = UIColor.black.cgColor;
        edditButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        edditButton.layer.shadowOpacity = 0.2;
        edditButton.layer.shadowRadius = 10.0;
        edditButton.layer.masksToBounds = false;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // transd is for records that already have a location data in it
        // however if thats nil the data need to be setLocation from the map
        // see line 142 in RecordsViewController
        if let tranid = transactionData{
            transactionEdit(tranid: tranid)
            setLocationButton.isHidden = true
            edditButton.isHidden = false
        }
        else{
            edditButton.isHidden = true
            setLocationButton.isHidden = false
            
            // binding guester control to get location of were user taped
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(triggerTouchAction))
            mapView.addGestureRecognizer(gestureRecognizer)
        }
        tabBarController?.tabBar.isHidden = true
    }
    
    // triggers when user tap on map
    @objc func triggerTouchAction(gestureReconizer: UITapGestureRecognizer) {
        let touch = gestureReconizer.location(in: mapView)
        coordinate = mapView.convert(touch, toCoordinateFrom: mapView)
        
        // removing all other anotations in order to make only the new one
        mapView.removeAnnotations(self.mapView.annotations)
        let anotation = MKPointAnnotation()
        anotation.coordinate = coordinate!
        mapView.addAnnotation(anotation)
        
        // makes a custom small loading animation
        startLoading()
        getAdress(Lat: "\(coordinate!.latitude)", Long: "\(coordinate!.longitude)")
    }
    
    // this function gets the address with currespondence to the latitude and longitude
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
                            // getting into the main thread to change labels and buttons properties
                            DispatchQueue.main.async{
                                self.setLocationButton.setTitle("Add : \(adress)", for: .normal)
                                self.setLocationButton.isEnabled = true
                                self.stopLoading()
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
    
    // function to start loading animation
    func startLoading(){
        loading = customAnimation()
        loadingProtocol(with: loading! ,true)
    }
    
    // function to start loading animation
    func stopLoading(){
            loadingProtocol(with: loading! ,false)
    }
    
    // this button ony activates if the user have location but to edit there records
    // pushes to the add transactionsViewController
    @IBAction func editButtonClick(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AddTransaction", bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier: "AddTransactionsViewController") as! AddTransactionsViewController
        viewC.dataFromRecords = setLocationData!
        navigationController?.pushViewController(viewC, animated: true)
    }
    
    // this button only set the location and save them in a temp file and hand it over to AddTransaction View controller
    @IBAction func addLocationButton(_ sender: UIButton) {
        if let coord = coordinate {
            setLocationData?.lat = "\(coord.latitude)"
            setLocationData?.long = "\(coord.longitude)"
            let storyboard = UIStoryboard(name: "AddTransaction", bundle: nil)
            let viewC = storyboard.instantiateViewController(withIdentifier: "AddTransactionsViewController") as! AddTransactionsViewController
            if let loc = setLocationData{
                viewC.dataFromRecords = loc
            }
            else{
                viewC.locationOnEmptyAdd = coord
            }
            if let temp = tempTypedData {
                viewC.tempTypedData = temp
                viewC.comingFromMap = true
            }
            navigationController?.pushViewController(viewC, animated: true)
        }
    }
    
    // this function shows the location in with the user spended his/ her money
    func transactionEdit(tranid : Int){
        if let transaction = databaseData?[tranid] {
            let regionSpan = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
            var point : MKPointAnnotation = MKPointAnnotation()
            
            var tempLocation : CLLocationCoordinate2D? = CLLocationCoordinate2D()
            if let lat = transaction.lat, let long = transaction.long {
                tempLocation = CLLocationCoordinate2D(latitude: Double(lat) ?? 0.0, longitude: Double(long) ?? 0.00)
                    let tempPoint = MKPointAnnotation()
                tempPoint.coordinate = tempLocation!
                    tempPoint.title = "\(defaultCurrency) \(transaction.amount)"
                    tempPoint.subtitle = transaction.name
                    point = tempPoint
                }

            mapView.addAnnotation(point)

            mapView.showsUserLocation = true
            if let dataAvailabele = tempLocation, dataAvailabele.latitude != CLLocationCoordinate2D().latitude, dataAvailabele.longitude != CLLocationCoordinate2D().longitude{
                let region = MKCoordinateRegion(center: dataAvailabele, span: regionSpan)
                mapView.setRegion(region, animated: true)
            }
        }
    }
}
