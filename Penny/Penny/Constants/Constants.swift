//
//  Constants.swift
//  Penny
//
//  Created by Alan S Mathew on 19/07/22.
//

import Foundation
import UIKit

let now = Date()
var totalAmount = 0.0
var totalIncome = 0.0
var totalExpense = 0.0

var redorderData = [
    RecordsModel(date: now, name: "Pectrol", amount: 20.00, catagory: "Gas",type: "expense"),
    RecordsModel(date: Date(timeIntervalSinceNow: -1.33), name: "Wallmart", amount: 20.00, catagory: "Grocery",type: "expense"),
    RecordsModel(date: Date(timeIntervalSinceNow: -2.33), name: "Lancaster Smockhouse", amount: 20.00, catagory: "Food",type: "expense"),
    RecordsModel(date: now, name: "Pectrol", amount: 60.00, catagory: "Gas",type: "expense"),
    RecordsModel(date: Date(timeIntervalSinceNow: -1.88), name: "Wallmart", amount: 70.00, catagory: "Grocery",type: "expense"),
    RecordsModel(date: Date(timeIntervalSinceNow: -2.33), name: "Lancaster Smockhouse", amount: 20.00, catagory: "Food",type: "expense"),
    RecordsModel(date: now, name: "Pectrol", amount: 20.00, catagory: "Gas",type: "expense"),
    RecordsModel(date: Date(timeIntervalSinceNow: -1.93), name: "Wallmart", amount: 20.00, catagory: "Grocery",type: "expense"),
    RecordsModel(date: Date(timeIntervalSinceNow: -2.33), name: "Lancaster Smockhouse", amount: 20.00, catagory: "Food",type: "expense"),
    RecordsModel(date: now, name: "Innovation", amount: 5000.00, catagory: "Income",type: "income"),
]

struct Constants {
    // colors
    let greenColor = UIColor(red: 0.00, green: 0.45, blue: 0.39, alpha: 1.00)
    let redColor = UIColor.red
    
    let menuItems = ["Main currency settings","Passcode","Info","Feedback"]
    let catogeries = ["Food", "Grocery", "Gas","Medicines","Shopping"]

    
}
