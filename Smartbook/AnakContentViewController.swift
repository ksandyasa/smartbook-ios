//
//  AnakContentViewController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 8/30/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import Alamofire

class AnakContentViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var anakContentBg: UIImageView!
    @IBOutlet weak var anakBeltView: UIView!
    @IBOutlet weak var anakBeltLabel: UILabel!
    @IBOutlet weak var anakList: UICollectionView!
    @IBOutlet weak var anakBeltViewHeight: NSLayoutConstraint!
    let cellIdentifier: String = "anakCell"
    var ratioWidth: CGFloat = 0.0
    var ratioHeight: CGFloat = 0.0
    var anakContentList: Array<AnyObject>! = []
    weak var anakContentDelegate: AnakViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        anakList.registerNib(UINib(nibName: "AnakCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        anakList.delegate = self
        anakList.dataSource = self
        
        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupRatioWidthAndHeightBasedOnDeviceScreen(orientation: Bool) {
        ratioWidth = (orientation == true) ? SmartbookUtility.setupRatioWidthBasedOnLandscape() : SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = (orientation == true) ? SmartbookUtility.setupRatioHeightBasedOnLandscape() : SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
        
        self.view.bounds.size.width = (orientation == true) ? ratioWidth * 1024 : ratioWidth * 768
        self.view.bounds.size.height = (orientation == true) ? ratioHeight * 449 : ratioHeight * 653
        
        anakBeltView.bounds.size.width = self.view.bounds.size.width
        anakBeltViewHeight.constant = 44.0
        
        self.setupMainContentHeaderWithGradientColor("0D7BD4")
        
        anakBeltLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        anakBeltLabel.numberOfLines = 0
        anakBeltLabel.font = anakBeltLabel.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 22)
        anakBeltLabel.sizeToFit()
        
        anakBeltLabel.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(anakBeltLabel.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        
        anakContentBg.bounds.size.width = self.view.bounds.size.width
        anakContentBg.bounds.size.height = (orientation == true) ? ratioHeight * 405 : ratioHeight * 609
        
        anakList.bounds.size.height = (orientation == true) ? ratioHeight * 405 : ratioHeight * 609
        anakList.backgroundColor = UIColor.clearColor()
        anakList.backgroundView = nil
        
        if (anakContentList.count > 0) {
            anakList.reloadData()
        }
        
        self.view.setNeedsUpdateConstraints()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    func setupMainContentHeaderWithGradientColor(color: String) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = anakBeltView.bounds
        gradient.colors = [SmartbookUtility.colorWithHexString("0D7BD4").CGColor,
            SmartbookUtility.colorWithHexString("3FAED6").CGColor,
            SmartbookUtility.colorWithHexString("0D7BD4").CGColor]
        anakBeltView.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    func setupAnakIcons(imageIcon: UIImageView, urlString: String) {
        Alamofire.request(.GET, urlString,
            parameters: nil)
            .responseJSON { response in
                
                imageIcon.image = UIImage(data: response.data!)
                imageIcon.layer.cornerRadius = imageIcon.frame.size.height / 2
                imageIcon.clipsToBounds = true
        }
    }
    
    // UICollection View Delegate Method
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return anakContentList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let itemCell = anakList.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! AnakCell
        
        if (anakContentList.count > 0) {
            let urlImage = String(format: "%@%@", ConstantAPI.getImageBaseURL(), anakContentList[indexPath.row]["icon"] as! String)
            self.setupAnakIcons(itemCell.anakThumb, urlString: urlImage)
            itemCell.anakTitle.text = String(format: "%@", anakContentList[indexPath.row]["nama"] as! String)
        }
            
        return itemCell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(ratioWidth * 232, ratioHeight * 176)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.25, left: 1.25, bottom: 1.25, right: 1.25)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return ratioWidth * 10
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return ratioHeight * 10
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        anakContentDelegate.actionClickFromAnakContentController(anakContentList, indeks: indexPath.row)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
