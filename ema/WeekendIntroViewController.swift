//
//  WeekendIntroViewController.swift
//  workaday
//
//  Created by Adam Preston on 7/28/16.
//  Copyright © 2016 RTI. All rights reserved.
//

import UIKit
import ResearchNet

class WeekendIntroViewController: SurveyViewController  {
    
    @IBOutlet weak var gettingStartedButton: UIButton!
    var researchNet : ResearchNet!
    
    @IBAction func toSurveyQuestions(_ segue: UIStoryboardSegue){
        performSegue(withIdentifier: "toWeekendQuestion", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Style the done button (simliar to RK)
        gettingStartedButton.backgroundColor = UIColor.clear
        gettingStartedButton.layer.cornerRadius = 5
        gettingStartedButton.layer.borderWidth = 1
        gettingStartedButton.contentEdgeInsets = UIEdgeInsetsMake(10,20,10,20)
        
        let swiftColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        gettingStartedButton.layer.borderColor = swiftColor.cgColor
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelSurveyButtonTapped))
        
    }
    
    func cancelSurveyButtonTapped(_ sender: UIBarButtonItem) {
        
        let workdayViewController = self.storyboard?.instantiateViewController(withIdentifier: "activityStoryBoardID")
        
        let navigationController = UINavigationController(rootViewController: workdayViewController!)
        
        self.present(navigationController, animated: true, completion: nil)
    }
    
    

    
}
