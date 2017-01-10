//
//  ConsentUtils.swift
//  workaday
//
//  Created by Adam Preston on 8/1/16.
//  Copyright © 2016 RTI. All rights reserved.
//

import UIKit


func loadHTMLContent(fileName: String)->String{
    var fileContents: String? = nil
    
    let path = Bundle.main.path(forResource: fileName, ofType: "html")
    if path == nil {
        print("OOPPPPS")
    }else{
        
        do {
            fileContents = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        } catch _ as NSError {
            print("OOPPPPS")
        }
        // print(fileContents)
    }
    
    return fileContents!
    
    
}

