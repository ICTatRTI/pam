//
//  ActivityViewController.swift
//  ema
//
//  Created by Adam Preston on 4/20/16.
//  Copyright © 2016 RTI. All rights reserved.
//

import UIKit
import ResearchKit

enum Activity: Int {
    case WeekdaySurvey, WeekendSurvey
    
    static var allValues: [Activity] {
        var idx = 0
        return Array(AnyGenerator{ return self.init(rawValue: idx++)})
    }
    
    var title: String {
        switch self {
        case .WeekdaySurvey:
            return "Weekday Survey"
        case .WeekendSurvey:
            return "Weekend Survey"
        }
    }
    
    var subtitle: String {
        switch self {
        case .WeekdaySurvey:
            return "Answer 6 short questions"
        case .WeekendSurvey:
            return "Voice evaluation"
        }
    }
}

class ActivityViewController: UITableViewController {
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else { return 0 }
        
        return Activity.allValues.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("activityCell", forIndexPath: indexPath)
        
        if let activity = Activity(rawValue: indexPath.row) {
            cell.textLabel?.text = activity.title
            cell.detailTextLabel?.text = activity.subtitle
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let activity = Activity(rawValue: indexPath.row) else { return }
        
        let taskViewController: ORKTaskViewController
        switch activity {
        case .WeekdaySurvey:
            taskViewController = ORKTaskViewController(task: StudyTasks.surveyTask, taskRunUUID: NSUUID())
        case .WeekendSurvey:
            taskViewController = ORKTaskViewController(task: StudyTasks.surveyWeekendTask, taskRunUUID: NSUUID())
            
        }
        
        taskViewController.delegate = self
        navigationController?.presentViewController(taskViewController, animated: true, completion: nil)
    }
}

extension ActivityViewController : ORKTaskViewControllerDelegate {
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        // Handle results using taskViewController.result
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
