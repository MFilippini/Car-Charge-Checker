//
//  NotificationsViewController.swift
//  Car Charge Checker
//
//  Created by Michael Filippini on 1/4/19.
//  Copyright © 2019 Michael Filippini. All rights reserved.
//
import UIKit
import Firebase
import GoogleSignIn

class NotificationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        slideMenuController()?.addLeftGestures()
    }

    @IBAction func hamburgerTapped(_ sender: Any) {
        slideMenuController()?.openLeft()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
