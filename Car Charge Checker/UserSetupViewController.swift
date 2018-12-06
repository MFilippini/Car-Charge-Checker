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

class UserSetupViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var licensePlateField: UITextField!
    @IBOutlet weak var carColorTextField: UITextField!

    @IBOutlet weak var firstNameBackgroundView: UIView!
    @IBOutlet weak var lastNameBackgroundView: UIView!
    @IBOutlet weak var lisencePlateBackgroundView: UIView!
    @IBOutlet weak var carColorBackgroundView: UIView!
    
    @IBOutlet weak var continueButton: UIButton!

    var textFields : [UITextField] = []
    var backgroundViews : [UIView] = []
    let user = Auth.auth().currentUser

    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFields = [firstNameField,lastNameField,licensePlateField,carColorTextField]
        backgroundViews = [firstNameBackgroundView,lastNameBackgroundView,lisencePlateBackgroundView,carColorBackgroundView]
        setupUI()
        
        for field in textFields{
            field.delegate = self
        }
        
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        slideMenuController()?.removeLeftGestures()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for field in textFields{
            field.endEditing(true)
        }
    }
    
    func setupUI(){
        continueButton.layer.backgroundColor = notBlack.cgColor
        continueButton.alpha = 0.4
        continueButton.layer.cornerRadius = 15
        continueButton.isEnabled = false
        for view in backgroundViews{
            view.layer.cornerRadius = 20
        }
        for field in textFields{
            field.layer.borderWidth = 1
            field.layer.borderColor = evqBlue.cgColor
            field.layer.cornerRadius = 5
        }
        fillNames()
    }
    
    func fillNames(){
        var name = Auth.auth().currentUser?.displayName ?? ""
        let nameBreak = name.lastIndex(of: " ") ?? name.endIndex
        firstNameField.text = String(name[..<nameBreak])
        name.removeSubrange(...nameBreak)
        lastNameField.text = name
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    func updateButton(){
        if(allTextFilled()){
            continueButton.isEnabled = true
            continueButton.layer.backgroundColor = evqBlue.cgColor
            continueButton.alpha = 1
        }else{
            continueButton.isEnabled = false
            continueButton.layer.backgroundColor = notBlack.cgColor
            continueButton.alpha = 0.4
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
        let profile = [ "firstName": firstNameField.text,
                        "lastName": lastNameField.text,
                        "licensePlate": licensePlateField.text,
                        "carColor": carColorTextField.text,
                        "email": user?.email?.debugDescription]
        let childUpdates = ["/users/\(key)": profile,]
        ref.updateChildValues(childUpdates)
        
        let setupScreen = self.storyboard?.instantiateViewController(withIdentifier: "Main")
        
        self.slideMenuController()?.changeMainViewController(setupScreen!, close: true)
        
        }
    

    
}
