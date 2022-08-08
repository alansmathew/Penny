//
//  StaticsViewController.swift
//  Penny
//
//  Created by user207260 on 03/08/22.
//

import UIKit
import Charts
import CoreData

class StatictsViewController: UIViewController {

    @IBOutlet weak var cuttentMonthLabel: UILabel!
    @IBOutlet weak var daysSegnmentController: UISegmentedControl!
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var assetsLabel: UILabel!
    @IBOutlet weak var libeltyLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var dateForMonth = Date()
    var segCase = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        segCase = 0
        daysSegnmentController.selectedSegmentIndex = 0
        filterRequest(requestDate: dateForMonth)
        cuttentMonthLabel.text = Date.getMonthYear(date: dateForMonth)
    }
    
    @IBAction func leftMoveButton(_ sender: UIButton) {
        var dateComponent = DateComponents()
        
        if segCase == 0 {
            dateComponent.month = -1
            let pastDate = Calendar.current.date(byAdding: dateComponent, to: dateForMonth)
            if let past = pastDate{
                dateForMonth = past
                cuttentMonthLabel.text = Date.getMonthYear(date: dateForMonth)
                filterRequest(requestDate: dateForMonth, typeOfSetup: "daily")
            }
        }
        else{
            dateComponent.year = -1
            let pastDate = Calendar.current.date(byAdding: dateComponent, to: dateForMonth)
            if let past = pastDate{
                dateForMonth = past
                cuttentMonthLabel.text = Date.getYear(date: dateForMonth)
                filterRequest(requestDate: dateForMonth, typeOfSetup: "Monthly")
            }
        }
  
    }
    
    @IBAction func rightMoveMonth(_ sender: UIButton) {
        let currrentDate = Date()
        var dateComponent = DateComponents()
        
        if segCase == 0 {
            dateComponent.month = 1
        }
        else{
            dateComponent.year = 1
        }
    
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: dateForMonth)
        if let future = futureDate{
            if future < currrentDate {
                dateForMonth = future
                cuttentMonthLabel.text = segCase == 0 ? Date.getMonthYear(date: dateForMonth) : Date.getYear(date: dateForMonth)
                if segCase == 0{
                    filterRequest(requestDate: dateForMonth, typeOfSetup: "daily")
                }
                else{
                    filterRequest(requestDate: dateForMonth, typeOfSetup: "Monthly")
                }
            }
            else{
                showAlert(title: "Future Alert", message: "We are not that advanced to get into future yet. If we found out a way, we will definatly update app to incorporate future expenses")
            }
        }
 
    }
    
    func filterRequest(requestDate : Date, typeOfSetup : String? = "daily"){
        var filterData : [Trans] = []
        if typeOfSetup == "daily"{
            if let data = databaseData{
                for x in data{
                    if Date.getMonthOnly(date: x.date!) == Date.getMonthOnly(date: requestDate) {
                        filterData.append(x)
                    }
                }
            }
        }
        else{
            if let data = databaseData{
                for x in data{
                    if Date.getYear(date: x.date!) == Date.getYear(date: requestDate) {
                        filterData.append(x)
                    }
                }
            }
        }
        barchartSetup(barCartData: filterData,typeOfSetup: typeOfSetup)

        
    }
    
    @IBAction func segnmentValueChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                segCase = 0
                dateForMonth = Date()
                cuttentMonthLabel.text = Date.getMonthYear(date: dateForMonth)
                filterRequest(requestDate: Date())
                return
            case 1 :
                segCase = 1
                dateForMonth = Date()
                cuttentMonthLabel.text = Date.getYear(date: dateForMonth)
                filterRequest(requestDate: dateForMonth, typeOfSetup: "Monthly")
                return
            default :
                segCase = 0
                dateForMonth = Date()
                cuttentMonthLabel.text = Date.getMonthYear(date: dateForMonth)
                filterRequest(requestDate: dateForMonth, typeOfSetup: "Daily")
                return
        }
    }
    
    func showAlert(title : String, message : String){
        let alertmessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertmessage.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alertmessage ,animated: true, completion: nil)
    }

}

//MARK: - chart view delegate
extension StatictsViewController : ChartViewDelegate{
    
    func barchartSetup(barCartData : [Trans], typeOfSetup : String? = "daily"){
        
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
        
        var totAssets = 0.0
        var totLibilities = 0.0
        
        assetsLabel.text = "⬆️ \(defaultCurrency)0.0"
        libeltyLabel.text = "⬇️ \(defaultCurrency)0.0"
        
        if typeOfSetup == "daily"{
            bartype = 0
            minXvalue = 31
            for x in barCartData {
                let currentvalue = Double(Date.getDayOnly(date: x.date!))!
                minXvalue = currentvalue < minXvalue ? currentvalue : minXvalue
                maxXValue = currentvalue > maxXValue ? currentvalue : maxXValue

                if(x.type == "income"){
                    totAssets += x.amount
                    yValsAssets.append(BarChartDataEntry(x: Double(Date.getDayOnly(date: x.date!))! , y: x.amount))
                }
                else{
                    totLibilities += x.amount
                    yValsExpenses.append(BarChartDataEntry(x: Double(Date.getDayOnly(date: x.date!))! , y: x.amount))
                }
            }
            
            assetsLabel.text = "⬆️ \(defaultCurrency)\(totAssets)"
            libeltyLabel.text = "⬇️ \(defaultCurrency)\(totLibilities)"
            
            xAxis.axisMinimum = minXvalue == 0.0 ? minXvalue : minXvalue - 1
            xAxis.axisMaximum = maxXValue >= 31 ? maxXValue : maxXValue + 1

        }
        else{
            bartype = 2
            minXvalue = 12
            yValsAssets = []
            yValsExpenses = []
            
            for counterX in 1...12{
                var asset = 0.0
                var libelity = 0.0
                for data in barCartData {
                    
                    if Int(Date.getMonthOnly(date: data.date!)) == counterX{
                        if data.type == "income" {
                            asset += data.amount
                            totAssets += data.amount
                        }
                        else{
                            libelity += data.amount
                            totLibilities += data.amount
                        }
                    }
                }
            
                yValsAssets.append(BarChartDataEntry(x: Double(counterX), y: asset))
                yValsExpenses.append(BarChartDataEntry(x: Double(counterX), y: libelity ))
               
            }
            assetsLabel.text = "⬆️ \(defaultCurrency)\(totAssets)"
            libeltyLabel.text = "⬇️ \(defaultCurrency)\(totLibilities)"
            xAxis.axisMinimum = 0.0
            xAxis.axisMaximum = 12.0
        }
       
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.positivePrefix = "\(defaultCurrency) "
        
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
