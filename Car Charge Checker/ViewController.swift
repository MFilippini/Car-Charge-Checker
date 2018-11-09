//
//  ViewController.swift
//  Car Charge Checker
//
//  Created by Michael Filippini on 10/22/18.
//  Copyright © 2018 Michael Filippini. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var reservationDescription: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    //var data = [String]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 130
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
        //Return total number of chargers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "custom", for: indexPath) as! CustomCell
        cell.identifyingImage?.image = UIImage(named: "square")
        cell.name?.text = "Charger 1"
        cell.status?.text = "Reserved Until 5:00 PM"
        cell.statusIndicator.backgroundColor = .red
        
        //Constraints
//        cell.identifyingImage.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
//        cell.identifyingImage.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
//        cell.identifyingImage.widthAnchor.constraint(equalToConstant: 124).isActive = true
//        cell.identifyingImage.heightAnchor.constraint(equalToConstant: 124).isActive = true
//
//        cell.name.topAnchor

        
        return cell
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //self.tableView.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 55,right: 0)
    }
    
    
    
    
    
    
    @IBAction func PlusPressed(_ sender: Any) {
    }
    
    
    
}


class CustomCell: UITableViewCell {
    
    @IBOutlet weak var identifyingImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var reserveButton: UIButton!
    @IBOutlet weak var statusIndicator: UIView!
    
}

