//
//  ShowMapViewController.swift
//  Penny
//
//  Created by Alan S Mathew on 03/08/22.
//

import UIKit
import CoreLocation
import MapKit

class ShowMapViewController: UIViewController {


    @IBOutlet weak var mapView: MKMapView!
    var transactionData : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let tranid = transactionData{
            transactionEdit(tranid: tranid)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
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
