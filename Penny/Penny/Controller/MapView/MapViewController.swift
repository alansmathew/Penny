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
    
    // We set manager object to the CLLocationmanager -Delegate
    let manager = CLLocationManager()
    //We set context by adding core data to app
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // used didAppear once map shows up to register values for GPS location servies
    // setting properties of manager and catogeryCollectiomView
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
        
        // span determines the scale of our zooming into the map
        let regionSpan = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        var points : [MKPointAnnotation] = []
        var tempLocation : CLLocationCoordinate2D? = CLLocationCoordinate2D()
        
        //setting coordinate, title(amount), subtitle(name) for the data from data base
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
        // add points to the map view
        mapView.addAnnotations(points)
        //show user the location in map view
        mapView.showsUserLocation = true
        if let dataAvailabele = tempLocation, dataAvailabele.latitude != CLLocationCoordinate2D().latitude, dataAvailabele.longitude != CLLocationCoordinate2D().longitude{
            let region = MKCoordinateRegion(center: dataAvailabele, span: regionSpan)
            mapView.setRegion(region, animated: true)
        }

    }
    //fetch category from data base
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
    // collection view of category
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
        
        // span determines the scale of our zooming into the map
        let regionSpan = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        var points : [MKPointAnnotation] = []
        
        var tempLocation : CLLocationCoordinate2D? = CLLocationCoordinate2D()

        //filtering location based on category
        //setting coordinate, title(amount), subtitle(name) for the data from data base
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
        //add points to mapview
        mapView.addAnnotations(points)
        //show user the location in map view
        mapView.showsUserLocation = true
        if let dataAvailabele = tempLocation, dataAvailabele.latitude != CLLocationCoordinate2D().latitude, dataAvailabele.longitude != CLLocationCoordinate2D().longitude{
            let region = MKCoordinateRegion(center: dataAvailabele, span: regionSpan)
            mapView.setRegion(region, animated: true)
        }
    
    }
}

//collection view cell of categories
class CollectionViewMap : UICollectionViewCell{
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
     
    override func awakeFromNib() {
            super.awakeFromNib()
        // setting some styles for catogery view cell
        cellContentView.layer.cornerRadius = 10
        cellContentView.layer.shadowColor = UIColor.black.cgColor;
        cellContentView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cellContentView.layer.shadowOpacity = 0.5;
        cellContentView.layer.shadowRadius = 4.0;
        cellContentView.layer.masksToBounds = false;
            
        }
}
