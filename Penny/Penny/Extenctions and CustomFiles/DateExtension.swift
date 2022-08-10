//
//  DateExtension.swift
//  Penny
//
//  Created by Alan S Mathew on 19/07/22.
//

import Foundation

// these exenctions are userd to take dates in different formats
extension Date{
    static func getDayOnly(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let day = dateFormatter.string(from: date)
        return day
    }
    
    static func getTime(date : Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let time = dateFormatter.string(from: date)
        return time;
    }
    
    static func get24hrforChart(date : Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH.mm"
        let time = dateFormatter.string(from: date)
        return time;
    }
    
    static func getMonthYear(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM , yyyy"
        let monthYear = dateFormatter.string(from: date)
        return monthYear;
    }
    static func getMonthOnly(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let month = dateFormatter.string(from: date)
        return month;
    }
    static func getYear(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: date)
        return year;
    }
}
