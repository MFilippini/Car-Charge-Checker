//
//  ViewController.swift
//  Car Charge Checker
//
//  Created by Michael Filippini on 10/22/18.
//  Copyright © 2018 Michael Filippini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var reservationDescription: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 100
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
        //Return total number of chargers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .red
        cell.layoutSubviews()
        return cell
    }

    @IBAction func PlusPressed(_ sender: Any) {
    }
    
    
    
}

