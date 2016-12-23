//
//  Constants.swift
//  workaday
//
//  Created by Adam Preston on 7/26/16.
//  Copyright © 2016 RTI. All rights reserved.
//

struct Constants {
    static let WEEKDAY_SURVEY_TITLE : String = "Weekday Survey"
    static let WEEKDAY_SURVEY_SUBTITLE : String = "Answer 2 short questions"
    
    static let WEEKEND_SURVEY_TITLE : String = "Weekend Survey"
    static let WEEKEND_SURVEY_SUBTITLE : String = "Answer 2 short questions"
    
    static let UNSET_TAG : Int = 0
    static let UNSET_LABEL: String = ""
    
    // weekday question
    static let WORK_TRANSPORTATION_QUESTION_LABEL : String = "how did you get to work today"
    static let DROVE_OWN_CAR_TAG : Int = 1
    static let DROVE_OWN_CAR_LABEL : String = "drove own car"
    static let BIKED_TAG : Int = 2
    static let BIKED_LABEL : String = "biked"
    static let WALKED_RAN_TAG : Int = 3
    static let WALKED_RAN_LABEL : String = "walked/ran"
    static let CARPOOL_TAG : Int = 4
    static let CARPOOL_LABEL : String = "carpool"
    static let NO_COMMUTE_TAG : Int = 5
    static let NO_COMMUTE_LABEL : String = "did not commute"
    static let OTHER_COMMUTE_TAG : Int = 6
    static let OTHER_COMMUTE_LABEL : String = "other"
    
    //weekend question
    static let PHYSICAL_ACTIVITY_QUESTION_LABEL : String = "what describes your physical activity"
    static let VIGOROUSLY_ACTIVE_TAG : Int = 7
    static let VIGOROUSLY_ACTIVE_LABEL : String = "vigorously active for at least 30 min"
    static let MODERATELY_ACTIVE_TAG : Int = 8
    static let MODERATELY_ACTIVE_LABEL : String = "moderately active"
    static let NOT_ACTIVE_TAG : Int = 9
    static let NOT_ACTIVE_LABEL : String = "not very active"
    
    // PAM question
    static let PAM_QUESTION_LABEL = "how do you feel today"
    
    // 007aff
    static let enabledColor = hexStringToUIColor(hex: "007aff")
    static let disabledColor = hexStringToUIColor(hex: "#d3d3d3")
    
}


