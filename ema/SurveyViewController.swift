//
//  ViewController.swift
//  ema
//
//  Created by Adam Preston on 10/9/15.
//  Copyright © 2015 RTI. All rights reserved.
//


import UIKit
import ResearchKit
import ResearchNet
import CoreLocation



class SurveyViewController: UIViewController,  ORKTaskViewControllerDelegate, CLLocationManagerDelegate {
    /**
     When a task is completed, the `ViewController` calls this closure
     with the created task.
     */
    var taskResultFinishedCompletionHandler: (ORKResult -> Void)?
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
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        
        let task = ORKOrderedTask(identifier: "task", steps: [instructionStep, pamOptionStep, summaryStep])
        
        let taskViewController = ORKTaskViewController(task: task, taskRunUUID: nil)
        taskViewController.delegate = self
        
        presentViewController(taskViewController, animated: true, completion: nil)
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            let coord = locationObj.coordinate
            
            txtLatitude = coord.latitude
            txtLongitude = coord.longitude
        }
        
    }
    
    
    func taskViewController(taskViewController: ORKTaskViewController,
                            didFinishWithReason reason: ORKTaskViewControllerFinishReason,
                                                error: NSError?) {
        
        
      
        
        /*
         The `reason` passed to this method indicates why the task view
         controller finished: Did the user cancel, save, or actually complete
         the task; or was there an error?
         
         */
        
        taskResultFinishedCompletionHandler?(taskViewController.result)
        
        
        // Then, dismiss the task view controller.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func taskResultFinishedCompletionHandler(_: ORKResult -> Void) {
        print("I am done")
    }
    
    
    
    
    private var summaryStep :ORKCompletionStep {
        
        let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
        summaryStep.title = "Right. Off you go!"
        summaryStep.text = "That was easy!"
        
        return summaryStep
    }
    
    /**
     
     As you can see here, I left plent of room for refactoring.  Obviously, these steps should reside
     outside of the ViewController
     */
    
    private var instructionStep : ORKInstructionStep {
        
        let instructionStep = ORKInstructionStep(identifier: "intro")
        instructionStep.title = "Welcome to RTI's Photographic Affect Meter"
        instructionStep.text = "This is a novel tool for frequent, unobtrusive measurement of affect."
        
        return instructionStep
        
    }
    
    
    /**
     This step demonstrates a survey question for assessing a Photographic Affect Meter (PAM)
     */
    
    private var pamOptionStep : ORKQuestionStep {
        
        let pamQuestionStepTitle = "Touch the photo that best captures how you feel right now."
        
        //TODO come up with some intelligent way of randomizing these
        let pamTuples = [
            (UIImage(named: "1_1")!, "1"),
            (UIImage(named: "1_2")!, "2"),
            (UIImage(named: "1_3")!, "3"),
            (UIImage(named: "2_1")!, "4"),
            (UIImage(named: "2_2")!, "5"),
            (UIImage(named: "2_3")!, "6")
        ]
        
        let imageChoices : [ORKImageChoice] = pamTuples.map {
            return ORKImageChoice(normalImage: $0.0, selectedImage: nil, text: $0.1, value: $0.1)
        }
        
        let pamAnswerFormat: ORKImageChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormatWithImageChoices(imageChoices)
        
        pamAnswerFormat.questionType
        
        let pamQuestionStep = ORKQuestionStep(identifier: "mood image", title: pamQuestionStepTitle, answer: pamAnswerFormat)
        
        return pamQuestionStep
    }
    
    
    
    
}

