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
        instructionStep.title = "Welcome to RTI's Work Study"
        instructionStep.text = "This survey can help us understand you at work"
        
        steps += [instructionStep]
        
        // First question
        let textChoiceOneText = NSLocalizedString("Drove own car", comment: "Drove own car")
        let textChoiceTwoText = NSLocalizedString("Biked", comment: "Biked")
        let textChoiceThreeText = NSLocalizedString("Walked/ran", comment: "Walked/ran")
        let textChoiceFourText = NSLocalizedString("Carpool/vanpool", comment: "Carpool/vanpool")
        let textChoiceFiveText = NSLocalizedString("Did not commute", comment: "Did not commute")
        
        // The text to display can be separate from the value coded for each choice:
        let textChoices = [
            ORKTextChoice(text: textChoiceOneText, value: "drove"),
            ORKTextChoice(text: textChoiceTwoText, value: "biked"),
            ORKTextChoice(text: textChoiceThreeText, value: "walked"),
            ORKTextChoice(text: textChoiceFourText, value: "carpooled"),
            ORKTextChoice(text: textChoiceFiveText, value: "none"),
            ]
        
        let answerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
        
        let questionStep = ORKQuestionStep(identifier: "How did you get to work", title: "How did you get to work today?", answer: answerFormat)
        
        steps += [questionStep]
        
        
        let textChoice2OneText = NSLocalizedString("Complete elated, rapturous joy and soaring ecstasy", comment: "")
        let textChoice2TwoText = NSLocalizedString("Very elated and in very high spirits. Tremendous delight and buoyancy", comment: "")
        let textChoice2ThreeText = NSLocalizedString("Elated and in high spirits", comment: "")
        let textChoice2FourText = NSLocalizedString("Feeling very good and cheerful", comment: "")
        let textChoice2FiveText = NSLocalizedString("Feeling pretty good, 'OK'", comment: "")
        let textChoice2SixText = NSLocalizedString("Feeling a little bit low. Just so-so", comment: "")
        let textChoice2SevenText = NSLocalizedString("Spirits low and somewhat 'blue'", comment: "")
        let textChoice2EightText = NSLocalizedString("Depressed and feeling very low. Definitely 'blue'", comment: "")
        let textChoice2NineText = NSLocalizedString("Tremendously depressed. Feeling terrible, really miserable, 'just awful'", comment: "")
        let textChoice2TenText = NSLocalizedString("Utter depression and gloom. Completely down.", comment: "")
        let textChoice2ElevenText = NSLocalizedString("All is black and leaden. Wish it were all over", comment: "")
        
        // The text to display can be separate from the value coded for each choice:
        let text2Choices = [
            ORKTextChoice(text: textChoice2OneText, value: "10"),
            ORKTextChoice(text: textChoice2TwoText, value: "9"),
            ORKTextChoice(text: textChoice2ThreeText, value: "8"),
            ORKTextChoice(text: textChoice2FourText, value: "7"),
            ORKTextChoice(text: textChoice2FiveText, value: "6"),
            ORKTextChoice(text: textChoice2SixText, value: "5"),
            ORKTextChoice(text: textChoice2SevenText, value: "4"),
            ORKTextChoice(text: textChoice2EightText, value: "3"),
            ORKTextChoice(text: textChoice2NineText, value: "2"),
            ORKTextChoice(text: textChoice2TenText, value: "1"),
            ORKTextChoice(text: textChoice2ElevenText, value: "0")
        ]
        
        let answer2Format = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: text2Choices)
        
        let question2Step = ORKQuestionStep(identifier: "how do you feel today", title: "How do you feel today?", answer: answer2Format)
        
        steps += [question2Step]
        
        // Return the task
        return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
    }()
    
    
    
    static let surveyWeekendTask: ORKOrderedTask = {
        var steps = [ORKStep]()
        
        
        // Instruction step
        let instructionStep = ORKInstructionStep(identifier: "intro")
        instructionStep.title = "Welcome to RTI's Work Study"
        instructionStep.text = "This survey can help us understand you on the weekend"
        
        steps += [instructionStep]
        
        
        let textChoiceOneText = NSLocalizedString("Vigorously active for at least 30 min", comment: "")
        let textChoiceTwoText = NSLocalizedString("Moderately active", comment: "")
        let textChoiceThreeText = NSLocalizedString("Not very active, sedentary activities preferred", comment: "")
        
        // The text to display can be separate from the value coded for each choice:
        let textChoices = [
            ORKTextChoice(text: textChoiceOneText, value: "active"),
            ORKTextChoice(text: textChoiceTwoText, value: "medium"),
            ORKTextChoice(text: textChoiceThreeText, value: "not")
        ]
        
        let answerFormat = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: textChoices)
        
        let questionStep = ORKQuestionStep(identifier: "activity level", title: "What best describes your activity level today?", answer: answerFormat)
        
        
        steps += [questionStep]
        
        
        let textChoice2OneText = NSLocalizedString("Complete elated, rapturous joy and soaring ecstasy", comment: "")
        let textChoice2TwoText = NSLocalizedString("Very elated and in very high spirits. Tremendous delight and buoyancy", comment: "")
        let textChoice2ThreeText = NSLocalizedString("Elated and in high spirits", comment: "")
        let textChoice2FourText = NSLocalizedString("Feeling very good and cheerful", comment: "")
        let textChoice2FiveText = NSLocalizedString("Feeling pretty good, 'OK'", comment: "")
        let textChoice2SixText = NSLocalizedString("Feeling a little bit low. Just so-so", comment: "")
        let textChoice2SevenText = NSLocalizedString("Spirits low and somewhat 'blue'", comment: "")
        let textChoice2EightText = NSLocalizedString("Depressed and feeling very low. Definitely 'blue'", comment: "")
        let textChoice2NineText = NSLocalizedString("Tremendously depressed. Feeling terrible, really miserable, 'just awful'", comment: "")
        let textChoice2TenText = NSLocalizedString("Utter depression and gloom. Completely down.", comment: "")
        let textChoice2ElevenText = NSLocalizedString("All is black and leaden. Wish it were all over", comment: "")
        
        
        // The text to display can be separate from the value coded for each choice:
        let text2Choices = [
            ORKTextChoice(text: textChoice2OneText, value: "10"),
            ORKTextChoice(text: textChoice2TwoText, value: "9"),
            ORKTextChoice(text: textChoice2ThreeText, value: "8"),
            ORKTextChoice(text: textChoice2FourText, value: "7"),
            ORKTextChoice(text: textChoice2FiveText, value: "6"),
            ORKTextChoice(text: textChoice2SixText, value: "5"),
            ORKTextChoice(text: textChoice2SevenText, value: "4"),
            ORKTextChoice(text: textChoice2EightText, value: "3"),
            ORKTextChoice(text: textChoice2NineText, value: "2"),
            ORKTextChoice(text: textChoice2TenText, value: "1"),
            ORKTextChoice(text: textChoice2ElevenText, value: "0")
        ]
        
        
        let answer2Format = ORKAnswerFormat.choiceAnswerFormatWithStyle(.SingleChoice, textChoices: text2Choices)
        
        let question2Step = ORKQuestionStep(identifier: "how do you feel this week", title: "How do you feel today?", answer: answer2Format)
        
        
        steps += [question2Step]
        
        
        
        // Return the task
        return ORKOrderedTask(identifier: "SurveyWeekendTask", steps: steps)
        
    }()
    
}
