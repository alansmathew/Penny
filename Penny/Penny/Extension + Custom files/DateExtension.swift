//
//  DateExtension.swift
//  Penny
//
//  Created by Alan S Mathew on 19/07/22.
//

import Foundation

extension Date{
    static func getDayOnly(date: Date) -> String?{
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

}
