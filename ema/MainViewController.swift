//
//  MainViewController.swift
//  ema
//
//  Created by Adam Preston on 4/20/16.
//  Copyright © 2016 RTI. All rights reserved.
//

import UIKit
import ResearchKit
import ResearchNet

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // automatically log 'em in if they have a passcode
        if ORKPasscodeViewController.isPasscodeStoredInKeychain() {
            print("on to the study")
            toStudy()
        }
        else {
            print("on to onboarding")
            toOnboarding()
        }
    }
    
    // MARK: Unwind segues
    
    @IBAction func unwindToStudy(segue: UIStoryboardSegue) {
        toStudy()
    }
    
    @IBAction func unwindToWithdrawl(segue: UIStoryboardSegue) {
        toWithdrawl()
    }
    
    @IBAction func unwindToOnboarding(segue: UIStoryboardSegue) {
        toOnboarding()
    }
    
    // MARK: Transitions
    
    func toOnboarding() {
        performSegueWithIdentifier("toOnboarding", sender: self)
    }
    
    func toStudy() {
        performSegueWithIdentifier("toStudy", sender: self)
    }
    
    
    
    func toWithdrawl() {
        let viewController = WithdrawViewController()
        viewController.delegate = self
        
        presentViewController(viewController, animated: true, completion: nil)
    }
    
}


extension MainViewController: ORKTaskViewControllerDelegate {
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        // Check if the user has finished the `WithdrawViewController`.
        if taskViewController is WithdrawViewController {
            /*
             If the user has completed the withdrawl steps, remove them from
             the study and transition to the onboarding view.
             */
            if reason == .Completed {
                ORKPasscodeViewController.removePasscodeFromKeychain()
                toOnboarding()
            }
            
            // Dismiss the `WithdrawViewController`.
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
