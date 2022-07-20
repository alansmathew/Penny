//
//  MapViewController.swift
//  Penny
//
//  Created by user207723 on 7/19/22.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.showsUserLocation = true
        
        let regionSpan = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        var points : [MKPointAnnotation] = []
        
        var tempLocation : CLLocationCoordinate2D? = CLLocationCoordinate2D()
        for x in redorderData {
            if let loc = x.location {
                tempLocation = loc
                let tempPoint = MKPointAnnotation()
                tempPoint.coordinate = loc
                tempPoint.title = "$ \(x.amount!)"
                tempPoint.subtitle = x.name
                points.append(tempPoint)
            }
        }
    
        mapView.addAnnotations(points)

        mapView.showsUserLocation = true
        if let dataAvailabele = tempLocation, dataAvailabele.latitude != CLLocationCoordinate2D().latitude, dataAvailabele.longitude != CLLocationCoordinate2D().longitude{
            let region = MKCoordinateRegion(center: dataAvailabele, span: regionSpan)
            mapView.setRegion(region, animated: true)
        }
       

    }
}

extension MapViewController : CLLocationManagerDelegate{
}
