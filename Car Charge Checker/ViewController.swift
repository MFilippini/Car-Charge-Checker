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
        setupUI()
    }
    
    func setupUI(){
        tableView.rowHeight = 140
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        //tableView.layer.cornerRadius = 15
        reserveButton.layer.cornerRadius = 15
        reserveButton.isEnabled = false
        reserveButton.backgroundColor = notBlack
        reserveButton.alpha = 0.4
        
        infoButton.layer.cornerRadius = 15
        infoButton.alpha = 0.4
        
        accentView.backgroundColor = evqBlue
        accentView.layer.cornerRadius = 700
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

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if(tableView.cellForRow(at: indexPath)?.isSelected ?? false){
            tableView.deselectRow(at: indexPath, animated: false)
            reserveButton.isEnabled = false
            reserveButton.backgroundColor = notBlack
            reserveButton.alpha = 0.4
            return nil
        }
        reserveButton.isEnabled = true
        reserveButton.backgroundColor = evqBlue
        reserveButton.alpha = 1
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reserveButton.isEnabled = true
        reserveButton.backgroundColor = evqBlue
        reserveButton.alpha = 1
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        reserveButton.isEnabled = false
        reserveButton.backgroundColor = notBlack
        reserveButton.alpha = 0.4
        return indexPath
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

