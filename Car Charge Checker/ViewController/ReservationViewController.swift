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
    @IBOutlet weak var timeSelectionView: UIView!
    @IBOutlet weak var reserveButton: UIButton!
    
    var currentYear = -1
    var currentMonth = -1
    var currentDay = -1
    var currentDayOfWeek = -1
    var daysInMonth = -1
    var lastDayInMonthWeek = -1
    
    let monthDays: NSDictionary = [1: 31, 2: 28, 3: 31, 4: 30, 5: 31, 6: 30, 7: 31, 8: 31, 9: 30, 10: 31, 11: 30, 12: 31]
    let monthNames: NSDictionary = [1: "January", 2: "Febuary", 3: "March", 4: "April", 5: "May", 6: "June", 7: "July", 8: "August", 9: "September", 10: "October", 11: "November", 12: "December"]

    
    var firstDayOfWeek = -1
    
    var leapYear: Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calander.dataSource = self
        calander.delegate = self
        calander.allowsSelection = true
        calander.backgroundColor = notBlack
        
        reserveButton.layer.cornerRadius = 10
        
        //timeFeedbackView.isHidden = true
        //timeSelectionView.isHidden = true
        
        let date = Date()
        let cal = Calendar.current
        let components = cal.dateComponents([.year, .month, .day, .weekday], from: date)
        currentYear =  components.year!
        currentMonth = components.month!
        currentDay = components.day!
        currentDayOfWeek = components.weekday!
        leapYear = components.isLeapMonth!
        daysInMonth = monthDays[currentMonth] as! Int
        if leapYear && currentMonth == 2 {
            daysInMonth = 29
        }
        
        monthLabel.text = monthNames[currentMonth] as? String
        monthLabel.layer.cornerRadius = 10
        
        
        let date2 = Date(timeIntervalSinceNow: Double((-currentDay + 1) * 86400))
        let components2 = cal.dateComponents([.weekday, .month, .day], from: date2)
        firstDayOfWeek = components2.weekday!
        print(firstDayOfWeek)
        
        let date3 = Date(timeIntervalSinceNow: Double((daysInMonth - currentDay) * 86400))
        let components3 = cal.dateComponents([.weekOfMonth], from: date3)
        lastDayInMonthWeek = components3.weekOfMonth!
        print(lastDayInMonthWeek)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return lastDayInMonthWeek * 7
        return 42
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calander.dequeueReusableCell(withReuseIdentifier: "calanderCell", for: indexPath) as! CalendarCell
        cell.layer.cornerRadius = 28
        cell.backgroundColor = notBlack

        if (indexPath.row >= firstDayOfWeek - 1) && (indexPath.row - (firstDayOfWeek-2) <= daysInMonth) {
            cell.numberLabel.text = String(indexPath.row - (firstDayOfWeek-2))
            cell.isSelectable = true
            if indexPath.row - (firstDayOfWeek-2) == currentDay {
                cell.numberLabel.textColor = evqBlue
            } else {
                cell.numberLabel.textColor = .white
            }
        } else {
            cell.numberLabel.text = ""
        }
        return cell
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
