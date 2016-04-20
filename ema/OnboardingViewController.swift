//
//  OnboardingViewController.swift
//  ema
//
//  Created by Adam Preston on 4/20/16.
//  Copyright © 2016 RTI. All rights reserved.
//

import UIKit
import ResearchKit

class OnboardingViewController: UIViewController {
    // MARK: IB actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        performSegueWithIdentifier("toLogin", sender: self)
        
    }
    
    @IBAction func joinButtonTapped(sender: UIButton) {
        let consentDocument = ConsentDocument()
        let consentStep = ORKVisualConsentStep(identifier: "VisualConsentStep", document: consentDocument)
        
        
        let signature = consentDocument.signatures!.first!
        
        let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, inDocument: consentDocument)
        
        reviewConsentStep.text = "Review the consent form."
        reviewConsentStep.reasonForConsent = "Consent to join the Developer Health Research Study."
        
        let registrationTitle = NSLocalizedString("Registration", comment: "")
        let passcodeValidationRegex = "^(?=.*\\d).{4,8}$"
        let passcodeInvalidMessage = NSLocalizedString("A valid password must be 4 and 8 digits long and include at least one numeric character.", comment: "")
        let registrationOptions: ORKRegistrationStepOption = [ .IncludeGender, .IncludeDOB]
        let registrationStep = ORKRegistrationStep(identifier: String("registration_step"), title: registrationTitle, text: "Additional text can go here", passcodeValidationRegex: passcodeValidationRegex, passcodeInvalidMessage: passcodeInvalidMessage, options: registrationOptions)
        
        let waitTitle = NSLocalizedString("Creating account", comment: "")
        let waitText = NSLocalizedString("Please wait while we upload your data", comment: "")
        let waitStep = ORKWaitStep(identifier: String("waiting.step"))
        waitStep.title = waitTitle
        waitStep.text = waitText
        
        
        let completionStep = ORKCompletionStep(identifier: "CompletionStep")
        completionStep.title = "Welcome aboard."
        completionStep.text = "Thank you for joining this study."
        
        let orderedTask = ORKOrderedTask(identifier: "Join", steps: [consentStep, reviewConsentStep, registrationStep, waitStep,completionStep])
        
        let taskViewController = ORKTaskViewController(task: orderedTask, taskRunUUID: nil)
        taskViewController.delegate = self
        
        presentViewController(taskViewController, animated: true, completion: nil)
    }
    
}



extension OnboardingViewController : ORKTaskViewControllerDelegate {
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        switch reason {
        case .Completed:
            
            // put calls to back end here
            performSegueWithIdentifier("unwindToStudy", sender: nil)
            
        case .Discarded, .Failed, .Saved:
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func taskViewController(taskViewController: ORKTaskViewController, stepViewControllerWillAppear stepViewController: ORKStepViewController) {
        
        delay(5.0, closure: { () -> () in
            if let stepViewController = stepViewController as? ORKWaitStepViewController {
                stepViewController.goForward()
            }
        })
    }
    
    
    // Used to wait an arbitrary length of time. won't need this with a real call to the server
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
}
