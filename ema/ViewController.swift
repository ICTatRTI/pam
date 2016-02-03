//
//  ViewController.swift
//  ema
//
//  Created by Adam Preston on 10/9/15.
//  Copyright © 2015 RTI. All rights reserved.
//


import UIKit
import ResearchKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController,  ORKTaskViewControllerDelegate {

    /**
     When a task is completed, the `ViewController` calls this closure
     with the created task.
     */
    var taskResultFinishedCompletionHandler: (ORKResult -> Void)?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        let task = ORKOrderedTask(identifier: "task", steps: [instructionStep, moodOptionListStep, moodOptionScaleStep, pamOptionStep, summaryStep])
        
        
        /*
        Passing `nil` for the `taskRunUUID` lets the task view controller
        generate an identifier for this run of the task.
        */
        let taskViewController = ORKTaskViewController(task: task, taskRunUUID: nil)
        taskViewController.delegate = self
        
        presentViewController(taskViewController, animated: true, completion: nil)
    }

    
    
    func taskViewController(taskViewController: ORKTaskViewController,
        didFinishWithReason reason: ORKTaskViewControllerFinishReason,
        error: NSError?) {
            
            debugPrint("pretty much done")
            
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
        instructionStep.title = "Welcome to RTI ResearchKit"
        instructionStep.text = "This survey can help us understand your eligibility for the mental fitness study"
        
        return instructionStep
        
    }
    /**
     This step demonstrates a survey question for picking from a list of text
     choices. In this case, the text choices are presented in a table view.  This is better than
     the valuePickerQuestionTask question task type when the respondent should see
     all of the options
     */
    
    private var moodOptionListStep : ORKQuestionStep {
        
        let textChoiceOneText = NSLocalizedString("Bad", comment: "Not good at all")
        let textChoiceTwoText = NSLocalizedString("Fine", comment: "Whatever")
        let textChoiceThreeText = NSLocalizedString("Fantastic", comment: "Really good, actually")
        
        // The text to display can be separate from the value coded for each choice:
        let textChoices = [
            ORKTextChoice(text: textChoiceOneText, value: "bad"),
            ORKTextChoice(text: textChoiceTwoText, value: "fine"),
            ORKTextChoice(text: textChoiceThreeText, value: "good")
        ]
        
        let answerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
        
        let questionStep = ORKQuestionStep(identifier: "mood category", title: "How is your day going today?", answer: answerFormat)
        
        return questionStep
        
    }
    
    /**
     This step demonstrates a survey question for assessing a Photographic Affect Meter (PAM)
     */
    
    private var pamOptionStep : ORKQuestionStep {
        
        let pamQuestionStepTitle = "What is your current mood ?"
        
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
        
        let pamQuestionStep = ORKQuestionStep(identifier: "mood image", title: pamQuestionStepTitle, answer: pamAnswerFormat)
        
        return pamQuestionStep
    }
    
    /**
     This step demonstrates a survey question using a likert scale
     */
    
    private var moodOptionScaleStep : ORKQuestionStep {
        
        
        // The third step is a vertical scale control with 10 discrete ticks.
        let step1AnswerFormat = ORKAnswerFormat.scaleAnswerFormatWithMaximumValue(10, minimumValue: 1, defaultValue: NSIntegerMax, step: 1, vertical: false, maximumValueDescription: nil, minimumValueDescription: nil)
        
        
        let questionStep = ORKQuestionStep(identifier: "mood scale", title: "What is your current stress level?", answer: step1AnswerFormat)
        
        questionStep.text = "Select a point on this scale where 10 is the most stress and 1 is no stress"
        
        return questionStep
    }


}

