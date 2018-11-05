//
//  UserSetupViewController.swift
//  Car Charge Checker
//
//  Created by Michael Filippini on 11/2/18.
//  Copyright © 2018 Michael Filippini. All rights reserved.
//

import UIKit

class UserSetupViewController: UIViewController {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var licensePlateField: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    func setupUI(){
        continueButton.layer.backgroundColor = evqBlue.cgColor
        continueButton.tintColor = UIColor.white
        continueButton.layer.cornerRadius = 15
        print("ui setup")
    }
    
    @IBAction func onSubmitClicked(_ sender: Any) {
        
    }
    

    
}
