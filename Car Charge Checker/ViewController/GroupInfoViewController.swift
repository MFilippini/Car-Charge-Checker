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
    @IBOutlet weak var addMemberButton: UIButton!
    
    var ref: DatabaseReference!
    let user = Auth.auth().currentUser
    var membersInGroup: [String] = []
    var membersInvited: [String] = []

    var groupName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memberListTableView.delegate = self
        memberListTableView.dataSource = self
        addMemberButton.layer.cornerRadius = 15
        
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
                self.membersInvited = value?["membersInvited"] as? [String] ?? []
                self.groupName = value?["groupName"] as? String ?? "error"
                if groupMembers != nil {
                    for i in 0...groupMembers!.count - 1 {
                        self.membersInGroup.append(groupMembers![i])
                    }
                }
                print(self.membersInGroup)
                print("jkhasefjhasf") //beautiful print statement debugging
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

    func clean(String: inout String){
        let notAllowed = [".","#","$","[","]"]
        let allowed = ["dot","pound","dollar","openBracket","closeBracket"]
        for i in 0..<notAllowed.count{
            String = String.replacingOccurrences(of: notAllowed[i], with: allowed[i])
        }
    }
    
    @IBAction func addMemberButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add A Member", message: "Input the email associated with the account", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in
            //let textField = alert.textFields![0] as UITextField
            let newEmailField = alert.textFields![0]
            
            var newEmail = newEmailField.text ?? ""
            
                let uncleanEmail = newEmail
            
                self.clean(String: &newEmail)
                print(newEmail)
            
                self.ref = Database.database().reference()
                self.ref.child("emails").child(newEmail).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    let foundID = value?["id"] as? String ?? "noID"

                    // user exists is not already in group and has not already been invited
                    if(foundID != "noID" && !self.membersInGroup.contains(uncleanEmail) && !self.membersInvited.contains(foundID)){
                        
                        let childUpdatesRequest = ["/users/\(foundID)/groupRequests/(\(selectedGroup ?? "error")+request)": (selectedGroup ?? "error"),]

                        self.membersInvited.append(foundID)

                        let childUpdateMemebersInvite = ["/groups/\(selectedGroup ?? "error")/membersInvited/": self.membersInvited,]
                            
                        self.ref.updateChildValues(childUpdateMemebersInvite)
                        self.ref.updateChildValues(childUpdatesRequest)
                    }else if(foundID == "noID"){
                        let alert = UIAlertController(title: "Invalid User", message: "Double check the email you tried to add. The user was not found.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }else if(self.membersInvited.contains(foundID)){
                        let alert = UIAlertController(title: "Invalid User", message: "That user has already been invited to join this group.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        let alert = UIAlertController(title: "Invalid User", message: "That user is already in the group.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
        
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addTextField { (textField) in
            textField.placeholder = "Email"
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        alert.preferredAction = action
        
        //self.view.present(GroupInfoViewController, animated:true, completion: nil)
        present(alert, animated: true)
    }
    
    @IBAction func hamburgerPressed(_ sender: Any) {
        slideMenuController()?.openLeft() 
    }
    
}

class memberCell: UITableViewCell{
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
}
