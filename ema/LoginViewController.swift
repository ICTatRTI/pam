//
//  LoginViewController.swift
//  workaday
//
//  Created by Adam Preston on 4/14/16.
//  Copyright © 2016 RTI. All rights reserved.
//

import UIKit
import ResearchKit
import ResearchNet


class LoginViewController: UIViewController {
    
    var researchNet : ResearchNet!
    let LOGIN_STEP_IDENTIFIER : String = "login step"
    let WAIT_STEP_IDENTIFIER : String = "wait step"
    let LOGIN_TASK_NAME : String = "login task"
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToStudy" {
            if let destination = segue.destination as? ActivityViewController {
                destination.researchNet = self.researchNet
            }
        }
    }
    
    
    /// This tasks presents the login step.
    fileprivate var loginTask: ORKTask {
        
        /*
         A login step view controller subclass is required in order to use the login step.
         The subclass provides the behavior for the login step forgot password button.
         */
        class LoginViewController : ORKLoginStepViewController {
            
            override func forgotPasswordButtonTapped() {
                
                let alertTitle = NSLocalizedString("Forgot password?", comment: "")
                let alertMessage = NSLocalizedString("Please enter the email address your used to create your account", comment: "")
                
                let passwordPrompt = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
                
                passwordPrompt.addTextField(configurationHandler: {(textField: UITextField!) in
                    textField.placeholder = "Email"
                })
                
                passwordPrompt.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.default, handler: { (action) -> Void in
                    let email = passwordPrompt.textFields![0] as UITextField
                    
                    print("resetting password for : ", email)
                    
                    
                    
                }))
                
                self.present(passwordPrompt, animated: true, completion: nil)
            }
            
        }
        
        /*
         A login step provides a form step that is populated with email and password fields,
         and a button for `Forgot password?`.
         */
        let loginTitle = NSLocalizedString("Login", comment: "")
        let loginStep = ORKLoginStep(identifier: String(LOGIN_STEP_IDENTIFIER), title: loginTitle, text: "", loginViewControllerClass: LoginViewController.self)
        
        /*
         A wait step allows you to validate the data from the user login against your server before proceeding.
         */
        let waitTitle = NSLocalizedString("Logging in", comment: "")
        let waitText = NSLocalizedString("Please wait while we validate your credentials", comment: "")
        let waitStep = ORKWaitStep(identifier: String(WAIT_STEP_IDENTIFIER))
        waitStep.title = waitTitle
        waitStep.text = waitText
        
        
        return ORKOrderedTask(identifier: String(LOGIN_TASK_NAME), steps: [loginStep, waitStep])
    }
    
    
    // MARK: Transitions
    
    func toStudy() {
        performSegue(withIdentifier: "unwindToStudy", sender: nil)
    }
    
}

extension LoginViewController : ORKTaskViewControllerDelegate {
    
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        switch reason {
            
        case .completed:
            
            self.toStudy()
            
        case .discarded, .failed, .saved:
            
            dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "unwindToOnboarding", sender: nil)
            
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let taskViewController = ORKTaskViewController(task: loginTask, taskRun: nil)
        taskViewController.delegate = self
        
        present(taskViewController, animated: true, completion: nil)
        
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, stepViewControllerWillAppear stepViewController: ORKStepViewController) {
        
        
        if let stepViewController = stepViewController as? ORKWaitStepViewController {
            
            
            let taskViewControllerResult = taskViewController.result
            //let results = taskViewControllerResult.results as! [ORKStepResult]
            
            // Login
            let login_step = taskViewControllerResult.stepResult(forStepIdentifier: LOGIN_STEP_IDENTIFIER)
            
            let stepResults = login_step!.results as! [ORKQuestionResult]
            let usernameResult = stepResults[0] as? ORKTextQuestionResult
            let passwordResult = stepResults[1] as? ORKTextQuestionResult
            
            // Call using a closure parameter
            researchNet.authenticateUser({ (responseObject, error) in
                
                if error != nil {
                    let errorMessage = "Your username and password didn't match. Try again."
                    
                    let alert = UIAlertController(title: "Login Error",
                                                  message: errorMessage, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: {
                        (alert: UIAlertAction!) in stepViewController.goBackward()
                    })
                    alert.addAction(action)
                    taskViewController.present(alert, animated: true, completion: nil)
                    
                } else{
                    
                    let defaults = UserDefaults.standard
                    defaults.set(responseObject!, forKey: "authKey")
                    
                    stepViewController.goForward()
                }
                
            }, username: usernameResult?.textAnswer, password: passwordResult?.textAnswer)
        }
        
    }
    
}
