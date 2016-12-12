//
//  facebookLooginViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Adhita Selvaraj on 11/12/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import FBSDKLoginKit

var info = [String]()

class facebookLooginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet var userInfoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        if FBSDKAccessToken.current() != nil {
            
            print("User Logged In")
        } else {
            
            let loginButton = FBSDKLoginButton()
            
            loginButton.center = self.view.center
            
            loginButton.readPermissions = ["public_profile", "email"]
            
            loginButton.delegate = self
            
            self.view.addSubview(loginButton)
            
            
            
        }

        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print(error)
        }
        else if result.isCancelled {
            print("User Cancelled Login")
        }
        else {
            if result.grantedPermissions.contains("email") {
                
                if let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"]) {
                    
                    graphRequest.start(completionHandler: { (connection, result, error) in
                        if error != nil {
                            print(error)
                        }
                        else {
                            if let userDetails = result as? [String: String]{
                                
                                info.append(userDetails["name"]!)
                                
                                print(info[info.count - 1])
                                
                            }
                        }
                    })
                }
                
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged In")
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
