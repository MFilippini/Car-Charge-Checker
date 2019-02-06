//
//  ReservationViewController.swift
//  Car Charge Checker
//
//  Created by Alush Benitez on 1/22/19.
//  Copyright © 2019 Michael Filippini. All rights reserved.
//

import UIKit

class ReservationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var calander: UICollectionView!
    @IBOutlet weak var rightMonthButton: UIButton!
    @IBOutlet weak var leftMonthButton: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var reserveButton: UIButton!
    
    var currentYear = -1
    var currentMonth = -1
    var currentDay = -1
    var currentDayOfWeek = -1
    var daysInMonth = -1
    var lastDayInMonthWeek = -1
    
    var shownMonth = -1
    var shownDay = -1
    
    let monthDays: NSDictionary = [1: 31, 2: 28, 3: 31, 4: 30, 5: 31, 6: 30, 7: 31, 8: 31, 9: 30, 10: 31, 11: 30, 12: 31]
    let monthNames: NSDictionary = [1: "January", 2: "Febuary", 3: "March", 4: "April", 5: "May", 6: "June", 7: "July", 8: "August", 9: "September", 10: "October", 11: "November", 12: "December"]

    
    var firstDayOfWeek = -1
    
    var leapYear: Bool = false
    
    @IBOutlet weak var timeSelectionView: UIView!
    @IBOutlet weak var firstTimeLabel: UILabel!
    @IBOutlet weak var firstLeftButton: UIButton!
    @IBOutlet weak var firstRightButton: UIButton!
    @IBOutlet weak var firstPMButton: UIButton!
    @IBOutlet weak var firstAMButton: UIButton!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        //CALANDER STUFF
        super.viewDidLoad()
        calander.dataSource = self
        calander.delegate = self
        calander.allowsSelection = true
        calander.backgroundColor = notBlack
        
        reserveButton.layer.cornerRadius = 10
        
        let date = Date()
        let cal = Calendar.current
        let components = cal.dateComponents([.year, .month, .day, .weekday], from: date)
        currentYear =  components.year!
        currentMonth = components.month!
        shownMonth = currentMonth
        currentDay = components.day!
        shownDay = currentDay
        currentDayOfWeek = components.weekday!
        leapYear = components.isLeapMonth!
        daysInMonth = monthDays[currentMonth] as! Int
        
        if leapYear && currentMonth == 2 {
            daysInMonth = 29
        }
        
        monthLabel.text = monthNames[shownMonth] as? String
        monthLabel.layer.cornerRadius = 10
        let date2 = Date(timeIntervalSinceNow: Double((-currentDay + 1) * 86400))
        let components2 = cal.dateComponents([.weekday, .month, .day], from: date2)
        firstDayOfWeek = components2.weekday!
    }
    
    
    
    
    //**************
    //CALENDAR STUFF
    //**************

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calander.dequeueReusableCell(withReuseIdentifier: "calanderCell", for: indexPath) as! CalendarCell
        cell.layer.cornerRadius = 28
        cell.backgroundColor = notBlack
        cell.isSelectable = false

        if (indexPath.row >= firstDayOfWeek - 1) && (indexPath.row - (firstDayOfWeek-2) <= daysInMonth) {
            cell.numberLabel.text = String(indexPath.row - (firstDayOfWeek-2))
            cell.isSelectable = true
            if indexPath.row - (firstDayOfWeek-2) == shownDay {
                cell.numberLabel.textColor = evqBlue
            } else {
                cell.numberLabel.textColor = .white
            }
        } else {
            cell.numberLabel.text = ""
        }
        return cell
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        if shownMonth == currentMonth {
            if currentMonth == 12 {
                shownMonth = 1
            } else {
                shownMonth += 1
            }
            UIView.animate(withDuration: 1) {
                self.calander.alpha = 0
                self.monthLabel.alpha = 0
            }
            self.monthLabel.text = monthNames[shownMonth] as? String
            let cal = Calendar.current
            let firstDayOfNextMonth = Date(timeIntervalSinceNow: Double((daysInMonth - currentDay) * 86400) + 86400)
            let components2 = cal.dateComponents([.weekday, .month, .day], from: firstDayOfNextMonth)
            firstDayOfWeek = components2.weekday!
            daysInMonth = monthDays[shownMonth] as! Int
            shownDay = -1
            calander.reloadData()
            UIView.animate(withDuration: 1) {
                self.calander.alpha = 1
                self.monthLabel.alpha = 1
            }
        }
    }
    
    
    @IBAction func previousMonth(_ sender: Any) {
        if shownMonth == currentMonth + 1 {
            shownMonth -= 1
            UIView.animate(withDuration: 1) {
                self.calander.alpha = 0
                self.monthLabel.alpha = 0
            }
            self.monthLabel.text = monthNames[shownMonth] as? String
            
            let cal = Calendar.current
            let firstDayOfNextMonth = Date(timeIntervalSinceNow: Double((-currentDay + 1) * 86400))
            let components2 = cal.dateComponents([.weekday, .month, .day], from: firstDayOfNextMonth)
            firstDayOfWeek = components2.weekday!
            daysInMonth = monthDays[shownMonth] as! Int
            shownDay = currentDay
            calander.reloadData()
            UIView.animate(withDuration: 1) {
                self.calander.alpha = 1
                self.monthLabel.alpha = 1
            }
        }
    }
}
