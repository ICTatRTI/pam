//
//  StudyTasks.swift
//  ema
//
//  Created by Adam Preston on 4/20/16.
//  Copyright © 2016 RTI. All rights reserved.
//

import ResearchKit



struct StudyTasks {
    
    static let surveyTask: ORKOrderedTask = {
        var steps = [ORKStep]()
        
        
        /*
         ╔═╗┌┬┐┌─┐┌─┐┌─┐
         ╚═╗ │ ├┤ ├─┘└─┐
         ╚═╝ ┴ └─┘┴  └─┘
         
         */
        
        
        // Instruction step
        let instructionStep = ORKInstructionStep(identifier: "intro")
        instructionStep.title = "Welcome to RTI's Photographic Affect Meter"
        instructionStep.text = "This is a novel tool for frequent, unobtrusive measurement of affect."
        
        steps += [instructionStep]
        
        // First question
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
        
        steps += [pamQuestionStep]
        
        
        let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
        summaryStep.title = "Right. Off you go!"
        summaryStep.text = "That was easy!"
        
 
        
        steps += [summaryStep]
        
        // Return the task
        return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
    }()
    
    static let tappingTask: ORKOrderedTask = {
        let intendedUseDescription = "Finger tapping is a universal way to communicate."
        
        return ORKOrderedTask.twoFingerTappingIntervalTaskWithIdentifier("TappingTask", intendedUseDescription: intendedUseDescription, duration: 10, options: ORKPredefinedTaskOption.None)
    }()

    
}
