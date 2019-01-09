//
//  Color.swift
//  Car Charge Checker
//
//  Created by Michael Filippini on 11/5/18.
//  Copyright © 2018 Michael Filippini. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}

let evqBlue = UIColor(red: 0, green: 190, blue: 255)
let evqTeal = UIColor(red: 0, green: 255, blue: 255)
let anotherBlue = UIColor(red: 0, green: 190, blue: 255)
let notBlack = UIColor(red: 50, green: 50, blue: 50)
let toothpaste = UIColor(red: 99, green: 255, blue: 148)
let softRed = UIColor(red: 255, green: 107, blue: 122)
let itsSpelledGrey = UIColor(red: 224, green: 224, blue: 224)

