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

class MenuViewController: UIViewController {

    @IBOutlet weak var welcomeNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var groupsTableView: UITableView!
    @IBOutlet weak var newGroupButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var inboxButton: UIButton!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newGroupButton.layer.cornerRadius = 10
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let firstName = value?["firstName"] as? String ?? ""
            //let user = User(username: username)
            self.welcomeNameLabel.text = "Hello, " + firstName

            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }

    }
    
    @IBAction func signOutClicked(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let signIn = storyboard?.instantiateViewController(withIdentifier: "SignIn")
        slideMenuController()?.changeMainViewController(signIn!, close: true)
    }
    
    @IBAction func settingsClicked(_ sender: Any) {
    }
    
}
