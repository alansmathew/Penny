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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        catogeryCollectionView.dataSource = self
        catogeryCollectionView.delegate = self
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.showsUserLocation = true
        
        fetchCategory()
        do {
            databaseData = try context.fetch(Trans.fetchRequest())
        } catch {}
        
        let regionSpan = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        var points : [MKPointAnnotation] = []
        
        var tempLocation : CLLocationCoordinate2D? = CLLocationCoordinate2D()
        if let data = databaseData{
            for x in data {
                let lat = Double(x.lat ?? "0.0")!
                let long = Double(x.long ?? "0.0")!
                tempLocation = CLLocationCoordinate2D(latitude:lat, longitude: long)
                if let loc = tempLocation {
                    tempLocation = loc
                    let tempPoint = MKPointAnnotation()
                    tempPoint.coordinate = loc
                    tempPoint.title = "\(defaultCurrency) \(x.amount)"
                    tempPoint.subtitle = x.name
                    points.append(tempPoint)
                }
            }
        }
    
        mapView.addAnnotations(points)

        mapView.showsUserLocation = true
        if let dataAvailabele = tempLocation, dataAvailabele.latitude != CLLocationCoordinate2D().latitude, dataAvailabele.longitude != CLLocationCoordinate2D().longitude{
            let region = MKCoordinateRegion(center: dataAvailabele, span: regionSpan)
            mapView.setRegion(region, animated: true)
        }

    }
    
    func fetchCategory(){
        do{
            categoryData = try context.fetch(CategoryTable.fetchRequest())
            catogeryCollectionView.reloadData()
        }
        catch{}
    }
}

//MARK: - location Delegate
extension MapViewController : CLLocationManagerDelegate{
}

//MARK: - collection View data source
extension MapViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = catogeryCollectionView.dequeueReusableCell(withReuseIdentifier: "catogeryColeectionMaoIdentifier", for: indexPath) as! CollectionViewMap
        if let data = categoryData{
            if indexPath.row < data.count {
                cell.titleLabel.text = data[indexPath.row].name
            }
        }
        return cell
    }
    
    
}


//MARK: - collection Viewdelegate
extension MapViewController : UICollectionViewDelegate{

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        let regionSpan = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        var points : [MKPointAnnotation] = []
        
        var tempLocation : CLLocationCoordinate2D? = CLLocationCoordinate2D()
        
//        for x in redorderData {
//            if let loc = x.location {
//                if(x.catagory==Constants().catogeries[indexPath.row]){
//                    tempLocation = loc
//                    let tempPoint = MKPointAnnotation()
//                    tempPoint.coordinate = loc
//                    tempPoint.title = "\(defaultCurrency) \(x.amount!)"
//                    tempPoint.subtitle = x.name
//                    points.append(tempPoint)
//                }
//            }
//        }
        
        if let data = databaseData, let cat = categoryData{
            for x in data {
                if(x.catagory == cat[indexPath.row].name){
                    let lat = Double(x.lat ?? "0.0")!
                    let long = Double(x.long ?? "0.0")!
                    tempLocation = CLLocationCoordinate2D(latitude:lat, longitude: long)
                    if let loc = tempLocation {
                        tempLocation = loc
                        let tempPoint = MKPointAnnotation()
                        tempPoint.coordinate = loc
                        tempPoint.title = "\(defaultCurrency) \(x.amount)"
                        tempPoint.subtitle = x.name
                        points.append(tempPoint)
                    }
                }
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
