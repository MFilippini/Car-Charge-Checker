//
//  SettingsViewController.swift
//  Car Charge Checker
//
//  Created by Michael Filippini on 12/3/18.
//  Copyright © 2018 Michael Filippini. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        slideMenuController()?.addLeftGestures()
    }

    @IBAction func hamburgerTapped(_ sender: Any) {
        slideMenuController()?.openLeft()
    }

}
