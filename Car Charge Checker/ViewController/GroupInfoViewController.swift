//
//  GroupInfoViewController.swift
//  Car Charge Checker
//
//  Created by Alush Benitez on 3/15/19.
//  Copyright © 2019 Michael Filippini. All rights reserved.
//

import UIKit
import Foundation
import FirebaseAuth
import Firebase

class GroupInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var memberListTableView: UITableView!
    
    var ref: DatabaseReference!
    var membersInGroup: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        memberListTableView.delegate = self
        memberListTableView.dataSource = self
        //setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        slideMenuController()?.addLeftGestures()
        setup()
    }
    
    func setup(){
        ref = Database.database().reference()
        if let userID = Auth.auth().currentUser?.uid {
            ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let groups = value?["groupsIn"] as? NSDictionary
                if(groups != nil){
                    for (_, group) in groups!{
                        if (group as? String) == selectedGroup {
                            self.ref.child("groups").child(group as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                                let value = snapshot.value as? NSDictionary
                                let name = value?["groupName"] as? String
                                self.groupNameLabel.text = name
                            }) { (error) in
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
            ref.child("groups").child(selectedGroup ?? "error").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let groupMembers = value?["membersInGroup"] as? [String]
                if groupMembers != nil {
                    for i in 0...groupMembers!.count - 1 {
                        self.membersInGroup.append(groupMembers![i])
                    }
                }
                print(self.membersInGroup)
                print("jkhasefjhasf")
                self.memberListTableView.reloadData()
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return membersInGroup.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.memberListTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! memberCell
        cell.nameLabel.text = membersInGroup[indexPath.row]
        return cell
    }
    

    @IBAction func addMemberButtonPressed(_ sender: Any) {
        
        
        
    }
    
    @IBAction func hamburgerPressed(_ sender: Any) {
        slideMenuController()?.openLeft() 
    }
    
}

class memberCell: UITableViewCell{
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
}
