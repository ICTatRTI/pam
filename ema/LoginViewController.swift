//
//  LoginViewController.swift
//  ema
//
//  Created by Adam Preston on 3/1/16.
//  Copyright © 2016 RTI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func login() {
    
        let parameters = [
            "username": username.text!,
            "password": password.text!
        ]
        
        // Won't need to do this, figure out some way of caching the token
        Alamofire.request(.POST, "https://researchnet.ictedge.org/api-token-auth/", parameters: parameters).responseJSON { response in switch response.result {
            
            case .Success(let data):

                let json = JSON(data)
                let token = json["token"].stringValue
                
                if token == "" {
                    
                    let alert = UIAlertController(title: "Login", message: "Unable to log in with provided credentials", preferredStyle: .Alert)
                    
                    let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                    alert.addAction(action)
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    print("Logged in")
                    
                }
            
            case .Failure(let error):
                
                let alert = UIAlertController(title: "Login", message: "\(error)", preferredStyle: .Alert)
                
                let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alert.addAction(action)
                
                self.presentViewController(alert, animated: true, completion: nil)
                print("Request failed with error: \(error)")
            }
        

        }
        
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


}
