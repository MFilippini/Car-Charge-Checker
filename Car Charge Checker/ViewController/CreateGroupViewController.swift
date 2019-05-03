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
    @IBOutlet weak var hamburgerButton: UIButton!
    
    var textFields : [UITextField] = []
    var inGroupNames : [String] = []
    
    var ref: DatabaseReference!
    let user = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        //Check if first time creating a group
        if let userID = Auth.auth().currentUser?.uid {
            ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                _ = value?["groupsIn"] as? NSDictionary
            }) { (error) in
                print(error.localizedDescription)
            }
        }
                
        
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
        super.viewWillAppear(animated)
        slideMenuController()?.addLeftGestures()
        //hamburgerButton.imageView?.image = UIImage(named: "menu")
        print("restricted\(restrictedMode)")
        if(restrictedMode){
            slideMenuController()?.removeLeftGestures()
            //hamburgerButton.imageView?.image = UIImage(named: "arrow")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(restrictedMode){
            hamburgerButton.setBackgroundImage(UIImage(named: "arrow"), for: .normal)
        }else{
            hamburgerButton.setBackgroundImage(UIImage(named: "menu"), for: .normal)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        for field in textFields{
            field.endEditing(true)
        }
    }
    
    @IBAction func hamburgerTapped(_ sender: Any) {
        if(!restrictedMode){
            slideMenuController()?.openLeft()
        }else{
            let setupScreen = self.storyboard?.instantiateViewController(withIdentifier: "greeting")
            self.slideMenuController()?.changeMainViewController(setupScreen!, close: true)
        }
    }
    
    @IBAction func addNameToGroupPressed(_ sender: Any) {
        if(inviteField.text != ""){
            inGroupNames.insert(inviteField.text ?? "error", at: 0)
            inviteField.text = ""
            inGroupList.reloadData()
        }
    }
    
    @IBAction func createGroupPressed(_ sender: Any) {
        //Data To Groups
        var groupName = (nameField.text?.replacingOccurrences(of: " ", with: "").lowercased())!
        clean(String: &groupName)
        let id = "\(groupName)\(user!.uid)"
        let groupKey = ref.child("groups").child(id).key!
        let numChargers = Int(numChargersStepper.value)
        var membersInvited: [String] = []
        print("update CC")
        print("inGroupNames \(inGroupNames)")
        print("groupKey \(groupKey)")
        ref.child("groups").child(groupKey).observeSingleEvent(of: .value, with: { (snapshot) in
            let group = snapshot.value as? NSDictionary
            if(group == nil){
                
                //Find People
                if(self.inGroupNames.count != 0){
                    for name in self.inGroupNames{
                        var email = name
                        self.clean(String: &email)
                        print(email)
                        self.ref = Database.database().reference()
                        self.ref.child("emails").child(email).observeSingleEvent(of: .value, with: { (snapshot) in
                            // Get user value
                            let value = snapshot.value as? NSDictionary
                            let foundID = value?["id"] as? String ?? "noID"
                            
                            // let key = self.ref.child("users").childByAutoId().key!
                            
                            var creatorsEmail = self.user!.email ?? ""
                            self.clean(String: &creatorsEmail)
                            
                            if(foundID != "noID" && email != creatorsEmail){
                                let childUpdates = ["/users/\(foundID)/groupRequests/(\(id)+request)": id,]
                                self.ref.updateChildValues(childUpdates)
                                membersInvited.append(foundID)
                            }
                            
                            print("update BB")
                            if(self.inGroupNames.last == name){
                                print("update AAA")
                                let groupInfo = [ "groupName": self.nameField.text ?? "error",
                                                  "numChargers": numChargers,
                                                  "creator": "\(self.user?.email ?? "error")",
                                                  "membersInvited": membersInvited,
                                                  "membersInGroup": ["\(self.user?.email ?? "error")"]] as [String : Any]
                                let childUpdatesUser = ["/groups/\(groupKey)": groupInfo,]
                                self.ref.updateChildValues(childUpdatesUser)

                                //adds creator to group
                                self.ref = Database.database().reference()
                                let key = self.ref.child("users").childByAutoId().key!
                                
                                let childUpdates = ["/users/\(self.user!.uid)/groupsIn/\(key)": id,]
                                self.ref.updateChildValues(childUpdates)
                                
                                //Return to Main Screen
                                let main = self.storyboard?.instantiateViewController(withIdentifier: "Main")
                                self.slideMenuController()?.changeMainViewController(main!, close: true)
                                
                            }
                        
                        }) { (error) in
                            print(error.localizedDescription)
                        }
                    }
                }else{
                    print("update AAA")
                    let groupInfo = [ "groupName": self.nameField.text ?? "error",
                                      "numChargers": numChargers,
                                      "creator": "\(self.user?.email ?? "error")",
                        "membersInvited": membersInvited,
                        "membersInGroup": ["\(self.user?.email ?? "error")"]] as [String : Any]
                    let childUpdatesUser = ["/groups/\(groupKey)": groupInfo,]
                    self.ref.updateChildValues(childUpdatesUser)
                    
                    //adds creator to group
                    self.ref = Database.database().reference()
                    let key = self.ref.child("users").childByAutoId().key!
                    
                    let childUpdates = ["/users/\(self.user!.uid)/groupsIn/\(key)": id,]
                    self.ref.updateChildValues(childUpdates)
                    
                    //Return to Main Screen
                    let main = self.storyboard?.instantiateViewController(withIdentifier: "Main")
                    self.slideMenuController()?.changeMainViewController(main!, close: true)
                }
                            
            }else{
                let alert = UIAlertController(title: "Invalid Name", message: "You may not make two groups with the same name.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
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
