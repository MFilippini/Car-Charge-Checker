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
    @IBOutlet weak var reserveButton: UIButton!
    @IBOutlet weak var accentView: UIView!
    @IBOutlet weak var infoButton: UIButton!
    
    
    //var data = [String]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 140
        self.tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        //tableView.layer.cornerRadius = 15
        reserveButton.layer.cornerRadius = 15
        infoButton.layer.cornerRadius = 15
        infoButton.alpha = 0.4
        accentView.backgroundColor = evqBlue
        accentView.layer.cornerRadius = 700
        
        //reserveButton.alpha = 0.5
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
        //Return total number of chargers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "custom", for: indexPath) as! CustomCell
        if indexPath.row != 0 {
            cell.name?.text = "Charger " + String(indexPath.row)
            cell.status?.text = "Reserved Until 5:00 PM"
            
            if(cell.status.text?.prefix(1) == "F"){
                cell.statusIndicator.backgroundColor = toothpaste
            } else {
                cell.statusIndicator.backgroundColor = softRed
            }
            cell.statusIndicator.layer.cornerRadius = 3

            
        } else {
            cell.name?.text = ""
            cell.status?.text = ""
            cell.statusIndicator.backgroundColor = nil
        }
        
        


        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CustomCell
        if(cell.status.text?.prefix(1) == "F"){
            cell.statusIndicator.backgroundColor = toothpaste
            cell.statusIndicator.layer.cornerRadius = 3
        } else {
            cell.statusIndicator.backgroundColor = softRed
            cell.statusIndicator.layer.cornerRadius = 3
        }
    }
    
    func isAvalible() -> Bool {
        return true
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //self.tableView.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 55,right: 0)
    }
    
    
    
    
    
    
    @IBAction func PlusPressed(_ sender: Any) {
        
    }
    
    
    
}


class CustomCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var colorBackgroundView: UIView!
    @IBOutlet weak var statusIndicator: UIView!
    
    
    
}

