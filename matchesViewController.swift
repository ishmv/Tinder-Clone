//
//  matchesViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Adhita Selvaraj on 10/12/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class matchesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var images = [UIImage]()
    
    var userIds = [String]()
    
    var messages = [String]()
    
    @IBOutlet var tableView: UITableView!
    
   
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        
        // Do any additional setup after loading the view.
        
        let query = PFUser.query()
        
        query?.whereKey("Accepted", contains: PFUser.current()?.objectId)
        
        query?.whereKey("objectId", containedIn: PFUser.current()?["Accepted"] as! [String])
        
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if let users = objects {
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        let imageFile = user["DP"] as! PFFile
                        
                        imageFile.getDataInBackground(block: { (data, error) in
                            
                            if let imageData = data {
                                
                                let messageQuery = PFQuery(className: "Message")
                                
                                messageQuery.whereKey("recipient", equalTo: PFUser.current()?.objectId!)
                                
                                messageQuery.findObjectsInBackground(block: { (objects, error) in
                                    
                                    var messageText = "No message from this user"
                                    
                                    if let object = objects {
                                        
                                        for message in objects! {
                                                
                                                if let messageContent = message["content"] as? String {
                                                    
                                                    messageText = messageContent
                                                    
                                                }
                                        }
                                    }
                                    
                                    self.messages.append(messageText)
                                    
                                    self.images.append(UIImage(data: imageData)!)
                                    
                                    self.userIds.append(user.objectId!)
                                    
                                    self.tableView.reloadData()
                                    
                                    
                                    
                                })
                                
                                
                                
                            }
                            
                        })
                    }
                }
                
            }
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return images.count
    }

    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! matchesTableViewCell
        
        cell.userImageView.image = images[indexPath.row]
        
        cell.matchedUserLabel.text = "You haven't received a message yet"
        
        cell.userIdLabel.text = userIds[indexPath.row]
        
        cell.matchedUserLabel.text = messages[indexPath.row]
        
        return cell
        
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
