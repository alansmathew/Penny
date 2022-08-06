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

    @IBOutlet weak var monthStack: UIStackView!
    @IBOutlet weak var cuttentMonthLabel: UILabel!
    @IBOutlet weak var dateAndTimePicker: UIDatePicker!
    @IBOutlet weak var daysSegnmentController: UISegmentedControl!
    @IBOutlet weak var barChart: BarChartView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var dateForMonth = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monthStack.isHidden = true
        dateAndTimePicker.maximumDate = Date()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dateAndTimePicker.date = Date()
        daysSegnmentController.selectedSegmentIndex = 0
        filterRequest(requestDate: Date())
        cuttentMonthLabel.text = Date.getMonthYear(date: dateForMonth)
    }
    
    @IBAction func leftMoveButton(_ sender: UIButton) {
        var dateComponent = DateComponents()
        dateComponent.month = -1
        let pastDate = Calendar.current.date(byAdding: dateComponent, to: dateForMonth)
        if let past = pastDate{
            dateForMonth = past
            cuttentMonthLabel.text = Date.getMonthYear(date: dateForMonth)
        }
    }
    
    @IBAction func rightMoveMonth(_ sender: UIButton) {
        let currrentDate = Date()
        
        var dateComponent = DateComponents()
        dateComponent.month = 1
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: dateForMonth)
        if let future = futureDate{
            if future < currrentDate {
                dateForMonth = future
                cuttentMonthLabel.text = Date.getMonthYear(date: dateForMonth)
            }
            else{
                showAlert(title: "Future Alert", message: "We are not that advanced to get into future yet. If we found out a way, we will definatly update app to incorporate future expenses")
            }
        }
    }
    
    func filterRequest(requestDate : Date, typeOfSetup : String? = "day"){
        var filterData : [Trans] = []
        if typeOfSetup == "day"{
            if let data = databaseData{
                for x in data{
                    if Date.getDayOnly(date: x.date!) == Date.getDayOnly(date: requestDate) {
                        filterData.append(x)
                    }
                }
            }
            barchartSetup(barCartData: filterData)
        }
        else{
            if let data = databaseData{
                for x in data{
                    if Date.getDayOnly(date: x.date!) == Date.getDayOnly(date: requestDate) {
                        filterData.append(x)
                    }
                }
            }
            barchartSetup(barCartData: filterData)
        }

        
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        filterRequest(requestDate: sender.date)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segnmentValueChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                monthStack.isHidden = true
                dateAndTimePicker.isHidden = false
                dateAndTimePicker.date = Date()
                filterRequest(requestDate: Date())
                return
            case 1 :
                monthStack.isHidden = false
                dateAndTimePicker.isHidden = true
                cuttentMonthLabel.text = Date.getMonthYear(date: dateForMonth)
                filterRequest(requestDate: Date())
                return
            default :
                monthStack.isHidden = true
                dateAndTimePicker.isHidden = false
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
    
    func barchartSetup(barCartData : [Trans], typeOfSetup : String? = "day"){
        
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
        
        if typeOfSetup == "day"{
            bartype = 1
            minXvalue = 24.59
            for x in barCartData {
                let currentvalue = Double(Date.get24hrforChart(date: x.date!))!
                minXvalue = currentvalue < minXvalue ? currentvalue : minXvalue
                maxXValue = currentvalue > maxXValue ? currentvalue : maxXValue

                if(x.type == "income"){
                    yValsAssets.append(BarChartDataEntry(x: Double(Date.get24hrforChart(date: x.date!))! , y: x.amount))
                }
                else{
                    yValsExpenses.append(BarChartDataEntry(x: Double(Date.get24hrforChart(date: x.date!))! , y: x.amount))
                }
            }
            print(minXvalue,maxXValue)
            xAxis.axisMinimum = minXvalue == 0.0 ? minXvalue : minXvalue - 1
            xAxis.axisMaximum = maxXValue >= 24.0 ? maxXValue : maxXValue + 1
            print(minXvalue,maxXValue)
        }
        else{
            
        }
       
        
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
