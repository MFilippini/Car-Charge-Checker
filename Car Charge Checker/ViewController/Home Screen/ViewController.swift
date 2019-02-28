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
                                self.myReservations = []
                                self.groupReservations = []
                                for (_,reservation) in allReservations ?? ["":["":""]] {
                                    print(reservation["userID"])
                                    if(reservation["userID"] == userID){
                                        let resDateString = "\(reservation["monthOfRes"] ?? "-1")/\(reservation["dayOfRes"] ?? "-1")"
                                        var resTime = ""
                                        let startTime = Int(reservation["startTime"] ?? "-1") ?? 0
                                        let endTime = Int(reservation["endTime"] ?? "-1") ?? 0
                                        
                                        if(startTime <= 12){
                                            resTime += "\(startTime)AM - "
                                        }else{
                                            resTime += "\(startTime - 12)PM - "
                                        }
                                        
                                        if(endTime <= 12){
                                            resTime += "\(endTime)AM"
                                        }else{
                                            resTime += "\(endTime - 12)PM"
                                        }
                                        
                                        self.myReservations.append(["date":resDateString,"time":resTime,"realStartTime":"\(startTime)","startTime":reservation["startTime"] ?? "-1","monthOfRes":reservation["monthOfRes"] ?? "-1","dayOfRes":reservation["dayOfRes"] ?? "-1"])
                                    }else if(reservation["userID"] != nil){
                                        if(Int(reservation["monthOfRes"] ?? "0") == self.currentMonth && Int(reservation["dayOfRes"] ?? "0") == self.currentDate){
                                            
                                            let resCreatorName = reservation["person"] ?? "error"
                                            
                                            var resTime = ""
                                            let startTime = Int(reservation["startTime"] ?? "-1") ?? 0
                                            let endTime = Int(reservation["endTime"] ?? "-1") ?? 0
                                            
                                            if(startTime <= 12){
                                                resTime += "\(startTime)AM - "
                                            }else{
                                                resTime += "\(startTime - 12)PM - "
                                            }
                                            
                                            if(endTime <= 12){
                                                resTime += "\(endTime)AM"
                                            }else{
                                                resTime += "\(endTime - 12)PM"
                                            }
                                            
                                            self.groupReservations.append(["personName":resCreatorName,"time":resTime,"realStartTime":"\(startTime)","startTime":reservation["startTime"] ?? "-1","monthOfRes":reservation["monthOfRes"] ?? "-1","dayOfRes":reservation["dayOfRes"] ?? "-1"])
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
            let startTime = Int(reservation["startTime"] ?? "0") ?? 0
            
            let ultTime = (startTime) + (day * 100) + (month * 10000) // + (year * 1000000)
            
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
            userResCell.timePeriodLabel.adjustsFontSizeToFitWidth = true
            userResCell.dateLabel.text = myReservations[indexPath.row]["date"]
            userResCell.timePeriodLabel.text = myReservations[indexPath.row]["time"]
            return userResCell
        } else {
            let todayResCell = collectionView.dequeueReusableCell(withReuseIdentifier: "todayCell", for: indexPath as IndexPath) as! TodayReservationCell
            todayResCell.layer.cornerRadius = 15
            todayResCell.backgroundColor = itsSpelledGrey
            todayResCell.timePeriodLabel.adjustsFontSizeToFitWidth = true
            todayResCell.nameLabel.text = groupReservations[indexPath.row]["personName"]
            todayResCell.timePeriodLabel.text = groupReservations[indexPath.row]["time"]
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

