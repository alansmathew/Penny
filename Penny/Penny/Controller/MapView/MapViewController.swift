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
    @IBOutlet weak var catogeryCollectionView: UICollectionView!
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        catogeryCollectionView.dataSource = self
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

//MARK: - location Delegate
extension MapViewController : CLLocationManagerDelegate{
}

//MARK: - collection View Delegate
extension MapViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants().catogeries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = catogeryCollectionView.dequeueReusableCell(withReuseIdentifier: "catogeryColeectionMaoIdentifier", for: indexPath) as! CollectionViewMap
        let data = Constants().catogeries
        if indexPath.row < data.count {            cell.titleLabel.text = data[indexPath.row]
        }
        return cell
    }
    
    
}

class CollectionViewMap : UICollectionViewCell{
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
     
    override func awakeFromNib() {
            super.awakeFromNib()
        cellContentView.layer.cornerRadius = 10
        cellContentView.layer.shadowColor = UIColor.black.cgColor;
        cellContentView.layer.shadowOffset = CGSize(width: 0, height: 5)
        cellContentView.layer.shadowOpacity = 0.5;
        cellContentView.layer.shadowRadius = 4.0;
        cellContentView.layer.masksToBounds = false;
            
        }
}
