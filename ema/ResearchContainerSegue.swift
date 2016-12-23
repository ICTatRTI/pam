//
//  ResearchContainerSegue.swift
//  ema
//
//  Created by Adam Preston on 4/20/16.
//  Copyright © 2016 RTI. All rights reserved.
//

import UIKit

class ResearchContainerSegue: UIStoryboardSegue {

    override func perform() {
        let controllerToReplace = source.childViewControllers.first
        let destinationControllerView = destination.view
        
        destinationControllerView?.translatesAutoresizingMaskIntoConstraints = true
        destinationControllerView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        destinationControllerView?.frame = source.view.bounds
        
        controllerToReplace?.willMove(toParentViewController: nil)
        source.addChildViewController(destination)
        
        source.view.addSubview(destinationControllerView!)
        controllerToReplace?.view.removeFromSuperview()
        
        destination.didMove(toParentViewController: source)
        controllerToReplace?.removeFromParentViewController()
    }
    
}
