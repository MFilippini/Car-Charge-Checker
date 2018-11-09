//
//  UserSetupViewController.swift
//  Car Charge Checker
//
//  Created by Michael Filippini on 11/2/18.
//  Copyright © 2018 Michael Filippini. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class UserSetupViewController: UIViewController {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var licensePlateField: UITextField!
    @IBOutlet weak var carColorTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!

    var textFields : [UITextField] = []
    let user = Auth.auth().currentUser

    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        textFields = [firstNameField,lastNameField,licensePlateField,carColorTextField]
        ref = Database.database().reference()
    }
    
    func setupUI(){
        continueButton.layer.backgroundColor = UIColor.black.cgColor
        continueButton.layer.cornerRadius = 15
        continueButton.isEnabled = false
        firstNameField.text = Auth.auth().currentUser?.displayName
    }
    
    @IBAction func firstNameFieldChanged(_ sender: Any) {
        updateButton()
    }
   
    @IBAction func lastNameFieldChanged(_ sender: Any) {
        updateButton()
    }
    
    @IBAction func lisencePlateFieldChanged(_ sender: Any) {
        updateButton()
    }
    
    @IBAction func carColorFieldChanged(_ sender: Any) {
        updateButton()
    }
    
    
    func updateButton(){
        if(allTextFilled()){
            continueButton.isEnabled = true
            continueButton.layer.backgroundColor = evqBlue.cgColor
        }else{
            continueButton.isEnabled = false
            continueButton.layer.backgroundColor = UIColor.black.cgColor
        }
    }
    
    func allTextFilled() -> Bool{
        for field in textFields{
            let text = field.text
            if(text?.isEmpty ?? false){
                return false
            }
        }
        return true
    }
    
    
    @IBAction func onSubmitClicked(_ sender: Any) {
        print("clicked")
        print(user!.uid)
        let id = user!.uid
        let key = ref.child("users").child(id).key!
        let profile = ["firstName": firstNameField.text,
                    "lastName": lastNameField.text,
                    "licensePlate": licensePlateField.text,
                    "carColor": carColorTextField.text]
        let childUpdates = ["/users/\(key)": profile,]
        ref.updateChildValues(childUpdates)
        
        performSegue(withIdentifier: "toMainViewFromSetup", sender: nil)
    }
    

    
}
