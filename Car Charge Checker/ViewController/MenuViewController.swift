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

class MenuViewController: UIViewController {

    @IBOutlet weak var welcomeNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var notificationBellLabel: UILabel!
    @IBOutlet weak var groupsTableView: UITableView!
    @IBOutlet weak var newGroupButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var inboxButton: UIButton!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newGroupButton.layer.cornerRadius = 10
       // notificationBellLabel.layer.borderWidth = 3
       // notificationBellLabel.layer.borderColor = UIColor.black.cgColor
        notificationBellLabel.textColor = .white
        notificationBellLabel.layer.backgroundColor = evqBlue.cgColor
        notificationBellLabel.layer.cornerRadius = 9
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ref = Database.database().reference()
        if let userID = Auth.auth().currentUser?.uid {
            ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let firstName = value?["firstName"] as? String ?? ""
                self.welcomeNameLabel.text = "Hello, " + firstName
                
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        notificationBellLabel.isHidden = true
        //check for notifications
        ref = Database.database().reference()
        if let userID = Auth.auth().currentUser?.uid {
            ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let requests = value?["groupRequests"] as? NSDictionary
                if(requests != nil){
                    if(requests?.count != 0){
                        self.notificationBellLabel.isHidden = false
                        self.notificationBellLabel.text = String(requests?.count ?? 0)
                    }
                }
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        }
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
    
    @IBAction func homeTapped(_ sender: Any) {
        let main = storyboard?.instantiateViewController(withIdentifier: "Main")
        slideMenuController()?.changeMainViewController(main!, close: true)
    }
    
    @IBAction func bellTapped(_ sender: Any) {
        let notification = storyboard?.instantiateViewController(withIdentifier: "Notifications")
        slideMenuController()?.changeMainViewController(notification!, close: true)
    }
    
    @IBAction func createNewGroupTapped(_ sender: Any) {
        let groupCreate = storyboard?.instantiateViewController(withIdentifier: "GroupCreate")
        slideMenuController()?.changeMainViewController(groupCreate!, close: true)
    }
    
}
