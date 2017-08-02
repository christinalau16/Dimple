//
//  CalendarViewController.swift
//  Tabbar App example
//
//  Created by Christina Lau on 7/18/17.
//  Copyright © 2017 Christina Lau. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    let formatter = DateFormatter()
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var savedDictionary : [String: [DatePage]] = [:]
    var currentPages = [DatePage]()
    var foundKey = false
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var noDataView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
        setNeedsStatusBarAppearanceUpdate()
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates([Date()])
        
        infoTableView.delegate = self
        infoTableView.dataSource = self
        
        let userDefaults = UserDefaults.standard
        savedDictionary = NSKeyedUnarchiver.unarchiveObject(with: userDefaults.object(forKey: "calendarData") as! Data) as! [String: [DatePage]]
        formatter.dateFormat = "yyyy MM dd"
        let userDate = formatter.string(from: Date())
        for key in savedDictionary.keys{
            if key == userDate
            {
                currentPages = savedDictionary[key]!
                foundKey = true
            }
        }
        self.infoTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates([Date()])
        setNeedsStatusBarAppearanceUpdate()
        let userDefaults = UserDefaults.standard
        savedDictionary = NSKeyedUnarchiver.unarchiveObject(with: userDefaults.object(forKey: "calendarData") as! Data) as! [String: [DatePage]]
        formatter.dateFormat = "yyyy MM dd"
        let userDate = formatter.string(from: Date())
        for key in savedDictionary.keys{
            if key == userDate
            {
                currentPages = savedDictionary[key]!
                foundKey = true
            }
        }
        self.infoTableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func setupCalendarView(){
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "yyyy"
        yearLabel.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date)
    }
    
    func handleCellBackground(view: JTAppleCell?, cellState: CellState, date: Date) {
        guard let validCell = view as? CustomCell else { return }
        formatter.dateFormat = "yyyy MM dd"
        let selectedDate = formatter.string(from: date)
        if let count = savedDictionary[selectedDate]?.count, cellState.dateBelongsTo == .thisMonth
        {
            let color : UIColor
            switch count {
            case 0:
                color = .clear
            case 1...5:
                color = UIColor(red: 177.0/255.0, green: 154.0/255.0, blue: 219.0/255.0, alpha: 1.0)
            case 6...10:
                color = UIColor(red: 126.0/255.0, green: 86.0/255.0, blue: 159.0/255.0, alpha: 1.0)
            default:
                color = UIColor(red: 77.0/255.0, green: 48.0/255.0, blue: 126.0/255.0, alpha: 1.0)
            }
            validCell.selectedView.backgroundColor = color
        } else {
            validCell.selectedView.backgroundColor = .clear
        }
        handleCellSelected(view: view, cellState: cellState)
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState)
    {
        guard let validCell = view as? CustomCell else { return }
        validCell.dateLabel.font = UIFont.systemFont(ofSize: 14)
        if validCell.selectedView.backgroundColor != .clear
        {
            validCell.dateLabel.textColor = UIColor.white
        } else
        {
            if cellState.dateBelongsTo == .thisMonth
            {
                validCell.dateLabel.textColor = UIColor(red: 102.0/255.0, green: 40.0/255.0, blue: 146.0/255.0, alpha: 1.0) 
            } else {
                validCell.dateLabel.textColor = UIColor.clear
            }
        }
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState)
    {
        guard let validCell = view as? CustomCell else { return }
        if cellState.isSelected && cellState.dateBelongsTo == .thisMonth{
            validCell.borderImageView.isHidden = false
        } else{
            validCell.borderImageView.isHidden = true
        }
    }
    
    @IBAction func previousMonthPressed(_ sender: UIButton) {
        calendarView.scrollToSegment(.previous)
    }
    
    @IBAction func nextMonthPressed(_ sender: UIButton) {
        calendarView.scrollToSegment(.next)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !foundKey || currentPages.count == 0{
            noDataView.isHidden = false
            return 0
        }
        noDataView.isHidden = true
        return currentPages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell") as! CalendarTableViewCell
        cell.pageNameLabel.text = currentPages[indexPath.row].pageName
        cell.starImage.isHidden = !currentPages[indexPath.row].starred!
        cell.setBackgroundView(index: indexPath.row, rowCount: currentPages.count)
        return cell
    }
}


extension CalendarViewController: JTAppleCalendarViewDataSource,JTAppleCalendarViewDelegate {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 01 01")
        let endDate = formatter.date(from: "2017 12 31")
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        handleCellBackground(view: cell, cellState: cellState, date: date)
        handleCellTextColor(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        foundKey = false
        formatter.dateFormat = "yyyy MM dd"
        let selectedDate = formatter.string(from: date)
        for key in savedDictionary.keys{
            if key == selectedDate && cellState.dateBelongsTo == .thisMonth
            {
                currentPages = savedDictionary[key]!
                foundKey = true
            }
        }
        self.infoTableView.reloadData()
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
 
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
 
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
}
