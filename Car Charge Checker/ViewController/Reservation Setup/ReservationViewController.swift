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

class ReservationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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
    
    var selectedMonth = 0
    
    var shownMonth = -1
    var shownDay = -1
    
    let monthDays: NSDictionary = [1: 31, 2: 28, 3: 31, 4: 30, 5: 31, 6: 30, 7: 31, 8: 31, 9: 30, 10: 31, 11: 30, 12: 31]
    let monthNames: NSDictionary = [1: "January", 2: "Febuary", 3: "March", 4: "April", 5: "May", 6: "June", 7: "July", 8: "August", 9: "September", 10: "October", 11: "November", 12: "December"]

    var firstDayOfWeek = -1
    var leapYear: Bool = false
    
    let user = Auth.auth().currentUser
    var ref: DatabaseReference!

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
    
    override func viewWillAppear(_ animated: Bool) {
        currentlySelectedDate = -1
        currentlySelectedYear = -1
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
        print("date\(components)")
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
        reserveButton.layer.backgroundColor = itsSpelledGrey.cgColor
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateReserveButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateReserveButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calander.dequeueReusableCell(withReuseIdentifier: "calanderCell", for: indexPath) as! CalendarCell
        cell.layer.cornerRadius = cell.bounds.width/2
        cell.backgroundColor = notBlack
        cell.isSelectable = false
        cell.numberLabel.textAlignment = .center
        cell.numberLabel.adjustsFontSizeToFitWidth = true
        
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
        if date != -1 {
            currentlySelectedDate = date
            
            let date = Date()
            let cal = Calendar.current
            let components = cal.dateComponents([.year], from: date)
            
            if shownMonth < currentMonth {
                currentlySelectedYear = components.year! + 1
            } else {
                currentlySelectedYear = components.year!
            }
            print("currentlySelectedYear: \(currentlySelectedYear)")
        } else {
            currentlySelectedDate = -1
            currentlySelectedYear = -1
        }
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
            currentlySelectedDate = -1
            currentlySelectedYear = -1
            updateReserveButton()
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
            currentlySelectedDate = -1
            currentlySelectedYear = -1
            updateReserveButton()
        }
    }
    
    fileprivate func updateTimes() {
        firstTimeLabel.text = String(firstSelectedTime)
        secondTimeLabel.text = String(secondSelectedTime)
        updateReserveButton()
    }
    
    func updateReserveButton(){
        if((firstTrueTime<secondTrueTime) && !(currentMonth == shownMonth && currentlySelectedDate < shownDay) && (currentlySelectedDate != -1) ){
            reserveButton.isEnabled = true
            reserveButton.layer.backgroundColor = toothpaste.cgColor
        }else{
            reserveButton.isEnabled = false
            reserveButton.layer.backgroundColor = itsSpelledGrey.cgColor
        }
        print("start:\(firstTrueTime) end:\(secondTrueTime)")
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func firstTimeDecrease(_ sender: Any) {
        if(firstSelectedTime>1){
            firstSelectedTime -= 1
        }else{
            firstSelectedTime += 11
        }
        
        if(firstAM){
            firstTrueTime = firstSelectedTime
        }else{
            firstTrueTime = firstSelectedTime + 12
        }
        
        if(firstTrueTime == 12){
            firstTrueTime = 0
        } else if(firstTrueTime == 24){
            firstTrueTime = 12
        }
        
        updateTimes()
    }
    
    @IBAction func firstTimeIncrease(_ sender: Any) {
        if(firstSelectedTime<12){
            firstSelectedTime += 1
        }else{
            firstSelectedTime -= 11
        }
        
        if(firstAM){
            firstTrueTime = firstSelectedTime
        }else{
            firstTrueTime = firstSelectedTime + 12
        }
        
        if(firstTrueTime == 12){
            firstTrueTime = 0
        } else if(firstTrueTime == 24){
            firstTrueTime = 12
        }
        
        updateTimes()
    }
    
    @IBAction func secondTimeDecrease(_ sender: Any) {
        if(secondSelectedTime>1){
            secondSelectedTime -= 1
        }else{
            secondSelectedTime += 11
        }
        
        if(secondAM){
            secondTrueTime = secondSelectedTime
        }else{
            secondTrueTime = secondSelectedTime + 12
        }
        
        if (secondTrueTime == 12){
            secondTrueTime = 24
        } else if (secondTrueTime == 24){
            secondTrueTime = 12
        }
        updateTimes()
    }
    
    @IBAction func secondTimeIncrease(_ sender: Any) {
        if(secondSelectedTime<12){
            secondSelectedTime += 1
        }else{
            secondSelectedTime -= 11
        }
        
        if(secondAM){
            secondTrueTime = secondSelectedTime
        }else{
            secondTrueTime = secondSelectedTime + 12
        }
        
        if(secondTrueTime == 24){
            secondTrueTime = 12
        } else if(secondTrueTime == 12){
            secondTrueTime = 24
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
            
            if(secondTrueTime == 0){
                secondTrueTime = 24
            }
            
            updateReserveButton()
        }
    }
    
    @IBAction func secondTimePMPress(_ sender: Any) {
        if(secondAM){
            secondAM = false
            buttonSelected(button: secondPMButton)
            buttonDeselected(button: secondAMButton)
            secondTrueTime += 12
            
            if(secondTrueTime == 36){
                secondTrueTime = 12
            }
            
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
        
        ref = Database.database().reference()
        // check if time is available
        print("date: \(currentlySelectedDate) month: \(shownMonth)")
        let currentDate = Calendar.current.dateComponents([.month, .day, .year], from: Date())
        let currentDateString = "\(currentDate.value(for: .month) ?? -1),\(currentDate.value(for: .day) ?? -1),\(currentDate.value(for: .year) ?? -1)"
        let newRes = [ "dayOfRes": "\(currentlySelectedDate)",
                        "monthOfRes": "\(shownMonth)",
                        "resMadeOn":  currentDateString,
                        "yearOfRes": "\(currentlySelectedYear)",
                        "startTime": String(firstTrueTime),
                        "endTime": String(secondTrueTime),
                        "person": firstName ?? "error",
                        "userID": user?.uid ?? "error"]
        print(newRes)
        print(currentGroup)
        
        let key = self.ref.child("groups").child(currentGroup ?? "error").child("reservations").childByAutoId().key!
        
        let childUpdates = ["/groups/\(currentGroup ?? "error")/reservations/\(key)": newRes,]
       // self.ref.updateChildValues(childUpdates)
        
        if let userID = Auth.auth().currentUser?.uid {
            ref.child("groups").child(currentGroup ?? "error").child("reservations").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let values = snapshot.value as? NSDictionary
                var maxChargerUsage = 0
                var chargerUseAtTime = 0
                
                for time in self.firstTrueTime...self.secondTrueTime{
                    for (resNum, reservation) in values ?? [:]{
                        let res = reservation as! [String:String]
                        let monthOfSetRes = Int(res["monthOfRes"] ?? "") ?? 0
                        let dayOfSetRes = Int(res["dayOfRes"] ?? "") ?? 0
                        if(monthOfSetRes == self.shownMonth && dayOfSetRes == currentlySelectedDate){
                            let startTime = Int(res["startTime"] ?? "25") ?? 25
                            let endTime = Int(res["endTime"] ?? "-1" ) ?? -1
                            
                            if(time >= startTime && time < endTime){
                                chargerUseAtTime += 1
                            }
                            
                            print("values: \(values) start: \(startTime) end: \(endTime)")
                        }
                    }
                    if(chargerUseAtTime > maxChargerUsage){
                        maxChargerUsage = chargerUseAtTime
                    }
                    chargerUseAtTime = 0
                }
                if(maxChargerUsage >= numberOfChargers ?? 0){
                    let alert = UIAlertController(title: "Invalid Time", message: "The chargers are full during this time.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    self.ref.updateChildValues(childUpdates)
                    self.dismiss(animated: true, completion: nil)
                }
                print("charger Use at time\(maxChargerUsage) chargers for group\(numberOfChargers ?? 90)")
            }) { (error) in
                print(error.localizedDescription)
            }
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = min(((collectionView.frame.width - 20 )/7.0), ((collectionView.frame.height) / 6.0))
        
        return CGSize(width: size, height: size)
        
    }
    
}
