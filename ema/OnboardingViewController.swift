//
//  OnboardingViewController.swift
//  workaday
//
//  Created by Adam Preston on 4/12/16.
//  Copyright © 2016 RTI. All rights reserved.
//

import UIKit
import ResearchKit
import ResearchNet

class OnboardingViewController: UIViewController {
    
    var researchNet : ResearchNet!
    
    // Constants
    let VISUAL_CONSSENT_STEP_IDENTIFIER : String = "VisualConsentStep"
    let CONSENT_REVIEW_IDENTIFIER : String = "ConsentReviewStep"
    let WAITING_STEP_IDENTIFIER : String = "waiting.step"
    let COMPLETION_STEP_IDENTIFIER :String = "CompletionStep"
    let REGISTRATION_STEP: String = "registration_step"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLogin" {
            if let destination = segue.destination as? LoginViewController {
                destination.researchNet = self.researchNet
            }
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toLogin", sender: self)
        
    }
    
    @IBAction func joinButtonTapped(_ sender: UIButton) {
        let consentDocument = ConsentDocument()
        let consentStep = ORKVisualConsentStep(identifier: VISUAL_CONSSENT_STEP_IDENTIFIER, document: consentDocument)
        
        
        let signature = consentDocument.signatures!.first!
        
        let reviewConsentStep = ORKConsentReviewStep(identifier: CONSENT_REVIEW_IDENTIFIER, signature: signature, in: consentDocument)
        
        reviewConsentStep.text = "Review the consent form."
        reviewConsentStep.reasonForConsent = "Consent to join our research Study."
        
        let registrationTitle = NSLocalizedString("Registration", comment: "")
        let passcodeValidationRegex = "^(?=.*\\d).{4,8}$"
        let passcodeInvalidMessage = NSLocalizedString("A valid password must be 4 and 8 digits long and include at least one numeric character.", comment: "")
        
        let registrationOptions: ORKRegistrationStepOption = [ .includeGender, .includeDOB]
        let registrationStep = ORKRegistrationStep(identifier: String(REGISTRATION_STEP), title: registrationTitle, text: "The following fields are required", passcodeValidationRegex: passcodeValidationRegex, passcodeInvalidMessage: passcodeInvalidMessage, options: registrationOptions)
        
        let waitTitle = NSLocalizedString("Creating account", comment: "")
        let waitText = NSLocalizedString("Please wait while we upload your data", comment: "")
        let waitStep = ORKWaitStep(identifier: String(WAITING_STEP_IDENTIFIER))
        waitStep.title = waitTitle
        waitStep.text = waitText
        
        
        let completionStep = ORKCompletionStep(identifier: COMPLETION_STEP_IDENTIFIER)
        completionStep.title = "Welcome aboard."
        completionStep.text = "Thank you for joining this study."
        
        let orderedTask = ORKOrderedTask(identifier: "Join", steps: [ consentStep,reviewConsentStep, registrationStep, waitStep,completionStep])
        
        let taskViewController = ORKTaskViewController(task: orderedTask, taskRun: nil)
        taskViewController.delegate = self
        
        present(taskViewController, animated: true, completion: nil)
    }
    
}



extension OnboardingViewController : ORKTaskViewControllerDelegate {
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        switch reason {
        case .completed:
            
            // put calls to back end here
            performSegue(withIdentifier: "unwindToStudy", sender: nil)
            
            
        case .discarded, .failed, .saved:
            dismiss(animated: true, completion: nil)
        }
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, stepViewControllerWillAppear stepViewController: ORKStepViewController) {
        
        
        if let stepViewController = stepViewController as? ORKWaitStepViewController {
            
            
            let taskViewControllerResult = taskViewController.result
            // let results = taskViewControllerResult.results as! [ORKStepResult]
            
            
            // Consent
            let consent_step = taskViewControllerResult.stepResult(forStepIdentifier: CONSENT_REVIEW_IDENTIFIER)
            let consent_stepResults = consent_step!.results as! [ORKConsentSignatureResult]
            let consent_signature = consent_stepResults.first!
            let first_name = consent_signature.signature?.givenName
            let last_name = consent_signature.signature?.familyName
            //var consented = consent_signature.consented
            
            
            // Registration
            let registration_step = taskViewControllerResult.stepResult(forStepIdentifier: REGISTRATION_STEP)
            
            let stepResults = registration_step!.results as! [ORKQuestionResult]
            let username = (stepResults[0] as? ORKTextQuestionResult)?.textAnswer
            let password = (stepResults[2] as? ORKTextQuestionResult)?.textAnswer
            let genderAnswer = (stepResults[3] as? ORKChoiceQuestionResult)?.choiceAnswers
            let gender = genderAnswer![0] as? String
            
            let dobAnswer = (stepResults[4] as? ORKDateQuestionResult)?.dateAnswer
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dob = dateFormatter.string( from: dobAnswer!)
            
            
            researchNet.enrollUser({ (responseObject, error) in
                
                if error != nil{
                    let errorMessage = (responseObject?.statusCode)! == 403 ? "Username is already taken. Please try using a different username." : "Something unexpected happened. Please contact your study administrator."
                    
                    let alert = UIAlertController(title: "Registration Error",
                                                  message: errorMessage, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: {
                        (alert: UIAlertAction!) in stepViewController.goBackward()
                    })
                    alert.addAction(action)
                    taskViewController.present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    // Get the token and take it and put it.
                    self.researchNet.authenticateUser({ (responseObject, error) in
                        
                        if error != nil {
                            let errorMessage = "Your account isn't set up yet."
                            
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
                        
                    }, username: username, password: password)
                }
                
                
            }, username: username, password: password, first_name: first_name, last_name: last_name, gender: gender, dob: dob)
            
        }
        
    }
    
    
    
    
}
