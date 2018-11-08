//
//  CustomCell.swift
//  Car Charge Checker
//
//  Created by Alush Benitez on 11/7/18.
//  Copyright © 2018 Michael Filippini. All rights reserved.
//

import UIKit
import Foundation

class CustomCell: UITableViewCell {
    
    var identifyingImage: UIImage?
    var name: String?
    var status: String?
    //var addButton: UIButton?
    
    var nameView: UITextView = {
        var textView = UITextView()
        textView.font = .systemFont(ofSize: 20.0, weight: UIFont.Weight(rawValue: 7))
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    var identifyingImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var statusView: UITextView = {
        var textView = UITextView()
        textView.font = .systemFont(ofSize: 10.0, weight: UIFont.Weight(rawValue: 3))
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(nameView)
        self.addSubview(identifyingImageView)
        self.addSubview(statusView)
        
        identifyingImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        identifyingImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        identifyingImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        identifyingImageView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        
        nameView.leftAnchor.constraint(equalTo: self.identifyingImageView.rightAnchor).isActive = true
        nameView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        nameView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        //Change when adding button
        nameView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        
        statusView.topAnchor.constraint(equalTo: self.nameView.topAnchor).isActive = true
        statusView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        statusView.leftAnchor.constraint(equalTo: self.identifyingImageView.rightAnchor).isActive = true
        //Change when adding button
        statusView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let name = name {
            nameView.text = name
        }
        if let identifyingImage = identifyingImage {
            identifyingImageView.image = identifyingImage
        }
        if let status = status {
            statusView.text = status
        }
    }
    
    
    

}
