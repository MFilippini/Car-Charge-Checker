//
//  firstHomeScreen.swift
//  Car Charge Checker
//
//  Created by Alush Benitez on 2/8/19.
//  Copyright © 2019 Michael Filippini. All rights reserved.
//

import UIKit

class firstHomeScreen: UIViewController {
    
    @IBOutlet weak var nameGreetingLabel: UILabel!
    @IBOutlet weak var createAGroupButton: UIButton!
    @IBOutlet weak var invitesTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        createAGroupButton.layer.cornerRadius = 10
        nameGreetingLabel.text = "Hey " + firstName! + "!"
        invitesTableView.backgroundColor = .clear
        
        view.layer.insertSublayer({
            let layer = CAGradientLayer()
            layer.frame = view.bounds
            layer.colors = [evqBlue.cgColor, evqTeal.cgColor]
            return layer
        }(), at: 0)
    }
    
    @IBAction func createAGroupPressed(_ sender: Any) {
        let groupCreate = storyboard?.instantiateViewController(withIdentifier: "GroupCreate")
        slideMenuController()?.changeMainViewController(groupCreate!, close: true)
    }
    
}
