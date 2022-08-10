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
    
    //setting context to APPDATA of the app thus helps to fetch and save data from and to COREDATA
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var dateForMonth = Date()
    var segCase = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        segCase = 0     // forcing segnment to the fist index when this screed comes up
        daysSegnmentController.selectedSegmentIndex = 0
        filterRequest(requestDate: dateForMonth)
        cuttentMonthLabel.text = Date.getMonthYear(date: dateForMonth)
    }
    
    // when user press the left arrow to move dates to past
    @IBAction func leftMoveButton(_ sender: UIButton) {
        var dateComponent = DateComponents()
        
        // seg 0 is month
        if segCase == 0 {
            dateComponent.month = -1
            let pastDate = Calendar.current.date(byAdding: dateComponent, to: dateForMonth)
            if let past = pastDate{
                dateForMonth = past
                cuttentMonthLabel.text = Date.getMonthYear(date: dateForMonth)
                filterRequest(requestDate: dateForMonth, typeOfSetup: "daily")
            }
        }
        
        // seg 1 is year
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
    
    // when user press the left arrow to move dates to forward
    @IBAction func rightMoveMonth(_ sender: UIButton) {
        let currrentDate = Date()
        var dateComponent = DateComponents()
        
        // seg 0 is month
        if segCase == 0 {
            dateComponent.month = 1
        }
        // seg 1 is year
        else{
            dateComponent.year = 1
        }
    
        // here dates on current label will change according to month or year with SEG varable
        // use of tanery operator is to change displayDate with SEG condition
        // calls filterRequest to filture data with respect to dateForMonth vriable
        
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
            // happens is if user trys to access future dates
            else{
                showAlert(title: "Future Alert", message: "We are not that advanced to get into future yet. If we found out a way, we will definatly update app to incorporate future expenses")
            }
        }
 
    }
    
    // function accepts 2 parameters
    // requestDate - > for the date in with the data need to be organised
    // typeOfSetup -> to know the range if classification, and is default value is daily
    
    func filterRequest(requestDate : Date, typeOfSetup : String? = "daily"){
        var filterData : [Trans] = []
        if typeOfSetup == "daily"{
            if let data = databaseData{
                for x in data{
                    // getMonthOnly is a custom method the returns month from the given date
                    if Date.getMonthOnly(date: x.date!) == Date.getMonthOnly(date: requestDate) {
                        filterData.append(x)
                    }
                }
            }
        }
        else{
            if let data = databaseData{
                for x in data{
                    // getYear is a custom method the returns year from the given date
                    if Date.getYear(date: x.date!) == Date.getYear(date: requestDate) {
                        filterData.append(x)
                    }
                }
            }
        }
        // setting up barchart from the filtured data
        barchartSetup(barCartData: filterData,typeOfSetup: typeOfSetup)

    }
    
    // when ever value changed of segnmentController
    // date is been reseted, thus display date and Filture data request is been made to reset chart
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
    
    // this meathod gives user a pop about the title and string given as parameter
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
        
        // setting minimum and maximus thus map wont show unnessery blank spaces
        var minXvalue = 31.0
        var maxXValue = 0.0
        
        //X-Axis setup
        let xAxis = barChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = DayAxisValueFormatter(chart: barChart)

        // this arrays stores data of x and y that should be displaied in the screen
        //one is asset with green color and other is expense with red color
        var yValsAssets : [BarChartDataEntry] = []
        var yValsExpenses : [BarChartDataEntry] = []
        
        var totAssets = 0.0
        var totLibilities = 0.0
        
        assetsLabel.text = "⬆️ \(defaultCurrency)0.0"
        libeltyLabel.text = "⬇️ \(defaultCurrency)0.0"
        
        // filling up assets and libilities array based on daily basis
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
        // setting up array in months that is jan, feb, mar
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
        
        // setting up green for assets
        var set1: BarChartDataSet! = nil
        set1 = BarChartDataSet(entries: yValsAssets)
        set1.setColor(NSUIColor(cgColor: UIColor(red: 0.00, green: 0.81, blue: 0.62, alpha: 1.00).cgColor))
        
        // setting up red for expenses
        var set2: BarChartDataSet! = nil
        set2 = BarChartDataSet(entries: yValsExpenses)
        set2.setColor(NSUIColor(cgColor: UIColor(red: 0.86, green: 0.24, blue: 0.00, alpha: 1.00).cgColor))

        
        let data = BarChartData(dataSets: [set1,set2])
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
        data.barWidth = 0.9
        
        barChart.data = data
    }
}
