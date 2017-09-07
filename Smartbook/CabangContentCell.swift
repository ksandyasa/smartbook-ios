//
//  CabangContentCell.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 8/30/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import QuartzCore

class CabangContentCell: UICollectionViewCell {

    @IBOutlet weak var cabangContentTitle: UILabel!
    var ratioWidth: CGFloat! = 0.0
    var ratioHeight: CGFloat! = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.setupWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }
    
    func setupWidthAndHeightBasedOnDeviceScreen(orientation: Bool) {
        ratioWidth = (orientation == true) ? SmartbookUtility.setupRatioWidthBasedOnLandscape() : SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = (orientation == true) ? SmartbookUtility.setupRatioHeightBasedOnLandscape() : SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
        
        cabangContentTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cabangContentTitle.numberOfLines = 0
        cabangContentTitle.font = cabangContentTitle.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 17)
        cabangContentTitle.sizeToFit()
        
        cabangContentTitle.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(cabangContentTitle.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)        
        cabangContentTitle.backgroundColor = SmartbookUtility.colorWithHexString("0D7BD4")
        cabangContentTitle.layer.cornerRadius = (orientation == true) ? CGFloat(ratioWidth * 15) : CGFloat(ratioWidth * 25)
        cabangContentTitle.layer.masksToBounds = true
    }
    
}
