//
//  ProfileHeaderView.swift
//  ema
//
//  Created by Adam Preston on 4/20/16.
//  Copyright © 2016 RTI. All rights reserved.
//

import UIKit

@IBDesignable
class ProfileHeaderView: UIView {
    
    // MARK: Properties
    
    var seperatorHeight = CGFloat(0.5)
    
    var seperatorColor = UIColor.lightGray
    
    // MARK: UIView
    
    override func draw(_ rect: CGRect) {
        // Draw a seperator line at the bottom of the view.
        var fillRect = bounds
        fillRect.origin.y = bounds.size.height - seperatorHeight
        fillRect.size.height = seperatorHeight
        
        seperatorColor.setFill()
        UIRectFill(fillRect)
    }
    
    
}
