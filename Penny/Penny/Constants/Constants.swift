//
//  Constants.swift
//  Penny
//
//  Created by Alan S Mathew on 19/07/22.
//

import Foundation
import UIKit
import CoreLocation

let now = Date()
var totalAmount = 0.0
var totalIncome = 0.0
var totalExpense = 0.0

var selectedCatogery = ""

//database data comes here
var databaseData:[Trans]?

var redorderData = [
    RecordsModel(date: now, name: "Pectrol", amount: 20.00, catagory: "Gas",type: "expense", location:CLLocationCoordinate2D(latitude: 37.33019702, longitude: -122.02471061)),
    RecordsModel(date: Date(timeIntervalSinceNow: -1.33), name: "Wallmart", amount: 20.00, catagory: "Grocery",type: "expense", location:CLLocationCoordinate2D(latitude: 37.33119702, longitude: -122.02551061)),
    RecordsModel(date: Date(timeIntervalSinceNow: -2.33), name: "Lancaster Smockhouse", amount: 20.00, catagory: "Food",type: "expense", location:CLLocationCoordinate2D(latitude: 37.33219702, longitude: -122.02671061)),
    RecordsModel(date: now, name: "Pectrol", amount: 60.00, catagory: "Gas",type: "expense", location:CLLocationCoordinate2D(latitude: 37.33319702, longitude: -122.02771061)),
    RecordsModel(date: Date(timeIntervalSinceNow: -1.88), name: "Wallmart", amount: 70.00, catagory: "Grocery",type: "expense", location:CLLocationCoordinate2D(latitude: 37.33419702, longitude: -122.02871061)),
    RecordsModel(date: Date(timeIntervalSinceNow: -2.33), name: "Lancaster Smockhouse", amount: 20.00, catagory: "Food",type: "expense", location:CLLocationCoordinate2D(latitude: 37.33519702, longitude: -122.02971061)),
    RecordsModel(date: now, name: "Pectrol", amount: 20.00, catagory: "Gas",type: "expense", location:CLLocationCoordinate2D(latitude: 37.33019702, longitude: -122.02471061)),
    RecordsModel(date: Date(timeIntervalSinceNow: -1.93), name: "Wallmart", amount: 20.00, catagory: "Grocery",type: "expense", location:CLLocationCoordinate2D(latitude: 37.33619702, longitude: -122.02351061)),
    RecordsModel(date: Date(timeIntervalSinceNow: -2.33), name: "Lancaster Smockhouse", amount: 20.00, catagory: "Food",type: "expense", location:CLLocationCoordinate2D(latitude: 37.33719702, longitude: -122.02581061)),
    RecordsModel(date: now, name: "Innovation", amount: 5000.00, catagory: "Income",type: "income", location:CLLocationCoordinate2D(latitude: 37.33019702, longitude: -122.01571061)),
    RecordsModel(date: now, name: "Innovation", amount: 5000.00, catagory: "Income",type: "income",location:CLLocationCoordinate2D(latitude: 37.33819702, longitude: -122.02341061)),
]

struct Constants {
    // colors
    let greenColor = UIColor(red: 0.00, green: 0.45, blue: 0.39, alpha: 1.00)
    let redColor = UIColor.red
    
    let menuItems = ["Main currency settings","Passcode","Info","Feedback"]
    let catogeries = ["Food", "Grocery", "Gas","Medicines","Shopping"]
}
