//
//  ReservationViewController.swift
//  Car Charge Checker
//
//  Created by Alush Benitez on 1/22/19.
//  Copyright © 2019 Michael Filippini. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn

class ReservationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var calander: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var nextMonthButton: UIButton!
    @IBOutlet weak var reserveButton: UIButton!
    
    var currentYear = -1
    var currentMonth = -1
    var currentDay = -1
    var currentDayOfWeek = -1
    var daysInMonth = -1
    var lastDayInMonthWeek = -1
    
    var firstSelectedTime = 8
    var firstTrueTime = 20
    var firstAM = false
    var secondSelectedTime = 8
    var secondTrueTime = 8
    var secondAM = true
    
    var selectedDate = 0
    var selectedMonth = 0
    
    var shownMonth = -1
    var shownDay = -1
    
    let monthDays: NSDictionary = [1: 31, 2: 28, 3: 31, 4: 30, 5: 31, 6: 30, 7: 31, 8: 31, 9: 30, 10: 31, 11: 30, 12: 31]
    let monthNames: NSDictionary = [1: "January", 2: "Febuary", 3: "March", 4: "April", 5: "May", 6: "June", 7: "July", 8: "August", 9: "September", 10: "October", 11: "November", 12: "December"]

    var firstDayOfWeek = -1
    var leapYear: Bool = false
    
    @IBOutlet weak var timeSelectionView: UIView!
    @IBOutlet weak var firstTimeLabel: UILabel!
    @IBOutlet weak var firstRightButton: UIButton!
    @IBOutlet weak var firstLeftButton: UIButton!
    @IBOutlet weak var firstPMButton: UIButton!
    @IBOutlet weak var firstAMButton: UIButton!
    
    @IBOutlet weak var timeSelectionViewTwo: UIView!
    @IBOutlet weak var secondTimeLabel: UILabel!
    @IBOutlet weak var secondLeftButton: UIButton!
    @IBOutlet weak var secondRightButton: UIButton!
    @IBOutlet weak var secondAMButton: UIButton!
    @IBOutlet weak var secondPMButton: UIButton!

    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewDidLoad() {
        //CALANDER STUFF
        super.viewDidLoad()
        uiSetup()
        
        calander.dataSource = self
        calander.delegate = self
        calander.allowsSelection = true
    
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
        
        let date2 = Date(timeIntervalSinceNow: Double((-currentDay + 1) * 86400))
        let components2 = cal.dateComponents([.weekday, .month, .day], from: date2)
        firstDayOfWeek = components2.weekday!
        
        firstTimeAMPress(0)
        secondTimePMPress(0)
    }
    
    fileprivate func uiSetup() {
        reserveButton.layer.cornerRadius = 10
        reserveButton.isEnabled = false
        reserveButton.layer.backgroundColor = toothpaste.cgColor
        timeSelectionView.layer.cornerRadius = 20
        timeSelectionViewTwo.layer.cornerRadius = 20
        calander.backgroundColor = notBlack
        monthLabel.layer.cornerRadius = 10
        nextMonthButton.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        firstRightButton.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        secondRightButton.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        updateTimes()
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
    
    public func dateSelected(date: Int){
        print(date)
        selectedDate = date
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
            self.calander.alpha = 1
            self.monthLabel.alpha = 1
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
    
    fileprivate func updateTimes() {
        firstTimeLabel.text = String(firstSelectedTime)
        secondTimeLabel.text = String(secondSelectedTime)
        updateReserveButton()
    }
    
    func updateReserveButton(){
        if(firstTrueTime<secondTrueTime/*and date is not before today*/){
            reserveButton.isEnabled = true
            reserveButton.alpha = 1
        }else{
            reserveButton.isEnabled = false
            reserveButton.alpha = 0.65
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func firstTimeDecrease(_ sender: Any) {
        if(firstSelectedTime>1){
            firstSelectedTime -= 1
            firstTrueTime -= 1
        }else{
            firstSelectedTime += 11
            firstTrueTime += 11
        }
        updateTimes()
    }
    
    @IBAction func firstTimeIncrease(_ sender: Any) {
        if(firstSelectedTime<12){
            firstSelectedTime += 1
            firstTrueTime += 1
        }else{
            firstSelectedTime -= 11
            firstTrueTime -= 11
        }
        updateTimes()
    }
    
    @IBAction func secondTimeDecrease(_ sender: Any) {
        if(secondSelectedTime>1){
            secondSelectedTime -= 1
            secondTrueTime -= 1
        }else{
            secondSelectedTime += 11
            secondTrueTime += 11
        }
        updateTimes()
    }
    
    @IBAction func secondTimeIncrease(_ sender: Any) {
        if(secondSelectedTime<12){
            secondSelectedTime += 1
            secondTrueTime += 1
        }else{
            secondSelectedTime -= 11
            secondTrueTime -= 11
        }
        updateTimes()
    }
    
    @IBAction func firstTimeAMPress(_ sender: Any) {
        if(!firstAM){
            firstAM = true
            buttonSelected(button: firstAMButton)
            buttonDeselected(button: firstPMButton)
            firstTrueTime -= 12
            updateReserveButton()
        }
    }
    
    @IBAction func firstTimePMPress(_ sender: Any) {
        if(firstAM){
            firstAM = false
            buttonSelected(button: firstPMButton)
            buttonDeselected(button: firstAMButton)
            firstTrueTime += 12
            updateReserveButton()
        }
    }
    
    @IBAction func secondTimeAMPress(_ sender: Any) {
        if(!secondAM){
            secondAM = true
            buttonSelected(button: secondAMButton)
            buttonDeselected(button: secondPMButton)
            secondTrueTime -= 12
            updateReserveButton()
        }
    }
    
    @IBAction func secondTimePMPress(_ sender: Any) {
        if(secondAM){
            secondAM = false
            buttonSelected(button: secondPMButton)
            buttonDeselected(button: secondAMButton)
            secondTrueTime += 12
            updateReserveButton()
        }
    }
    
    func buttonSelected(button:UIButton){
        button.layer.backgroundColor = notBlack.cgColor
        button.layer.cornerRadius = 4
        button.layer.borderColor = evqBlue.cgColor
        button.layer.borderWidth = 2
        button.tintColor = .white
    }
    
    func buttonDeselected(button:UIButton){
        button.layer.backgroundColor = notBlack.cgColor
        button.layer.cornerRadius = 4
        button.layer.borderColor = notBlack.cgColor
        button.layer.borderWidth = 2
        button.tintColor = .white
    }
    
    
    @IBAction func reservePressed(_ sender: Any) {
        
        // check if time is available
        
        //create reservation
        let profile = [ "date": "",
                        "startTime": String(firstTrueTime),
                        "endTime": String(secondTrueTime),
                        "person": userEmail ?? "error"]
        
        //add to
    }

    
}
