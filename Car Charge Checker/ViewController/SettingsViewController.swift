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

    @IBOutlet weak var firstNameView: UIView!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var licenseView: UIView!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var carColorTextField: UITextField!
    @IBOutlet weak var licensePlateTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var textFields : [UITextField] = []
    var backgroundViews : [UIView] = []
    var userData = ["first","last","color","license"]
    
    var ref: DatabaseReference!
    let user = Auth.auth().currentUser

    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundViews = [firstNameView,lastNameView,licenseView,colorView]
        textFields = [firstNameTextField,lastNameTextField,carColorTextField,licensePlateTextField]
        setupUI();
    }
    
    func setupUI(){
        for view in backgroundViews{
            view.layer.cornerRadius = 20
        }
        saveButton.layer.backgroundColor = notBlack.cgColor
        saveButton.alpha = 0.4
        saveButton.layer.cornerRadius = 15
        saveButton.isEnabled = false
        for field in textFields{
            field.layer.borderWidth = 1
            field.layer.borderColor = evqBlue.cgColor
            field.layer.cornerRadius = 5
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        slideMenuController()?.addLeftGestures()
        
        ref = Database.database().reference()
        if let userID = Auth.auth().currentUser?.uid {
            ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                self.userData[0] = value?["firstName"] as? String ?? ""
                self.userData[1] = value?["lastName"] as? String ?? ""
                self.userData[2] = value?["carColor"] as? String ?? ""
                self.userData[3] = value?["licensePlate"] as? String ?? ""
                
                for i in 0..<4{
                    self.textFields[i].text = self.userData[i]
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
    }

    @IBAction func hamburgerTapped(_ sender: Any) {
        slideMenuController()?.openLeft()
    }

    @IBAction func saveChangesPressed(_ sender: Any) {
    }
    
}
