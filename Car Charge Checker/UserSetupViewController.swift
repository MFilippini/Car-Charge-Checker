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
    @IBOutlet weak var carColorTextField: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        continueButton.isEnabled = false
    }
    
    
    func allTextFilled() -> Bool{
        if(firstNameField.text == nil){
            return false
        }
        if(lastNameField.text == nil){
            return false
        }
        if(licensePlateField.text == nil){
            return false
        }
        if(carColorTextField.text == nil){
            return false
        }
        return true
    }
    
    func setupUI(){
        continueButton.layer.backgroundColor = evqBlue.cgColor
        continueButton.tintColor = UIColor.white
        continueButton.layer.cornerRadius = 15
        
        continueButton.setTitleColor(UIColor.lightGray, for: .disabled)
        continueButton.setTitleColor(.white, for: .normal)
    }
    
    @IBAction func onSubmitClicked(_ sender: Any) {
        print("clicked")
    }
    

    
}
