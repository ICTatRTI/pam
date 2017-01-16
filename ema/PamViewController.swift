//
//  PamViewController.swift
//  ema
//
//  Created by Adam Preston on 4/29/16.
//  Copyright © 2016 RTI. All rights reserved.
//

import UIKit
import ResearchNet

class PamViewController: SurveyViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var finishNavigationButton: UIButton!
    var researchNet : ResearchNet!
    
    
    let identifier = "CellIdentifier"
    
    @IBAction func finishSurveyButtonTapped() {
        
        let indexPaths : NSArray = self.collectionView!.indexPathsForSelectedItems! as NSArray
        let indexPath : IndexPath = indexPaths[0] as! IndexPath
        
        let cell = collectionView.cellForItem(at: indexPath) as! PamCollectionViewCell
        
        saveSurvey(cell.pamPhotoName)
        
        //Submit Survey
        researchNet.submitSurveyResponse({ (responseObject, error) in
            
            
            if error != nil {
                
                let errorMessage = "Unable to reach the server. Try again."
                let alert = UIAlertController(title: "Submission Error",
                                              message: errorMessage, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                // using tags to keep track of which survey we just done
                let defaults = UserDefaults.standard
                if self.finishNavigationButton.tag == 1{
                    defaults.set(NSDate(), forKey: "weekday_timestamp")
                } else{
                    defaults.set(NSDate(), forKey: "weekend_timestamp")
                }
                
                
                let destinationViewController = self.storyboard?.instantiateViewController(withIdentifier: "studyViewController") as! UITabBarController
                
                let navigationViewController = destinationViewController.viewControllers!.first as! UINavigationController
                
                let activityViewController = navigationViewController.viewControllers.first as! ActivityViewController
                activityViewController.researchNet = self.researchNet
                
                self.present(destinationViewController, animated: true, completion: nil)
                
            }
            
            
        }, device_id: device_id, lat: lat, long: long, response: surveyParamters)
        
        
    }
    
    func saveSurvey(_ response: String){
        self.surveyParamters[Constants.PAM_QUESTION_LABEL] = response
    }
    
    @IBAction func reloadImages() {
        
        finishNavigationButton.isEnabled = false
        finishNavigationButton.layer.borderColor = Constants.disabledColor.cgColor
        self.collectionView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self;
        collectionView.dataSource = self
        
        finishNavigationButton.backgroundColor = UIColor.clear
        finishNavigationButton.layer.cornerRadius = 5
        finishNavigationButton.layer.borderWidth = 1
        finishNavigationButton.contentEdgeInsets = UIEdgeInsetsMake(10,20,10,20)
        finishNavigationButton.layer.borderColor = Constants.disabledColor.cgColor
        finishNavigationButton.isEnabled = false

        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func highlightCell(_ indexPath : IndexPath, flag: Bool) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! PamCollectionViewCell
        
        if flag {
            cell.imageView.alpha = 0.6;
            cell.checkIcon.isHidden = false;
            cell.backgroundCircle.isHidden = false;
        } else {
            cell.imageView.alpha = 1.0;
            cell.checkIcon.isHidden = true;
            cell.backgroundCircle.isHidden = true;
        }
        
        
    }
    
}




// MARK:- UICollectionViewDataSource Delegate
extension PamViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PamCollectionViewCell
        
        let random = arc4random() % 3 + 1;
        
        let file_name = NSString(format: "%d_%d.jpg",indexPath.row + 1,random)
        let name = NSString(format: "%d_%d",indexPath.row + 1,random)
        
        cell.pamPhotoName = name as String
        cell.imageView.image = UIImage(named: file_name.lowercased)
        cell.checkIcon.isHidden = true;
        cell.checkIcon.image = UIImage(named:"check" )
        cell.backgroundCircle.isHidden = true;
        cell.backgroundCircle.layer.cornerRadius = 12.0;
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        //1
        switch kind {
        //2
        case UICollectionElementKindSectionHeader:
            
            //3
            let headerView =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: "PamHeaderView", for: indexPath) as! PamHeaderView
            headerView.label.text = "Select the photo that best captures how you feel right now."
            
            return headerView
        default:
            //4
            fatalError("Unexpected element kind")
        }
    }
    
}




extension PamViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        highlightCell(indexPath, flag: true)
        finishNavigationButton.isEnabled = true
        finishNavigationButton.layer.borderColor = Constants.enabledColor.cgColor
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        highlightCell(indexPath, flag: false)
        
    }
}
