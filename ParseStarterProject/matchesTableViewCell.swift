//
//  matchesTableViewCell.swift
//  ParseStarterProject-Swift
//
//  Created by Adhita Selvaraj on 10/12/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class matchesTableViewCell: UITableViewCell {

    @IBOutlet var userImageView: UIImageView!
    
    @IBOutlet var userIdLabel: UILabel!
    
    @IBOutlet var matchedUserLabel: UILabel!
    
    @IBOutlet var messageTextField: UITextField!
    
    
    @IBAction func send(_ sender: Any) {
        
        print(userIdLabel.text)
        print(messageTextField.text)
        
        
        
        let message = PFObject(className: "Message")
        
        message["sender"] = PFUser.current()?.objectId!
        
        message["recipient"] = userIdLabel.text
        
        message["content"] = messageTextField.text
        
        message.saveInBackground()
        
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
