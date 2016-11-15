//
//  ViewController.swift
//  Calendar
//
//  Created by TIMMARAJU SAI V on 10/30/16.
//  Copyright © 2016 TIMMARAJU SAI V. All rights reserved.
//

import UIKit
import JTAppleCalendar
import EVContactsPicker
extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
}
extension ScheduleViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
       
        let startDate = formatter.date(from:  SprialViewController.event?["startDate"] as! String)!// You can also use dates created from this function
        let endDate =   formatter.date(from:  SprialViewController.event?["date"] as! String)! // You can use date generated from a formatter
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6,
                                                 calendar: Calendar.current,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfGrid,
            firstDayOfWeek: .sunday)
        return parameters
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        let myCustomCell = cell as! CellView
        
        // Setup Cell text
        myCustomCell.dayLabel.text = cellState.text
        // Setup text color
        if cellState.dateBelongsTo == .thisMonth {
           
            myCustomCell.dayLabel.textColor =  UIColor(colorWithHexValue: 0x574865)
            myCustomCell.isUserInteractionEnabled = true
        } else {
            myCustomCell.dayLabel.textColor = UIColor(colorWithHexValue: 0xECEAED)
            myCustomCell.isUserInteractionEnabled = false
        }
       
        handleCellSelection(view: cell, cellState: cellState,date:date)

    }
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupViewsOfCalendar(from: visibleDates)
       
    }
    func dateFormat(datePicker:Date)->String
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: datePicker)
        return formattedDate
    }
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        //handleCellSelection(view: cell, cellState: cellState)
      
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        //handleCellSelection(view: cell, cellState: cellState)
        
    }
    
    func handleCellSelection(view: JTAppleDayCellView?, cellState: CellState,date:Date) {
        guard let myCustomCell = view as? CellView  else {
            return
        }
    
        if cellState.isSelected && dates.contains(date){
        
            myCustomCell.selectedView.layer.cornerRadius =  14
            myCustomCell.selectedView.isHidden = false
        } else {
            myCustomCell.selectedView.isHidden = true
        }
    }
}


class ScheduleViewController: UIViewController {

  
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
     var testCalendar = Calendar.current
    
    var tableViewData:NSMutableArray? = []
    var dates = [Date]()
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first else {
            return
        }
        let month = testCalendar.dateComponents([.month], from: startDate).month!
        let monthName = DateFormatter().monthSymbols[(month-1) % 12]
        // 0 indexed array
        let year = testCalendar.component(.year, from: startDate)
        monthLabel.text = monthName+" "+String(year)
        
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        //Retrive dates
        tableViewData = LoginViewController.dbOjbect.triggerDatabase(method: "getCalendarTasks/\(SprialViewController.eventId!)")
        print(tableViewData?.count)
        
        if tableViewData?.count != 0 {
        
            for x  in tableViewData! {
            let y = x as! NSDictionary
            let date = stngToDate(dateStr: (y["date"] as! String))
            dates.insert(date, at: dates.count)
            }
            
        }
    
        // Do any additional setup after loading the view, typically from a nib.
        calendarView.animationsEnabled = true
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.allowsMultipleSelection = true
        calendarView.registerCellViewXib(file: "CellView") // Registering your cell is manditory
        calendarView.cellInset = CGPoint(x:0, y:0)
        calendarView.visibleDates { (visibleDates: DateSegmentInfo) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        self.calendarView.selectDates(dates, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
        
    }
    func stngToDate(dateStr:String)->Date
    {
        // Set date format
        var dateFmt = DateFormatter()
        dateFmt.timeZone = NSTimeZone.default
        dateFmt.dateFormat =  "yyyy-MM-dd"
        // Get NSDate for the given string
        return dateFmt.date(from: dateStr)!
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

