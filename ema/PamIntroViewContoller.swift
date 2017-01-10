//
//  PamIntroViewContoller.swift
//  ema
//
//  Created by Adam Preston on 4/29/16.
//  Copyright © 2016 RTI. All rights reserved.
//

import UIKit
import ResearchNet

class PamIntroViewContoller: SurveyViewController {

    @IBOutlet weak var gettingStartedButton: UIButton!
    var researchNet : ResearchNet!
    

    // Be sure to pass around the ResearchNet object to any view controllers who may need it.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toPamQuestion" {
            if let destination = segue.destination as? PamViewController {
                destination.device_id = self.device_id
                destination.lat = self.lat
                destination.long = self.long
                destination.researchNet = self.researchNet
                
            }
        }
    }

    
}

