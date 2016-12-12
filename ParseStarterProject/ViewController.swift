/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse
import FBSDKLoginKit

class ViewController: UIViewController {

    var newUser = false
    var buttonPressToggle = false
    @IBOutlet var userIDTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var newUserButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    
    @IBOutlet var logInButton: UIButton!
    
    
    
    
    @IBAction func logInClick(_ sender: Any) {
    
        if (newUser == true) {
            let user = PFUser()
            user.username = userIDTextField.text
            user.password = passwordTextField.text
            
            let acl = PFACL()
            
            acl.getPublicWriteAccess = true
            acl.getPublicReadAccess = true
            
            user.acl = acl
            
            user.signUpInBackground(block: { (success, error) in
                
                if error != nil {
                    var errorMessage = "Sign Up failed, Please try again"
                    if let parseError = (error! as NSError).userInfo["error"] as? String {
                        
                        errorMessage = parseError
                    }
                    
                    self.errorLabel.text = errorMessage
                }
                    
                else {
                    print("Signed Up")
                    self.buttonPressToggle = false
                    self.performSegue(withIdentifier: "goToUserInfo", sender: self)
                    
                }
            })
    
        
    }
        else {
            
            PFUser.logInWithUsername(inBackground: userIDTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                
                if error != nil {
                    var errorMessage = "Sign Up failed, Please try again"
                       if let parseError = (error! as NSError).userInfo["error"] as? String {
                        
                        errorMessage = parseError
                        
                        
                        print(errorMessage)
                    }
                    
                    self.errorLabel.text = errorMessage
                }
                else {
                    print("Logged In")
                    self.buttonPressToggle = true
                    self.redirect()
                }
                
            })
            
            
        }
    
    }
    
    @IBAction func newUserAction(_ sender: Any) {
        
        buttonPressToggle = true
        
        if buttonPressToggle == true {
            newUser = true
            userIDTextField.placeholder = "New Username"
            passwordTextField.placeholder = "New Password"
            logInButton.setTitle("Sign Up", for: [])
        }
        
        else {
            
            newUser = false
            userIDTextField.placeholder = "Username"
            passwordTextField.placeholder = "Password"
            logInButton.setTitle("Log In", for: [])
        }
        
        
        
        
    }
    
    
    
    func dismissKeyboard() {
              view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
   
        if info.count >= 1 {
            
            userIDTextField.text = info[info.count - 1]
        }
        
        
        redirect()
        
        
        let urlArray = ["https://myanimelist.cdn-dena.com/s/common/uploaded_files/1442575044-64c94415ed8b2cb36ec6d6670b64172d.jpeg", "http://1pieceking.weebly.com/uploads/1/6/1/5/16150952/5257130.png?200", "https://lh3.googleusercontent.com/-12VnjG3Xyik/VfOORSF7haI/AAAAAAAADQo/KszlmWE-E88/w800-h800/Nami-One-Piece-55.png", "https://bakphoontyphoon.files.wordpress.com/2016/07/misty.jpg?w=500&h=342", "http://i.kinja-img.com/gawker-media/image/upload/t_original/a7k7bd3488lhybk3puyh.jpg", "http://img3.rnkr-static.com/user_node_img/98/1956789/870/saber-fictional-characters-photo-u1.jpg", "http://img2.rnkr-static.com/user_node_img/3680/73586219/870/lucy-heartfilia-u26.jpg", "http://static.tumblr.com/eef4bdde4536fc559719678f4cfef447/exa1byc/4EDmkte6c/tumblr_static_inuyasha_kagome_higurashi_wallpaper_hd-normal.jpg"]
        
        var counter = 0
        
        for urlString in urlArray {
            
            counter += 1
            
            let url = URL(string: urlString)!
            
            do {
            
            let data = try Data(contentsOf: url)
            
                let imageFile = PFFile(name: "photo.png", data: data)
                
                let user = PFUser()
                
                user["DP"] = imageFile
                
                user.username = String(counter)
                
                user.password = "LFC"
                
                user["isInterestedInWomen"] = false

                user["isFemale"] = true
                
                let  acl = PFACL()
                
                acl.getPublicWriteAccess = true
                
                acl.getPublicReadAccess = true
                
                user.acl = acl
                
                user.signUpInBackground(block: { (success, error) in
                    
                    if success {
                      
                        print("user signed up")
                        
                    }
                    
                })
                
            }
            
            catch {
                print("Could not get data")
            }
            
            
            
        } 
        
        
    }
    
    func redirect() {
        
        
        if PFUser.current() != nil {
            
            if PFUser.current()?["isFemale"] != nil && PFUser.current()?["isInterestedInWomen"] != nil && PFUser.current()?["DP"] != nil {
                
                
                performSegue(withIdentifier: "swipeFromInitialSegue", sender: self)
                
            }
                
            else {
                
                performSegue(withIdentifier: "goToUserInfo", sender: self)
            }
            
            
        }
        

        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //tap to close keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
