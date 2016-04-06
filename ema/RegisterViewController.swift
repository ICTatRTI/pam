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
            "first_name": firstname.text!,
            "last_name": lastname.text!,
            "gender": gender.text!,
            "dob": "05-18-1977"
            
        ]
        
        // Won't need to do this, figure out some way of caching the token
        Alamofire.request(.POST, "https://researchnet.ictedge.org/participant/", parameters: parameters).responseJSON { response in switch response.result {
            
        case .Success(let data):
            
            let json = JSON(data)
            // go back to the login screen
            
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
