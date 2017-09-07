//
//  CabangContentViewController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 8/30/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import Alamofire

class CabangContentViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var cabangContentBg: UIImageView!
    @IBOutlet weak var cabangBeltView: UIView!
    @IBOutlet weak var cabangBeltLabel: UILabel!
    @IBOutlet weak var cabangList: UICollectionView!
    @IBOutlet weak var cabangBeltViewHeight: NSLayoutConstraint!
    let cellIdentifier: String = "cabangCell"
    var ratioWidth: CGFloat = 0.0
    var ratioHeight: CGFloat = 0.0
    var cabangContentList: Array<AnyObject>! = []
    weak var cabangContentDelegate: CabangViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        cabangList.registerNib(UINib(nibName: "CabangCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        cabangList.delegate = self
        cabangList.dataSource = self
        
        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }
    
    override func viewDidAppear(animated: Bool) {
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
        
        cabangBeltView.bounds.size.width = self.view.bounds.size.width
        cabangBeltViewHeight.constant = 44.0
        
        self.setupMainContentHeaderWithGradientColor("0D7BD4")
                
        cabangBeltLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cabangBeltLabel.numberOfLines = 0
        cabangBeltLabel.font = cabangBeltLabel.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 22)
        cabangBeltLabel.sizeToFit()
        
        cabangBeltLabel.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(cabangBeltLabel.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        
        cabangContentBg.bounds.size.width = self.view.bounds.size.width
        cabangContentBg.bounds.size.height = (orientation == true) ? ratioHeight * 405 : ratioHeight * 609
        
        cabangList.bounds.size.height = (orientation == true) ? ratioHeight * 405 : ratioHeight * 609
        cabangList.backgroundColor = UIColor.clearColor()
        cabangList.backgroundView = nil
        
        if (cabangContentList.count > 0) {
            cabangList.reloadData()
        }
        
        self.view.setNeedsUpdateConstraints()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    func setupMainContentHeaderWithGradientColor(color: String) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = cabangBeltView.bounds
        gradient.colors = [SmartbookUtility.colorWithHexString("0D7BD4").CGColor,
            SmartbookUtility.colorWithHexString("3FAED6").CGColor,
            SmartbookUtility.colorWithHexString("0D7BD4").CGColor]
        cabangBeltView.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    func setupCabangContentIcons(imageIcon: UIImageView, urlString: String) {
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
        return cabangContentList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let itemCell = cabangList.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! CabangCell
        
        if (cabangContentList.count > 0) {
            let urlImage = String(format: "%@%@", ConstantAPI.getImageBaseURL(), cabangContentList[indexPath.row]["icon"] as! String)
            self.setupCabangContentIcons(itemCell.cabangThumb, urlString: urlImage)
            itemCell.cabangTitle.text = String(format: "%@", cabangContentList[indexPath.row]["nama"] as! String)
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
        cabangContentDelegate.actionClickFromCabangContentController(cabangContentList, indeks: indexPath.row)
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
