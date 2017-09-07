//
//  MainContentViewController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 8/27/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import Alamofire

class MainContentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var mainContentBg: UIImageView!
    @IBOutlet weak var mainContentLabel: UILabel!
    @IBOutlet weak var mainContentHeader: UIView!
    @IBOutlet var mainContentList: UICollectionView!
    let cellIdentifier: String = "mainContentCell"
    var ratioWidth: CGFloat = 0.0
    var ratioHeight: CGFloat = 0.0
    var mainMenuItems: Array<AnyObject>! = []
    var mainContentItems: Array<AnyObject>! = []
    weak var mainContentDelegate: MainViewController!
    @IBOutlet weak var mainContentHeaderHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        mainContentList.registerNib(UINib(nibName: "MainContentCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        mainContentList.delegate = self
        mainContentList.dataSource = self
        
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
        self.view.bounds.size.height = (orientation == true) ? ratioHeight * 486 : ratioHeight * 653
        
        mainContentHeader.frame.size.width = self.view.bounds.size.width
        mainContentHeaderHeight.constant = 44.0
        
        mainContentLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        mainContentLabel.numberOfLines = 0
        mainContentLabel.font = mainContentLabel.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 22)
        mainContentLabel.sizeToFit()
        
        mainContentLabel.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(mainContentLabel.frame, ratioWidth: ratioHeight, ratioHeight: ratioHeight)

        mainContentBg.bounds.size.width = self.view.bounds.size.width
        mainContentBg.bounds.size.height = (orientation == true) ? ratioHeight * 405 : ratioHeight * 609
        self.setupMainContentHeaderWithGradientColor("F7CE1F")
        
        mainContentList.bounds.size.height = (orientation == true) ? ratioHeight * 405 : ratioHeight * 609
        mainContentList.backgroundColor = UIColor.clearColor()
        mainContentList.backgroundView = nil
        
        if (mainContentItems.count > 0) {
            mainContentList.reloadData()
        }
        
        self.view.setNeedsUpdateConstraints()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    func setupMainContentHeaderWithGradientColor(color: String) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = mainContentHeader.frame
        gradient.colors = [SmartbookUtility.colorWithHexString("F7CE1F").CGColor,
            SmartbookUtility.colorWithHexString("FFFF8D").CGColor,
            SmartbookUtility.colorWithHexString("F7CE1F").CGColor]
        mainContentHeader.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    func setupMainContentIcons(imageIcon: UIImageView, urlString: String) {
        Alamofire.request(.GET, urlString,
            parameters: nil)
            .responseJSON { response in
                
                imageIcon.image = UIImage(data: response.data!)
        }
    }
    
    // UICollection View Delegate Method
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainContentItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let itemCell = mainContentList.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! MainContentCell
        
        if (mainContentItems.count > 0) {
            let urlImage = String(format: "%@%@", ConstantAPI.getImageBaseURL(), mainContentItems[indexPath.row]["icon"] as! String)
            self.setupMainContentIcons(itemCell.ivItemContent, urlString: urlImage)
            itemCell.lbItemContent.text = mainContentItems[indexPath.row]["nama"] as? String            
        }
        
        return itemCell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(ratioWidth * 232, ratioHeight * 176)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        mainContentDelegate.actionClickFromMainContentController(mainContentItems, indeks: indexPath.row)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
