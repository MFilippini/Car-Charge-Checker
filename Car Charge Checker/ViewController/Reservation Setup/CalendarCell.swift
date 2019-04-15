//
//  CalendarCell.swift
//  Car Charge Checker
//
//  Created by Alush Benitez on 1/22/19.
//  Copyright © 2019 Michael Filippini. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    var selectedAnUnselectable: Bool = false
    
    @IBOutlet weak var numberLabel: UILabel!
    var isSelectable: Bool = false
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                if self.isSelectable {
                    self.backgroundColor = evqBlue
                    if self.numberLabel.textColor == evqBlue {
                        self.numberLabel.textColor = notBlack
                    }
                    ReservationViewController().dateSelected(date: Int(self.numberLabel.text!)!)
                } else {
                    ReservationViewController().dateSelected(date: -1)
                }
                //This block will be executed whenever the cell’s selection state is set to true (i.e For the selected cell)
            } else {
                self.backgroundColor = nil
                if self.numberLabel.textColor == notBlack {
                    self.numberLabel.textColor = evqBlue
                }
                
                //This block will be executed whenever the cell’s selection state is set to false (i.e For the rest of the cells)
            }
        }
    }
    
}
