//
//  ViewController.swift
//  Car Charge Checker
//
//  Created by Michael Filippini on 10/22/18.
//  Copyright © 2018 Michael Filippini. All rights reserved.
//

import UIKit
import Foundation
import FirebaseAuth
import Firebase

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var hamburgerButton: UIButton!
    @IBOutlet weak var selectedGroupLabel: UILabel!
    @IBOutlet weak var usersReservationsCollectionView: UICollectionView!
    @IBOutlet weak var todaysReservationsCollectionView: UICollectionView!
    @IBOutlet weak var reserveButton: UIButton!
    
    var groupsInArray: [String] = []
    var groupInNamesArray: [String] = []
    var groupInNamesArrayTemp: [String] = []
    
    var myReservations: [[String:String]] = []
    var groupReservations: [[String:String]] = []
    
    var currentMonth = 0
    var currentDate = 0
    var currentYear = 0
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        ref = Database.database().reference()
        usersReservationsCollectionView.delegate = self
        usersReservationsCollectionView.dataSource = self
        todaysReservationsCollectionView.delegate = self
        todaysReservationsCollectionView.dataSource = self
        
        setupUI()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        slideMenuController()?.addLeftGestures()
        let cal = Calendar.current.dateComponents([.year, .month, .day, .weekday], from: Date())
        currentDate = cal.day ?? 0
        currentMonth = cal.month ?? 0
        currentYear = cal.year ?? 0
        setupUI()
    }
    
    public func setupUI(){
        reserveButton.layer.cornerRadius = 15
        if let userID = Auth.auth().currentUser?.uid {

            ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                self.groupsInArray = []
                let value = snapshot.value as? NSDictionary
                let groups = value?["groupsIn"] as? NSDictionary
                if(groups != nil){
                    for (_, group) in groups!{
                        if (group as? String) == currentGroup {
                            self.ref.child("groups").child(group as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                                let value = snapshot.value as? NSDictionary
                                let name = value?["groupName"] as? String
                                var allReservations = value?["reservations"] as? NSDictionary as? [String:[String:String]]
                                print(allReservations)
                                self.selectedGroupLabel.text = name
                                self.selectedGroupLabel.alpha = 0
                                UIView.animate(withDuration: 0.5) {
                                    self.selectedGroupLabel.alpha = 1
                                }
                                for (key,reservation) in allReservations ?? ["":["":""]] {
                                    if(Int(reservation["yearOfRes"] ?? "") ?? 0 < self.currentYear){
                                        print(Int(reservation["yearOfRes"] ?? "") ?? 0 )
                                        allReservations?[key] = nil
                                    }else if(Int(reservation["yearOfRes"] ?? "") ?? 0 == self.currentYear){
                                        if(Int(reservation["monthOfRes"] ?? "") ?? 0 < self.currentMonth){
                                            allReservations?[key] = nil
                                        }else if(Int(reservation["monthOfRes"] ?? "") ?? 0 == self.currentMonth){
                                            if(Int(reservation["dayOfRes"] ?? "") ?? 0 < self.currentDate){
                                                allReservations?[key] = nil
                                            }
                                        }
                                    }
                                }
                                
                                let childUpdates = ["/groups/\(currentGroup ?? "error")/reservations/": allReservations,]
                                self.ref.updateChildValues(childUpdates)
                                self.myReservations = []
                                self.groupReservations = []
                                for (_,reservation) in allReservations ?? ["":["":""]] {
                                    print(reservation["userID"])
                                    if(reservation["userID"] == userID){
                                        let resDateString = "\(reservation["monthOfRes"] ?? "-1")/\(reservation["dayOfRes"] ?? "-1")"
                                        var startTimeStr = ""
                                        var endTimeStr = ""
                                        var startAmPm = ""
                                        var endAmPm = ""
                                        let startTime = Int(reservation["startTime"] ?? "-1") ?? 0
                                        let endTime = Int(reservation["endTime"] ?? "-1") ?? 0
                                        
                                        if(startTime == 0){
                                            startTimeStr += "12"
                                            startAmPm = "AM"
                                        }else if(startTime == 12){
                                            startTimeStr += "\(startTime)"
                                            startAmPm = "PM"
                                        }else if(startTime < 12){
                                            startTimeStr += "\(startTime)"
                                            startAmPm = "AM"
                                        }else{
                                            startTimeStr += "\(startTime - 12)PM"
                                            startAmPm = "PM"
                                        }
                                        
                                        if(endTime == 24){
                                            endTimeStr += "12AM"
                                            endAmPm = "AM"
                                        }else if(endTime == 12){
                                            endTimeStr += "\(endTime)PM"
                                            endAmPm = "PM"
                                        }else if(endTime < 12){
                                            endTimeStr += "\(endTime)"
                                            endAmPm = "AM"
                                        }else{
                                            endTimeStr += "\(endTime - 12)"
                                            endAmPm = "PM"
                                        }
                                        
                                        self.myReservations.append(["date":resDateString,"shownStartTime":startTimeStr,"startAmPm":startAmPm,"shownEndTime":endTimeStr,"endAmPm":endAmPm, "realStartTime":"\(startTime)","startTime":reservation["startTime"] ?? "-1","monthOfRes":reservation["monthOfRes"] ?? "-1","dayOfRes":reservation["dayOfRes"] ?? "-1","yearOfRes":reservation["yearOfRes"] ?? "-1"])
                                        
                                    }else if(reservation["userID"] != nil){
                                        if(Int(reservation["monthOfRes"] ?? "0") == self.currentMonth && Int(reservation["dayOfRes"] ?? "0") == self.currentDate){
                                            
                                            let resCreatorName = reservation["person"] ?? "error"
                                            
                                            var startTimeStr = ""
                                            var endTimeStr = ""
                                            var startAmPm = ""
                                            var endAmPm = ""
                                            let startTime = Int(reservation["startTime"] ?? "-1") ?? 0
                                            let endTime = Int(reservation["endTime"] ?? "-1") ?? 0
                                            
                                            if(startTime == 0){
                                                startTimeStr += "12"
                                                startAmPm = "AM"
                                            }else if(startTime == 12){
                                                startTimeStr += "\(startTime)"
                                                startAmPm = "PM"
                                            }else if(startTime < 12){
                                                startTimeStr += "\(startTime)"
                                                startAmPm = "AM"
                                            }else{
                                                startTimeStr += "\(startTime - 12)PM"
                                                startAmPm = "PM"
                                            }
                                            
                                            if(endTime == 24){
                                                endTimeStr += "12AM"
                                                endAmPm = "AM"
                                            }else if(endTime == 12){
                                                endTimeStr += "\(endTime)PM"
                                                endAmPm = "PM"
                                            }else if(endTime < 12){
                                                endTimeStr += "\(endTime)"
                                                endAmPm = "AM"
                                            }else{
                                                endTimeStr += "\(endTime - 12)"
                                                endAmPm = "PM"
                                            }
                                            
                                            
                                            self.groupReservations.append(["personName":resCreatorName,"shownStartTime":startTimeStr,"startAmPm":startAmPm,"shownEndTime":endTimeStr,"endAmPm":endAmPm, "realStartTime":"\(startTime)","startTime":reservation["startTime"] ?? "-1","monthOfRes":reservation["monthOfRes"] ?? "-1","dayOfRes":reservation["dayOfRes"] ?? "-1","yearOfRes":reservation["yearOfRes"] ?? "-1"])
                                        }
                                    }
                                }
                                self.groupReservations = self.sortRes(resList: self.groupReservations)
                                self.myReservations = self.sortRes(resList: self.myReservations)
                                print("myRes: \(self.myReservations)")
                                print("groupRes: \(self.groupReservations)")
                                self.todaysReservationsCollectionView.reloadData()
                                self.usersReservationsCollectionView.reloadData()
                            }) { (error) in
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func sortRes(resList:[[String:String]]) -> [[String:String]]{
        var sortedRes: [[String:String]] = resList
        for i in 0..<sortedRes.count {
            var reservation = sortedRes[i]
            let month = Int(reservation["monthOfRes"] ?? "0") ?? 0
            let day = Int(reservation["dayOfRes"] ?? "0") ?? 0
            let year = Int(reservation["yearOfRes"] ?? "0") ?? 0
            let startTime = Int(reservation["startTime"] ?? "0") ?? 0
            
            let ultTime = (startTime) + (day * 100) + (month * 10000)  + (year * 1000000)
            
            print("year: \(reservation["yearOfRes"])")
            
            reservation.updateValue("\(ultTime)", forKey: "ultTime")
            sortedRes[i] = reservation
        }
        
        return sortedRes.sorted{Int($0["ultTime"] ?? "") ?? 0 < Int($1["ultTime"] ?? "") ?? 0}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.usersReservationsCollectionView {
            let userResCell = collectionView.dequeueReusableCell(withReuseIdentifier: "usersCell", for: indexPath as IndexPath) as! UserReservationCell
            userResCell.layer.cornerRadius = 15
            userResCell.backgroundColor = itsSpelledGrey
            //userResCell.timePeriodLabel.adjustsFontSizeToFitWidth = true
            userResCell.dateLabel.text = myReservations[indexPath.row]["date"]
            //userResCell.timePeriodLabel.text = myReservations[indexPath.row]["time"]
            userResCell.startTimeLabel.text = myReservations[indexPath.row]["shownStartTime"]
            userResCell.endTimeLabel.text = myReservations[indexPath.row]["shownEndTime"]
            userResCell.startAmPm.text = myReservations[indexPath.row]["startAmPm"]
            userResCell.endAmPm.text = myReservations[indexPath.row]["endAmPm"]
            return userResCell
        } else {
            let todayResCell = collectionView.dequeueReusableCell(withReuseIdentifier: "todayCell", for: indexPath as IndexPath) as! TodayReservationCell
            todayResCell.layer.cornerRadius = 15
            todayResCell.backgroundColor = itsSpelledGrey
//            todayResCell.timePeriodLabel.adjustsFontSizeToFitWidth = true
//            todayResCell.timePeriodLabel.text = groupReservations[indexPath.row]["time"]
            todayResCell.nameLabel.text = groupReservations[indexPath.row]["personName"]
            todayResCell.startTimeLabel.text = groupReservations[indexPath.row]["shownStartTime"]
            todayResCell.endTimeLabel.text = groupReservations[indexPath.row]["shownEndTime"]
            todayResCell.startAmPmLabel.text = groupReservations[indexPath.row]["startAmPm"]
            todayResCell.endAmPmLabel.text = groupReservations[indexPath.row]["endAmPm"]

            return todayResCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.usersReservationsCollectionView {
            return myReservations.count
        }
            
        else {
            return groupReservations.count
        }
    }

    
    @IBAction func hamburgerPressed(_ sender: Any) {
        slideMenuController()?.openLeft()
    }
    
    @IBAction func reserveButtonPressed(_ sender: Any) {
        
    }
    
}

