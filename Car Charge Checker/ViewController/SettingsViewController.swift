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
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var textFields : [UITextField] = []
    var backgroundViews : [UIView] = []
    var userData = ["first","last"]
    
    var ref: DatabaseReference!
    let user = Auth.auth().currentUser

    
    override func viewDidLoad() {
        super.viewDidLoad()
        restrictedMode = false
        backgroundViews = [firstNameView,lastNameView]
        textFields = [firstNameTextField,lastNameTextField]
        setupUI();
    }
    
    func setupUI(){
        for view in backgroundViews{
            view.layer.cornerRadius = 20
        }
        saveButton.layer.backgroundColor = toothpaste.cgColor
        //saveButton.alpha = 0.4
        saveButton.layer.cornerRadius = 15
        //saveButton.isEnabled = false
        for field in textFields{
            field.layer.borderWidth = 1
            field.layer.borderColor = evqBlue.cgColor
            field.layer.cornerRadius = 5
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
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
                
                
                
                for i in 0..<2{
                    self.textFields[i].text = self.userData[i]
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        for field in textFields{
            field.endEditing(true)
        }
    }

    @IBAction func hamburgerTapped(_ sender: Any) {
        slideMenuController()?.openLeft()
    }

    @IBAction func saveChangesPressed(_ sender: Any) {
        let id = user!.uid
        let userKey = ref.child("users").child(id).key!
        
        
        let firstName = firstNameTextField.text ?? "error"
        let lastName = lastNameTextField.text ?? "error"
        
        if firstName == "" || lastName == "" {
            
            let alert = UIAlertController(title: "Invalid Input", message: "Please make sure all the fields are filled in!", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let childUpdatesUser = ["/users/\(userKey)/firstName": firstName, "/users/\(userKey)/lastName": lastName]
            ref.updateChildValues(childUpdatesUser)
            
            let alert = UIAlertController(title: "Saved!", message: "", preferredStyle: UIAlertController.Style.alert)
            
            present(alert, animated: true)
            
            let when = DispatchTime.now() + 0.6
            DispatchQueue.main.asyncAfter(deadline: when){
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
