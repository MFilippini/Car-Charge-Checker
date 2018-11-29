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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
