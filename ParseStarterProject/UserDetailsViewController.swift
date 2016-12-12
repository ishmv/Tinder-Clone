//
//  UserDetailsViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Adhita Selvaraj on 03/12/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class UserDetailsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var errorinUpdateLabel: UILabel!
    @IBOutlet var profilePic: UIImageView!
    
    @IBOutlet var genderSwitch: UISwitch!
    
    @IBOutlet var interestSwitch: UISwitch!
    
    
    @IBAction func changeProfilePic(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profilePic.image = image
        }
        
        else {
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
   
    
    @IBAction func updateUserDetails(_ sender: Any) {
        
        PFUser.current()?["isFemale"] = genderSwitch.isOn
        PFUser.current()?["isInterestedInWomen"] = interestSwitch.isOn
        
        let imageData = UIImagePNGRepresentation(profilePic.image!) as Data?
        
        PFUser.current()?["DP"] = PFFile(name: "dp.png", data: imageData!)
        
        let  acl = PFACL()
        
        acl.getPublicWriteAccess = true
        
        acl.getPublicReadAccess = true
        
        PFUser.current()?.acl = acl
        
        PFUser.current()?.saveInBackground(block: { (success, error) in
            
            if error != nil {
                
                var errorMsg = "Update failed. Please try again."
                
                if let parseError = (error! as NSError).userInfo["error"] as? String {
                    
                    errorMsg = parseError
                    
                }
                
                else {
                   
                    print("Updated")
                    
                }
                
                self.errorinUpdateLabel.text = errorMsg
                
            }
            
            
        })
        
        self.performSegue(withIdentifier: "showSwipeViewController", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let isFemale = PFUser.current()?["isFemale"] as? Bool {
            genderSwitch.setOn(isFemale, animated: true)
        }
        
        if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"] as? Bool {
            interestSwitch.setOn(isInterestedInWomen, animated: true)
        }
        
        if let photo = PFUser.current()?["DP"] as? PFFile {
            photo.getDataInBackground(block: { (data, error) in
                
                if let imageData = data {
                    
                    if let downloadedImage = UIImage(data: imageData) {
                        self.profilePic.image = downloadedImage
                    }
                    
                }
                
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
