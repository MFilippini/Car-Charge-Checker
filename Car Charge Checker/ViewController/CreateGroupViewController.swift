//
//  CreateGroupViewController.swift
//  Car Charge Checker
//
//  Created by Michael Filippini on 12/4/18.
//  Copyright © 2018 Michael Filippini. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class CreateGroupViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var inviteField: UITextField!
    
    @IBOutlet weak var inGroupList: UITableView!
    
    @IBOutlet weak var groupNameView: UIView!
    @IBOutlet weak var groupMembersView: UIView!
    @IBOutlet weak var numChargersView: UIView!
    
    @IBOutlet weak var numChargersStepper: UIStepper!
    @IBOutlet weak var stepperLabel: UILabel!
    
    @IBOutlet weak var createGroupButton: UIButton!
    
    var textFields : [UITextField] = []
    var inGroupNames : [String] = []
    
    var ref: DatabaseReference!
    let user = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        for view in [groupNameView,groupMembersView,numChargersView]{
            view!.layer.cornerRadius = 26
        }
        
        ref = Database.database().reference()

        self.inGroupList.delegate = self
        self.inGroupList.dataSource = self
        numChargersStepper.minimumValue = 1
        numChargersStepper.maximumValue = 50
        numChargersStepper.stepValue = 1
        
        createGroupButton.layer.cornerRadius = 15
        createGroupButton.isEnabled = false
        createGroupButton.backgroundColor = notBlack
        createGroupButton.alpha = 0.4
        
        textFields = [nameField,inviteField]
        for field in textFields{
            field.delegate = self
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inGroupNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.inGroupList.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! nameCell
        cell.nameLabel.text = inGroupNames[indexPath.row]
        return cell
    }
    
    @IBAction func groupNameChanged(_ sender: Any) {
        let text = nameField.text
        if(text?.isEmpty ?? false){
            createGroupButton.isEnabled = false
            createGroupButton.backgroundColor = notBlack
            createGroupButton.alpha = 0.4
        }else{
            createGroupButton.isEnabled = true
            createGroupButton.backgroundColor = evqBlue
            createGroupButton.alpha = 1
        }
    }
    
    @IBAction func stepperChanged(_ sender: Any) {
        stepperLabel.text = String(Int(numChargersStepper.value))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        slideMenuController()?.addLeftGestures()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        for field in textFields{
            field.endEditing(true)
        }
    }
    
    @IBAction func hamburgerTapped(_ sender: Any) {
        slideMenuController()?.openLeft()
    }
    
    @IBAction func addNameToGroupPressed(_ sender: Any) {
        print("pressed")
        if(inviteField.text != ""){
            print("inside")
            inGroupNames.insert(inviteField.text ?? "error", at: 0)
            inviteField.text = ""
            print("gonna reload")
            inGroupList.reloadData()
            print("done")

        }
    }
    
    @IBAction func createGroupPressed(_ sender: Any) {
        
        //Put Data In
        
        //Data Under Groups
        var groupName = (nameField.text?.replacingOccurrences(of: " ", with: "").lowercased())!
        clean(String: &groupName)
        let id = "\(groupName)\(user!.uid)"
        let groupKey = ref.child("groups").child(id).key!
        let numChargers = Int(numChargersStepper.value)
        let groupInfo = [ "groupName": nameField.text,
                        "numChargers": numChargers,
                        "creator": "\(user?.email ?? "error")",
                        "membersInvited": inGroupNames,
                        "membersInGroup": ["\(user?.email ?? "error")"]] as [String : Any]
        let childUpdatesUser = ["/groups/\(groupKey)": groupInfo,]
        ref.updateChildValues(childUpdatesUser)
        
        //Find People
        for name in inGroupNames{
            var email = name
            clean(String: &email)
            print(email)
            ref = Database.database().reference()
            ref.child("emails").child(email).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let foundID = value?["id"] as? String ?? "noID"
                
                
                let key = self.ref.child("users").childByAutoId().key!
                
                let childUpdates = ["/users/\(foundID)/groupRequests/\(key)": id,]
                self.ref.updateChildValues(childUpdates)
                
                
            }) { (error) in
                print(error.localizedDescription)
            }
    
        }
        //adds creator to group
        ref = Database.database().reference()
        let key = self.ref.child("users").childByAutoId().key!
        
        let childUpdates = ["/users/\(user!.uid)/groupsIn/\(key)": id,]
        self.ref.updateChildValues(childUpdates)
        //Adjust Local Data
        
        
        
        //Return to Main Screen
    }
    
    func clean(String: inout String){
        let notAllowed = [".","#","$","[","]"]
        let allowed = ["dot","pound","dollar","openBracket","closeBracket"]
        for i in 0..<notAllowed.count{
            String = String.replacingOccurrences(of: notAllowed[i], with: allowed[i])
        }
    }
    
}


class nameCell: UITableViewCell{
    
    @IBOutlet weak var nameLabel: UILabel!
    
}
