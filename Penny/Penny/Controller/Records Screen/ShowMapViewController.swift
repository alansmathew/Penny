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
    var transactionData : Int?
    var loading : (UIActivityIndicatorView,UIView)?
    var coordinate : CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        
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
        if let tranid = transactionData{
            transactionEdit(tranid: tranid)
            setLocationButton.isHidden = true
            edditButton.isHidden = false
        }
        else{
            edditButton.isHidden = true
            setLocationButton.isHidden = false
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(triggerTouchAction))
            mapView.addGestureRecognizer(gestureRecognizer)
        }
        tabBarController?.tabBar.isHidden = true
    }
    
    @objc func triggerTouchAction(gestureReconizer: UITapGestureRecognizer) {
        let touch = gestureReconizer.location(in: mapView)
        coordinate = mapView.convert(touch, toCoordinateFrom: mapView)
        mapView.removeAnnotations(self.mapView.annotations)
        let anotation = MKPointAnnotation()
        anotation.coordinate = coordinate!
        mapView.addAnnotation(anotation)
        startLoading()
        getAdress(Lat: "\(coordinate!.latitude)", Long: "\(coordinate!.longitude)")
    }
    
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
    
    func startLoading(){
        loading = customAnimation()
        loadingProtocol(with: loading! ,true)
    }
    
    func stopLoading(){
            loadingProtocol(with: loading! ,false)
    }
    
    @IBAction func editButtonClick(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AddTransaction", bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier: "AddTransactionsViewController") as! AddTransactionsViewController
        viewC.dataFromRecords = setLocationData!
        navigationController?.pushViewController(viewC, animated: true)
    }
    
    @IBAction func addLocationButton(_ sender: UIButton) {
        if let coord = coordinate {
            setLocationData?.lat = "\(coord.latitude)"
            setLocationData?.long = "\(coord.longitude)"
            let storyboard = UIStoryboard(name: "AddTransaction", bundle: nil)
            let viewC = storyboard.instantiateViewController(withIdentifier: "AddTransactionsViewController") as! AddTransactionsViewController
            viewC.dataFromRecords = setLocationData!
            navigationController?.pushViewController(viewC, animated: true)
        }
    }
    
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
