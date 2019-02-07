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
                                self.selectedGroupLabel.text = name
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.usersReservationsCollectionView {
            let userResCell = collectionView.dequeueReusableCell(withReuseIdentifier: "usersCell", for: indexPath as IndexPath) as! UserReservationCell
            userResCell.layer.cornerRadius = 15
            userResCell.backgroundColor = itsSpelledGrey
            userResCell.dateLabel.text = "12/22"
            userResCell.timePeriodLabel.text = "12 - 4"
            return userResCell
        }
            
        else {
            let todayResCell = collectionView.dequeueReusableCell(withReuseIdentifier: "todayCell", for: indexPath as IndexPath) as! TodayReservationCell
            todayResCell.layer.cornerRadius = 15
            todayResCell.backgroundColor = itsSpelledGrey
            todayResCell.nameLabel.text = "Tommy"
            todayResCell.timePeriodLabel.text = "12 - 4"
            return todayResCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.usersReservationsCollectionView {
            return 4
        }
            
        else {
            return 7
        }
    }

    
    @IBAction func hamburgerPressed(_ sender: Any) {
        slideMenuController()?.openLeft()
    }
    
    @IBAction func reserveButtonPressed(_ sender: Any) {
        
    }
    
}

