//
//  swipeViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Adhita Selvaraj on 03/12/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class swipeViewController: UIViewController {

    
    @IBOutlet var swipeImage: UIImageView!
    
    var getUserID = ""
    
    func wasDragged (gestureRecognizer: UIPanGestureRecognizer) {
        
        
        var acceptedorrejected = ""
        let translation = gestureRecognizer.translation(in: view)
        let label  = gestureRecognizer.view!
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y)
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        let scale = min(abs(100 / xFromCenter), 1)
        var stretchAndRotation = rotation.scaledBy(x: scale, y: scale)
        
        label.transform = stretchAndRotation
        
        if gestureRecognizer.state == UIGestureRecognizerState.ended {
            if label.center.x < 100 {
                acceptedorrejected = "Rejected"
            }
            else if label.center.x > self.view.bounds.width - 100 {
                
                acceptedorrejected = "Accepted"
                }
            
            print(acceptedorrejected)
            
            if acceptedorrejected != "" && getUserID != "" {
                
                PFUser.current()?.addUniqueObjects(from: [getUserID], forKey: acceptedorrejected)
                
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    
                    print("Duh!")
                    self.updateImage()
                    
                    
                })
                
                
            }
            
 
 
            rotation = CGAffineTransform(rotationAngle: 0)
            stretchAndRotation = rotation.scaledBy(x: 1, y: 1)
            label.transform = stretchAndRotation
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            
            
        }

    }
    
    func updateImage() {
        
        let query = PFUser.query()
        
        query?.whereKey("isFemale", equalTo: (PFUser.current()?["isInterestedInWomen"])!)
        
        query?.whereKey("isInterestedInWomen", equalTo: (PFUser.current()?["isFemale"])!)
        
        var ignoredUsers = [""]
        
        if let acceptedUsers = PFUser.current()?["Accepted"] {
            
            ignoredUsers += acceptedUsers as! Array
        }
        
        if let rejectedUsers = PFUser.current()?["Rejected"] {
            
            ignoredUsers += rejectedUsers as! Array
        }
        
        query?.whereKey("objectId", notContainedIn: ignoredUsers)
        
        if let latitude = (PFUser.current()?["location"] as AnyObject).latitude {
            
            if let longitude = (PFUser.current()?["location"] as AnyObject).longitude {
                
                query?.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: latitude - 1, longitude: longitude - 1), toNortheast: PFGeoPoint(latitude: latitude + 1, longitude: longitude + 1))
                
                
            }
        }
        
        query?.limit = 1
        
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if let users = objects {
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        print(user)
                        
                        self.getUserID = user.objectId!
                        
                        print(self.getUserID)
                        
                        let imageFile = user["DP"] as! PFFile
                        
                        imageFile.getDataInBackground(block: { (data, error) in
                        
                            if let imageData = data {
                                
                                self.swipeImage.image = UIImage(data: imageData)
                                
                            }
                            
                            
                        })
                        
                    }
                    
                }
                
            }
            
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        swipeImage.isUserInteractionEnabled = true
        swipeImage.addGestureRecognizer(gesture)
        
        PFGeoPoint.geoPointForCurrentLocation { (geopoint, error) in
        
            if let geopoint = geopoint {
                
                PFUser.current()?["location"] = geopoint
                
                PFUser.current()?.saveInBackground()
                
            }
        
        
        }
        
        
        updateImage()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "logoutSegue" {
            
            PFUser.logOut()
            
        }
        
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
