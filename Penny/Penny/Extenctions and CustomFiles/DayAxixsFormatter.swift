//
//  DayAxixsFormatter.swift
//  Penny
//
//  Created by user207260 on 03/08/22.
//

import Foundation
import Charts

// this bartype determins witch type of xaxics parcing is needed
var bartype = 0

// this formattor is a custom file to handle x axis in the chart view
// this parses the data in the x axixs and returs the curresponding string that is necessory
public class DayAxisValueFormatter: NSObject, IAxisValueFormatter {
    weak var chart: BarLineChartViewBase?
    
    let months = ["Jan", "Feb", "Mar",
                  "Apr", "May", "Jun",
                  "Jul", "Aug", "Sep",
                  "Oct", "Nov", "Dec"]
    
    init(chart: BarLineChartViewBase) {
        self.chart = chart
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        switch bartype {
        case 0:
            let days = Int(value)
            var appendix: String
            switch days {
            case 1, 21, 31: appendix = "st"
            case 2, 22: appendix = "nd"
            case 3, 23: appendix = "rd"
            default: appendix = "th"
            }
            return days == 0 ? "" : String(format: "%d\(appendix)", days)
            
        case 1:
            let hr = Int(value)
            return String(format: "%d", hr)
        case 2:
            let month = Int(value)
            return month == 0 ? "" : months[month-1]
        case 3:
            let year = Int(value)
            return year == 0 ? "" : "\(year)"
        default:
            print("unknown")
            return "nil"
        }
    }
}
