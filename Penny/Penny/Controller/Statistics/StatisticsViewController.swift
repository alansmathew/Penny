//
//  StatisticsViewController.swift
//  Penny
//
//  Created by user207260 on 7/23/22.
//

import UIKit
import Charts

class StatictsViewController: UIViewController {

    @IBOutlet weak var barChart: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        barchartSetup()
    }
    
}

//MARK: - chart view delegate
extension StatictsViewController : ChartViewDelegate{

    
    func barchartSetup(){
        
        barChart.rightAxis.enabled = false
        barChart.legend.enabled = false
        
        var minXvalue = 31.0
        var maxXValue = 0.0
        
        let xAxis = barChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = DayAxisValueFormatter(chart: barChart)

        var yValsAssets : [BarChartDataEntry] = []
        var yValsExpenses : [BarChartDataEntry] = []
        
        if let data = databaseData{
            for x in data {
                
                minXvalue = minXvalue < Double(Date.getDayOnly(date: x.date!)!)! ? minXvalue : Double(Date.getDayOnly(date: x.date!)!)!
                maxXValue = maxXValue > Double(Date.getDayOnly(date: x.date!)!)! ? maxXValue : Double(Date.getDayOnly(date: x.date!)!)!
                
                if(x.type == "income"){
                    yValsAssets.append(BarChartDataEntry(x: Double(Date.getDayOnly(date: x.date!)!)! , y: x.amount))
                }
                else{
                    yValsExpenses.append(BarChartDataEntry(x: Double(Date.getDayOnly(date: x.date!)!)! , y: x.amount))
                }
            }
        }
       
        xAxis.axisMinimum = minXvalue == 1.0 ? minXvalue : minXvalue - 1
        xAxis.axisMaximum = maxXValue == 31.0 ? maxXValue : maxXValue + 1
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.positivePrefix = "$ "
        
        let leftAxis = barChart.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.axisMinimum = 0
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.3
        
        var set1: BarChartDataSet! = nil
        set1 = BarChartDataSet(entries: yValsAssets)
        set1.setColor(NSUIColor(cgColor: UIColor(red: 0.00, green: 0.81, blue: 0.62, alpha: 1.00).cgColor))
        
        var set2: BarChartDataSet! = nil
        set2 = BarChartDataSet(entries: yValsExpenses)
        set2.setColor(NSUIColor(cgColor: UIColor(red: 0.86, green: 0.24, blue: 0.00, alpha: 1.00).cgColor))

        
        let data = BarChartData(dataSets: [set1,set2])
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
        data.barWidth = 0.9
        
        barChart.data = data
    }
}


