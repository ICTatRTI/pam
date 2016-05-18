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
import CoreLocation

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    var locationFixAchieved : Bool = false
    var txtLatitude: Double = 0.0
    var txtLongitude: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Try to get users location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationFixAchieved = false
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

        let r : ResearchNet = ResearchNet(host: "researchnet.ictedge.org")
        r.printConfiguration()
        
        //let rn : ResearchNet = ResearchNet( host: "researchnet.ictedge.org")
        //rn.printConfiguration()
        
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
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            let coord = locationObj.coordinate
            
            txtLatitude = coord.latitude
            txtLongitude = coord.longitude
            
            // Put these in a session variable to be accessed by another viewcontroller (still have to understand this better)
            print("lat: ", txtLatitude)
            print("long: ", txtLongitude)
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
    @IBAction func unwindToForgotPassword(segue: UIStoryboardSegue) {
        toForgotPassword()
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
    
    func toForgotPassword() {
       performSegueWithIdentifier("toForgotPassword", sender: self)
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
