//
//  CreateGroupViewController.swift
//  Car Charge Checker
//
//  Created by Michael Filippini on 12/4/18.
//  Copyright © 2018 Michael Filippini. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var inviteField: UITextField!
    
    @IBOutlet weak var inGroupList: UITableView!
    
    @IBOutlet weak var groupNameView: UIView!
    @IBOutlet weak var groupMembersView: UIView!
    @IBOutlet weak var numChargersView: UIView!
    
    @IBOutlet weak var numChargersStepper: UIStepper!
    @IBOutlet weak var stepperLabel: UILabel!
    
    @IBOutlet weak var createGroupButton: UIButton!
    
    var textFields : [UITextField] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        for view in [groupNameView,groupMembersView,numChargersView]{
            view!.layer.cornerRadius = 26
        }
        numChargersStepper.minimumValue = 1
        numChargersStepper.maximumValue = 50
        numChargersStepper.stepValue = 1
        
        createGroupButton.layer.cornerRadius = 15
        createGroupButton.isEnabled = false
        createGroupButton.backgroundColor = notBlack
        createGroupButton.alpha = 0.4
        
        textFields = [nameField,inviteField]
        for field in textFields{
            field.delegate = self
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        
    }
    
    @IBAction func groupNameChanged(_ sender: Any) {
        let text = nameField.text
        if(text?.isEmpty ?? false){
            createGroupButton.isEnabled = false
            createGroupButton.backgroundColor = notBlack
            createGroupButton.alpha = 0.4
        }else{
            createGroupButton.isEnabled = true
            createGroupButton.backgroundColor = evqBlue
            createGroupButton.alpha = 1
        }
    }
    
    @IBAction func stepperChanged(_ sender: Any) {
        stepperLabel.text = String(Int(numChargersStepper.value))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        slideMenuController()?.addLeftGestures()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        for field in textFields{
            field.endEditing(true)
        }
    }
    
    @IBAction func hamburgerTapped(_ sender: Any) {
        slideMenuController()?.openLeft()
    }
    
    @IBAction func createGroupPressed(_ sender: Any) {
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
