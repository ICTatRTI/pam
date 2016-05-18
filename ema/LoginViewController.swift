//
//  LoginViewController2.swift
//  ema
//
//  Created by Adam Preston on 4/20/16.
//  Copyright © 2016 RTI. All rights reserved.
//

import UIKit
import ResearchKit
import ResearchNet

class LoginViewController: UIViewController {
    
    
    /// This tasks presents the login step.
    private var loginTask: ORKTask {
        /*
         A login step view controller subclass is required in order to use the login step.
         The subclass provides the behavior for the login step forgot password button.
         */
        class RKLoginViewController : ORKLoginStepViewController {
            override func forgotPasswordButtonTapped() {
                
                let alertTitle = NSLocalizedString("Forgot password?", comment: "")
                let alertMessage = NSLocalizedString("Please enter the email address your used to create your account", comment: "")

                let passwordPrompt = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
                
                passwordPrompt.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                    textField.placeholder = "Email"
                })
                
                passwordPrompt.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    let tf = passwordPrompt.textFields![0] as UITextField
                    
                }))

                self.presentViewController(passwordPrompt, animated: true, completion: nil)
            }
        }
        
        /*
         A login step provides a form step that is populated with email and password fields,
         and a button for `Forgot password?`.
         */
        let loginTitle = NSLocalizedString("Login", comment: "")
        let loginStep = ORKLoginStep(identifier: String("login step"), title: loginTitle, text: "", loginViewControllerClass: RKLoginViewController.self)
        
        /*
         A wait step allows you to validate the data from the user login against your server before proceeding.
         */
        let waitTitle = NSLocalizedString("Logging in", comment: "")
        let waitText = NSLocalizedString("Please wait while we validate your credentials", comment: "")
        let waitStep = ORKWaitStep(identifier: String("wait_login"))
        waitStep.title = waitTitle
        waitStep.text = waitText
        
        
        return ORKOrderedTask(identifier: String("login stask"), steps: [loginStep, waitStep])
    }
    
    // Used to wait an arbitrary length of time
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    // MARK: Transitions
    
    func toStudy() {
        performSegueWithIdentifier("unwindToStudy", sender: nil)
    }
    
}

extension LoginViewController : ORKTaskViewControllerDelegate {
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        switch reason {
        case .Completed:
            
            // put calls to backend here
            toStudy()
            
        case .Discarded, .Failed, .Saved:
            
            dismissViewControllerAnimated(true, completion: nil)
            print("dismissed")
            performSegueWithIdentifier("unwindToOnboarding", sender: nil)
            
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        let taskViewController = ORKTaskViewController(task: loginTask, taskRunUUID: nil)
        taskViewController.delegate = self
        
        presentViewController(taskViewController, animated: true, completion: nil)
        
    }
    
    func taskViewController(taskViewController: ORKTaskViewController, stepViewControllerWillAppear stepViewController: ORKStepViewController) {
        
        delay(5.0, closure: { () -> () in
            if let stepViewController = stepViewController as? ORKWaitStepViewController {
                stepViewController.goForward()
            }
        })
    }
    
}
