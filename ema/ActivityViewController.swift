//
//  ActivityViewController.swift
//  ema
//
//  Created by Adam Preston on 4/20/16.
//  Copyright © 2016 RTI. All rights reserved.
//

import UIKit
import ResearchKit
import ResearchNet

enum Activity: Int {
    case PAMSurvey
    static var allValues: [Activity] {
        var idx = -1
        
        return Array(
            AnyIterator{
                idx = idx + 1
                return self.init(rawValue: idx)})
    }
    
    var title: String {
        switch self {
        case .PAMSurvey:
            return "PAM Survey"

        }
    }
    
    var subtitle: String {
        switch self {
        case .PAMSurvey:
            return "Answer a couple of questions"
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath as IndexPath)
        
        if let activity = Activity(rawValue: indexPath.row) {
            cell.textLabel?.text = activity.title
            cell.detailTextLabel?.text = activity.subtitle
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let activity = Activity(rawValue: indexPath.row) else { return }
        
        
        switch activity {
        case .PAMSurvey:
            
            // This is the way to refernece a custom task controller
            
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "pamStoryboardID") as! PamIntroViewContoller
            /*
             self.navigationController?.pushViewController(secondViewController, animated: true)
             */
            secondViewController.lat = String(txtLatitude)
            secondViewController.long = String(txtLongitude)
            secondViewController.device_id = UIDevice.current.identifierForVendor!.uuidString
            secondViewController.researchNet = self.researchNet
            
            let navigationController = UINavigationController(rootViewController: secondViewController)
            
            self.present(navigationController, animated: true, completion: nil)
            
        }
        
    }
}


