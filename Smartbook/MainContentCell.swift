//
//  MainContentCell.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 8/27/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit

class MainContentCell: UICollectionViewCell {

    @IBOutlet var ivItemContent: UIImageView!
    @IBOutlet var lbItemContent: UILabel!
    @IBOutlet weak var ivItemContentHeight: NSLayoutConstraint!
    @IBOutlet weak var ivItemContentWidth: NSLayoutConstraint!
    var ratioWidth: CGFloat! = 0.0
    var ratioHeight: CGFloat! = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.setupWidthAndHeightBasedOnDeviceScreen()
    }
    
    func setupWidthAndHeightBasedOnDeviceScreen() {
        ratioWidth = (UIDevice.currentDevice().orientation.isLandscape == true) ? SmartbookUtility.setupRatioWidthBasedOnLandscape() : SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = (UIDevice.currentDevice().orientation.isLandscape == true) ? SmartbookUtility.setupRatioHeightBasedOnLandscape() :  SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
        
        ivItemContentHeight.constant = ratioHeight * ivItemContentHeight.constant
        ivItemContentWidth.constant = ivItemContentHeight.constant
        
        lbItemContent.lineBreakMode = NSLineBreakMode.ByWordWrapping
        lbItemContent.numberOfLines = 0
        lbItemContent.font = lbItemContent.font.fontWithSize(CGFloat(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 18))
        lbItemContent.sizeToFit()
        
        lbItemContent.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(lbItemContent.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
    }
    
}
