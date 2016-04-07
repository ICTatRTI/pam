//
//  RegisterViewController.swift
//  ema
//
//  Created by Adam Preston on 3/1/16.
//  Copyright © 2016 RTI. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var gender: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func enroll() {
        
        let parameters = [
            "username": username.text!,
            "password": password.text!,
            "email": email.text!,
            "first_name": firstname.text!,
            "last_name": lastname.text!,
            "gender": gender.text!,
            "dob": "1977-05-18"
            
        ]
        
        // Won't need to do this, figure out some way of caching the token
        Alamofire.request(.POST, "https://researchnet.ictedge.org/participant/", parameters: parameters).responseJSON { response in switch response.result {
            
        case .Success:
        
            if let httpError = response.result.error {
                let statusCode = httpError.code
                let alert = UIAlertController(title: "Error", message: "An error \(statusCode) occured. Please contact your study administrator.", preferredStyle: .Alert)
                let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else { //no (really bad) errors
                let statusCode = (response.response?.statusCode)!
                if statusCode >= 400 {
               
                    let alert = UIAlertController(title: "Error", message: "All fields are required", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)

                } else{
                    print("back to the login screen... ", statusCode)
                    let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("login") as! LoginViewController
                    
                    self.presentViewController(loginViewController, animated: false, completion: nil)
                }
                
            }
            

        case .Failure:
            
            let alert = UIAlertController(title: "Error", message: "Something is all messed up on the server. Please contact your study administrator.", preferredStyle: .Alert)
            
            let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
            
            self.presentViewController(alert, animated: true, completion: nil)
         
            }
            
            
        }
        
        
        
    }
    

    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
