//
//  MainSlideContentViewController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 8/28/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit

class MainSlideContentViewController: UIViewController {

    @IBOutlet weak var mainSlideContentBg: UIImageView!
    @IBOutlet weak var mainSlideContentTitle: UILabel!
    @IBOutlet weak var mainSlideContentDetail: UILabel!
    @IBOutlet weak var mainSlideContentMore: UILabel!
    @IBOutlet weak var mainSlideContentView: UIView!
    @IBOutlet weak var mainSlideContentTitleTop: NSLayoutConstraint!
    weak var mainSlideItemDelegate: MainSlideViewController!
    var pageIndex: Int!
    var imageBg: String!
    var mTitle: String!
    var mContent: String!
    var ratioWidth: CGFloat = 0.0
    var ratioHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        self.view.bounds.size.height = (orientation == true) ? ratioHeight * 299 : ratioHeight * 351
        
        mainSlideContentTitle.lineBreakMode = (ratioHeight < 1) ? NSLineBreakMode.ByTruncatingTail : NSLineBreakMode.ByWordWrapping
        mainSlideContentTitle.numberOfLines = (ratioHeight < 1) ? 2 : 0
        mainSlideContentTitle.font = mainSlideContentTitle.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 25)
        mainSlideContentTitle.sizeToFit()
        
        mainSlideContentDetail.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        mainSlideContentDetail.numberOfLines = (ratioHeight < 1) ? 2 : 3
        mainSlideContentDetail.font = mainSlideContentDetail.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 21)
        mainSlideContentDetail.sizeToFit()
        
        mainSlideContentMore.lineBreakMode = NSLineBreakMode.ByWordWrapping
        mainSlideContentMore.numberOfLines = 0
        mainSlideContentMore.font = mainSlideContentMore.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 21)
        mainSlideContentMore.text = (ratioHeight < 1) ? "Read More" : "... Read More"
        mainSlideContentMore.sizeToFit()

        mainSlideContentBg.bounds.size.width = (orientation == true) ? ratioWidth * 1024 : ratioWidth * 768
        mainSlideContentBg.bounds.size.height = (orientation == true) ? ratioHeight * 299 : ratioHeight * 351
        
        mainSlideContentView.bounds.size.width = (orientation == true) ? ratioWidth * 1024 : ratioWidth * 768
        mainSlideContentView.bounds.size.height = (orientation == true) ? ratioHeight * 299 : ratioHeight * 351
                
        mainSlideContentTitle.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(mainSlideContentTitle.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        mainSlideContentDetail.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(mainSlideContentDetail.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        mainSlideContentMore.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(mainSlideContentMore.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        let topSpaceTitle: CGFloat = ratioWidth * mainSlideContentTitleTop.constant
        mainSlideContentTitleTop.constant = topSpaceTitle
        
        let tapMore = UITapGestureRecognizer(target: self, action: #selector(MainSlideContentViewController.actionClick(_:)))
        mainSlideContentMore.addGestureRecognizer(tapMore)
        self.view.addGestureRecognizer(tapMore)
        
        mainSlideContentBg.image = UIImage(named: imageBg)
        mainSlideContentTitle.text = mTitle
        mainSlideContentDetail.text = mContent
    }
    
    func actionClick(sender: UITapGestureRecognizer) {
        mainSlideItemDelegate.actionClickFromSlideContent(pageIndex)
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
