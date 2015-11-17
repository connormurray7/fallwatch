//
//  ContactBirthdayCell.swift
//  Birthdays
//
//  Created by Gabriel Theodoropoulos on 27/9/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var lblFullname: UILabel!
    
    @IBOutlet weak var lblPhoneNumber: UILabel!
    
    @IBOutlet weak var imgContactImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
