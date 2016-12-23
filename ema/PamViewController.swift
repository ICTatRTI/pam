//
//  PamViewController.swift
//  ema
//
//  Created by Adam Preston on 4/29/16.
//  Copyright © 2016 RTI. All rights reserved.
//

import UIKit

class PamViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        //performSegueWithIdentifier("toLogin", sender: self)
        print("go back to the activities screen")
        
    }
    
    let identifier = "CellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func highlightCell(_ indexPath : IndexPath, flag: Bool) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        if flag {
            cell?.contentView.backgroundColor = UIColor.magenta
        } else {
            cell?.contentView.backgroundColor = nil
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
        
        let name = NSString(format: "%d_%d.jpg",indexPath.row + 1,random)
        
        cell.imageView.image = UIImage(named: name.lowercased)
        
        
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
            headerView.label.text = "Select the photo the best captures how you feel right now."
            
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
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        highlightCell(indexPath, flag: false)
        
        
    }
}
