//
//  ActivityViewController.swift
//  workaday
//
//  Created by Adam Preston on 4/13/16.
//  Copyright © 2016 RTI. All rights reserved.
//


import UIKit
import ResearchKit
import ResearchNet
import CoreLocation

enum Activity: Int {
    case weekdaySurvey, weekendSurvey
    
    static var allValues: [Activity] {
        var idx = 0
        return Array(
            AnyIterator{
                idx = idx + 1
                return self.init(rawValue: idx)})
    }
    
    var title: String {
        switch self {
        case .weekdaySurvey:
            return Constants.WEEKDAY_SURVEY_TITLE
        case .weekendSurvey:
            return Constants.WEEKEND_SURVEY_TITLE
        }
    }
    
    var subtitle: String {
        switch self {
        case .weekdaySurvey:
            return Constants.WEEKDAY_SURVEY_SUBTITLE
        case .weekendSurvey:
            return Constants.WEEKEND_SURVEY_SUBTITLE
        }
    }
}



class ActivityViewController: UITableViewController, CLLocationManagerDelegate {
    
    
    var researchNet : ResearchNet!
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
        
        self.tableView.reloadData()
        
    }
    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.day], from: startDate, to: endDate)
        return components.day!
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            let coord = locationObj.coordinate
            
            txtLatitude = coord.latitude
            txtLongitude = coord.longitude
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else { return 0 }
        
        return Activity.allValues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
        
        let defaults = UserDefaults.standard
        let weekday_ts = defaults.object(forKey: "weekday_timestamp") as! Date
        let weekend_ts = defaults.object(forKey: "weekend_timestamp") as! Date
        
        
        let currentDateTime = Date()
        let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let myComponents = (myCalendar as NSCalendar).components(.weekday, from: currentDateTime)
        let weekDay = myComponents.weekday
        
        
        if let activity = Activity(rawValue: indexPath.row) {
            
            //put checkbox logic here
            cell.textLabel?.text = activity.title
            cell.detailTextLabel?.text = activity.subtitle
            
            // restrict user from taking the survey more than once a day for weekday
            // survey or once a week for weekend survey
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            /*
             Enable weekday survey on M-F only if the survey hasnt' been completed within
             the past 24 hours
             */
            if (activity.title == Constants.WEEKDAY_SURVEY_TITLE ){
                
                if ( weekDay == 1 || weekDay == 7) {
                    cell.accessoryType =  .checkmark
                    cell.selectionStyle = .none
                    cell.isUserInteractionEnabled = false
                } else {
                    
                    
                    if (  daysBetweenDates(startDate: weekday_ts, endDate: currentDateTime) < 1 ){
                        cell.accessoryType =  .checkmark
                        cell.selectionStyle = .none
                        cell.isUserInteractionEnabled = false
                    }
                }
                
                
            }
                /*
                 Enable weekend survey on Sat/Sun only if the survey hasn't been completed within
                 the past 24 hours
                 */
            else if ( activity.title == Constants.WEEKEND_SURVEY_TITLE ){
                
                if (weekDay == 2 || weekDay == 3 || weekDay == 4 || weekDay == 5 || weekDay == 6) {
                    
                    cell.accessoryType =  .checkmark
                    cell.selectionStyle = .none
                    cell.isUserInteractionEnabled = false
                    
                } else  {
                    
                    if (daysBetweenDates(startDate: weekend_ts, endDate: currentDateTime) < 1 ){
                        cell.accessoryType =  .checkmark
                        cell.selectionStyle = .none
                        cell.isUserInteractionEnabled = false
                        
                    }
                    
                }
                
            }
            
        }
        
        return cell
    }
    
    
    
    
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let activity = Activity(rawValue: indexPath.row) else { return }
        
        
        switch activity {
        case .weekdaySurvey:
            
            let workdayViewController = self.storyboard?.instantiateViewController(withIdentifier: "weekdayStoryboardID") as! WeekdayIntroViewController
            
            //Set some required survye variables
            workdayViewController.device_id = UIDevice.current.identifierForVendor!.uuidString
            workdayViewController.lat = String(txtLatitude)
            workdayViewController.long = String(txtLongitude)
            workdayViewController.researchNet = self.researchNet
            
            let navigationController = UINavigationController(rootViewController: workdayViewController)
            
            self.present(navigationController, animated: true, completion: nil)
            
            
        case .weekendSurvey:
            
            let workdayViewController = self.storyboard?.instantiateViewController(withIdentifier: "weekendStoryboardID") as! WeekendIntroViewController
            
            //Set some required survye variables
            workdayViewController.device_id = UIDevice.current.identifierForVendor!.uuidString
            workdayViewController.lat = String(txtLatitude)
            workdayViewController.long = String(txtLongitude)
            workdayViewController.researchNet = self.researchNet
            
            
            let navigationController = UINavigationController(rootViewController: workdayViewController)
            
            self.present(navigationController, animated: true, completion: nil)
            
        }
        
        
    }
}

// Used for survey implementions with ResearchKit
extension ActivityViewController : ORKTaskViewControllerDelegate {
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        //write task name and complete date to local storage
        let defaults = UserDefaults.standard
        if taskViewController.task?.identifier == "SurveyWeekdayTask" {
            defaults.set(Date(), forKey: "weekday_timestamp")
        } else{
            defaults.set(Date(), forKey: "weekend_timestamp")
        }
        
        let device_id = UIDevice.current.identifierForVendor!.uuidString
        let taskResult = taskViewController.result // this should be a ORKTaskResult
        let results = taskResult.results as! [ORKStepResult]//[ORKStepResult]
        var responses: [String:String] = [:]
        
        for thisStepResult in results { // [ORKStepResults]
            
            let stepResults = thisStepResult.results as! [ORKQuestionResult]
            
            /*
             Go through the supported answer formats.  This is made easier with AppCore but we're not using this for now just because a) its in objective C and kind of hard to use and 2) its going away at some point to be replaced with enhancements to the ResearchKit framework
             
             */
            if let scaleresult = stepResults.first as? ORKScaleQuestionResult
            {
                if scaleresult.scaleAnswer != nil
                {
                    responses[scaleresult.identifier] = (scaleresult.scaleAnswer?.stringValue)!
                }
            }
            
            if let choiceresult = stepResults.first as? ORKChoiceQuestionResult
            {
                if choiceresult.choiceAnswers != nil
                {
                    let selected = choiceresult.choiceAnswers!
                    responses[choiceresult.identifier] = "\(selected.first!)"
                }
            }
        }
        
        
        // Submit results
        researchNet.submitSurveyResponse({ (responseObject, error) in
            
            if error != nil {
                
                let errorMessage = "Unable to reach the server. Try again."
                
                let alert = UIAlertController(title: "Submission Error",
                                              message: errorMessage, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: {
                    (alert: UIAlertAction!) in taskViewController.goBackward()
                })
                alert.addAction(action)
                taskViewController.present(alert, animated: true, completion: nil)
                
            } else {
                taskViewController.dismiss(animated: true, completion: nil)
            }
            
        }, device_id: device_id, lat: String(txtLatitude), long: String(txtLongitude), response: responses)
        
        
        
        
    }
}
