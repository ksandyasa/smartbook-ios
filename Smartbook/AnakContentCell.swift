//
//  AnakContentCell.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 8/30/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import QuartzCore

class AnakContentCell: UICollectionViewCell {

    @IBOutlet weak var anakContentTitle: UILabel!
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
        
        anakContentTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        anakContentTitle.numberOfLines = 0
        anakContentTitle.font = anakContentTitle.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 17)
        anakContentTitle.sizeToFit()
        
        anakContentTitle.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(anakContentTitle.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        anakContentTitle.backgroundColor = SmartbookUtility.colorWithHexString("0D7BD4")
        anakContentTitle.layer.cornerRadius = (orientation == true) ? CGFloat(ratioWidth * 12.5) : CGFloat(ratioWidth * 25)
        anakContentTitle.layer.masksToBounds = true

    }
    
}
