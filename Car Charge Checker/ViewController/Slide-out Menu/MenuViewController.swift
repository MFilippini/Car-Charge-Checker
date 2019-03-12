//
//  MenuViewController.swift
//  Car Charge Checker
//
//  Created by Michael Filippini on 11/13/18.
//  Copyright © 2018 Michael Filippini. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var welcomeNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var notificationBellLabel: UILabel!
    @IBOutlet weak var groupsTableView: UITableView!
    @IBOutlet weak var newGroupButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var inboxButton: UIButton!
    
    var groupsInArray: [String] = []
    var groupInNamesArray: [String] = []
    var groupInNamesArrayTemp: [String] = []
    var selectedIndexRow: Int = -1
    var ref: DatabaseReference!
    
    let user = Auth.auth().currentUser
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newGroupButton.layer.cornerRadius = 10
        notificationBellLabel.textColor = .white
        notificationBellLabel.layer.backgroundColor = evqBlue.cgColor
        notificationBellLabel.layer.cornerRadius = 9
        self.groupsTableView.delegate = self
        self.groupsTableView.dataSource = self
        notificationBellLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //check for notifications
        super.viewWillAppear(animated)
        
        print("wooooooorkkkkk")
        ref = Database.database().reference()
        if let userID = Auth.auth().currentUser?.uid {
            ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let requests = value?["groupRequests"] as? NSDictionary
                if(requests != nil && requests?.count != 0){
                    if((self.notificationBellLabel.text ?? "none" != String(requests?.count ?? 0)) || ((self.notificationBellLabel.text == String(requests?.count ?? 0)) && self.notificationBellLabel.isHidden)){
                        print( "updateNotif textNow\(self.notificationBellLabel.text ?? "none") update\(String(requests?.count ?? 0)) hidden \(self.notificationBellLabel.isHidden)")
                        
                        self.notificationBellLabel.text = String(requests?.count ?? 0)
                        self.notificationBellLabel.isHidden = false
                    }
                }else{
                    self.notificationBellLabel.isHidden = true
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
        
        if let userID = Auth.auth().currentUser?.uid {
            ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                self.groupsInArray = []
                let value = snapshot.value as? NSDictionary
                firstName = value?["firstName"] as? String
                self.welcomeNameLabel.text = "Hey, " + (firstName ?? "error") + "!"
                let groups = value?["groupsIn"] as? NSDictionary
                print("groups HERE  \(groups)")
                if(groups != nil){
                    if(groups?.count != 0){
                        //Add data to groupsInArray
                        for (_, group) in groups!{
                            self.groupsInArray.append(group as! String)
                        }
                    }
                }
                
                self.groupInNamesArrayTemp = []
                
                print("groupsInArray: \(self.groupsInArray)")
                if(self.groupsInArray.count == 0){
                    print("ID: \(self.slideMenuController()?.mainViewController?.restorationIdentifier)")
                   if(self.slideMenuController()?.mainViewController?.restorationIdentifier ?? "" != "GroupCreate" && "greeting" != self.slideMenuController()?.mainViewController?.restorationIdentifier ?? ""){
                    
                        let setupScreen = self.storyboard?.instantiateViewController(withIdentifier: "greeting")
                        self.slideMenuController()?.changeMainViewController(setupScreen!, close: true)
                    }
                }
                
                for group in self.groupsInArray{
                    self.ref.child("groups").child(group).observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        let name = value?["groupName"] as? String
                        self.groupInNamesArrayTemp.append(name ?? "error")
                        print(self.groupsInArray.count - 1)
                        print(self.groupsInArray)
                        print(self.groupInNamesArray)
                        print(self.groupInNamesArrayTemp)
                        if( group == self.groupsInArray[self.groupsInArray.count - 1] && self.groupInNamesArray != self.groupInNamesArrayTemp ){
                            self.groupInNamesArray = self.groupInNamesArrayTemp
                            self.groupsTableView.reloadData()
                        }
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupsTableView.dequeueReusableCell(withIdentifier: "groupsCell", for: indexPath) as! GroupSelectionCell
        print("row:\(indexPath.section) \n data\(groupInNamesArray)")
        cell.groupNameLabel.text = groupInNamesArray[indexPath.section]
        cell.layer.cornerRadius = 15
        cell.layer.borderWidth = 2
        cell.layer.borderColor = itsSpelledGrey.cgColor
        cell.groupInfoButton.layer.cornerRadius = 10
        cell.leaveGroupButton.layer.cornerRadius = 10
        cell.groupInfoButton.tag = indexPath.section
        cell.leaveGroupButton.tag = indexPath.section
        
        
        if selectedIndexRow == indexPath.section {
            cell.backgroundColor = itsSpelledGrey
        } else {
            cell.backgroundColor = .white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupInNamesArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentGroup = groupsInArray[indexPath.section]
        ref = Database.database().reference()
        if currentGroup != nil {
            ref.child("groups").child(currentGroup!).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                numberOfChargers = value?["numChargers"] as? Int
                print("numChargers: \(numberOfChargers)")
                let deselectIndexPath = IndexPath(row: self.selectedIndexRow, section: 0)
                self.groupsTableView.deselectRow(at: deselectIndexPath, animated: true)
                self.groupsTableView.cellForRow(at: deselectIndexPath)?.isSelected = false
                self.selectedIndexRow = indexPath.section
                self.groupsTableView.reloadData()
                let main = self.storyboard?.instantiateViewController(withIdentifier: "Main")
                self.slideMenuController()?.changeMainViewController(main!, close: true)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = groupsTableView.dequeueReusableCell(withIdentifier: "groupsCell", for: indexPath) as! GroupSelectionCell
        cell.backgroundColor = .white
        return indexPath
    }
    
    
    
    @IBAction func signOutClicked(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            GIDSignIn.sharedInstance().signOut()
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let signIn = storyboard?.instantiateViewController(withIdentifier: "SignIn")
        slideMenuController()?.changeMainViewController(signIn!, close: true)
    }
    
    @IBAction func settingsClicked(_ sender: Any) {
        let settings = storyboard?.instantiateViewController(withIdentifier: "Settings")
        slideMenuController()?.changeMainViewController(settings!, close: true)
    }
    
    @IBAction func bellTapped(_ sender: Any) {
        let notification = storyboard?.instantiateViewController(withIdentifier: "Notifications")
        slideMenuController()?.changeMainViewController(notification!, close: true)
    }
    
    @IBAction func createNewGroupTapped(_ sender: Any) {
        let groupCreate = storyboard?.instantiateViewController(withIdentifier: "GroupCreate")
        slideMenuController()?.changeMainViewController(groupCreate!, close: true)
    }
    
    func setCurrentGroup(){
        if(self.groupsInArray.count == 0){
            print("ID: \(self.slideMenuController()?.mainViewController?.restorationIdentifier)")
            if(self.slideMenuController()?.mainViewController?.restorationIdentifier ?? "" != "GroupCreate" && "greeting" != self.slideMenuController()?.mainViewController?.restorationIdentifier ?? ""){
                
                let setupScreen = self.storyboard?.instantiateViewController(withIdentifier: "greeting")
                self.slideMenuController()?.changeMainViewController(setupScreen!, close: true)
            }
        }
        currentGroup = groupsInArray[0]
        //groupsTableView.se
    }
    
    
    
    @IBAction func leaveGroupTapped(_ sender: UIButton ) {
        let groupToDelete = groupsInArray[sender.tag]
        ref = Database.database().reference()
        
        if let userID = Auth.auth().currentUser?.uid {
            ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let groups = value?["groupsIn"] as? NSDictionary ?? ["":""]
                
                for (key,group) in groups{
                    if(group as! String == groupToDelete){
                        groups.setValue(nil, forKey: key as! String)
                    }
                }
                
                let childUpdatesUserGroup = ["/users/\(userID ?? "error")/groupsIn/": groups,]
                self.ref.updateChildValues(childUpdatesUserGroup)
                
    
                self.ref.child("groups").child(groupToDelete).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let inGroupNS = value?["membersInGroup"] as? NSArray ?? []
                    var inGroup: Array = inGroupNS as Array
                    for var i in 0..<inGroup.count {
                        print("i:\(i)")
                        if(inGroup[i] as! String == self.user?.email ?? ""){
                            inGroup.remove(at: i)
                            print("removed")
                            i -= 1
                        }
                    }
                    
                    let childUpdatesGroupMem = ["/groups/\(groupToDelete)/membersInGroup/": inGroup as NSArray,]
                    self.ref.updateChildValues(childUpdatesGroupMem)
                    
                    if(inGroup.count == 0){
                        let childUpdatesGroup = ["/groups/\(groupToDelete)/": ["group":nil],]
                        self.ref.updateChildValues(childUpdatesGroup)
                    }
                    
                    
                    
                    self.ref.child("groups").child(groupToDelete).observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        let reservationsNS = value?["reservations"] as? NSDictionary ?? ["":""]
                        var reservations = reservationsNS as? Dictionary<String,Dictionary<String,String>> ?? ["":["":""]]
                        
                        print(reservations)
                        print(userID)
                        
                        for (key,reservation) in reservations {
                            if(key != "" && reservation != ["":""]){
                                if((reservation["userID"]) == userID){
                                    reservations.removeValue(forKey: key)
                                }
                            }
                        }
                        
                        if(reservations != ["":["":""]]){
                            let childUpdatesGroupRes = ["/groups/\(groupToDelete)/reservations/": reservations as NSDictionary,]
                            self.ref.updateChildValues(childUpdatesGroupRes)
                        }
                        
                        
                        self.viewWillAppear(true)
                        
                    }) { (error) in
                        print(error.localizedDescription)
                    }

                }) { (error) in
                    print(error.localizedDescription)
                }
                
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
        
        groupsTableView.reloadData()
    }
    

}
