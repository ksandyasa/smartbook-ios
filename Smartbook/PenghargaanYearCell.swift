//
//  PenghargaanYearCell.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 9/14/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import QuartzCore

class PenghargaanYearCell: UICollectionViewCell {

    @IBOutlet weak var itemYear: UILabel!
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
        
        itemYear.lineBreakMode = NSLineBreakMode.ByWordWrapping
        itemYear.numberOfLines = 0
        itemYear.font = itemYear.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 19)
        itemYear.backgroundColor = SmartbookUtility.colorWithHexString("FFFFFF  ")
        itemYear.layer.cornerRadius = CGFloat(ratioWidth * 25)
        itemYear.layer.masksToBounds = true
        itemYear.sizeToFit()
        itemYear.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(itemYear.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)

    }

}
