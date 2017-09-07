//
//  CabangStrukturBawahanCell.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 10/11/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import QuartzCore

class CabangStrukturBawahanCell: UICollectionViewCell {

    @IBOutlet weak var cabangBawahanPict: UIImageView!
    @IBOutlet weak var cabangBawahanName: UILabel!
    @IBOutlet weak var cabangBawahanPictHeight: NSLayoutConstraint!
    @IBOutlet weak var cabangBawahanWidthPict: NSLayoutConstraint!
    var ratioWidth: CGFloat! = 0.0
    var ratioHeight: CGFloat! = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }
    
    func setupRatioWidthAndHeightBasedOnDeviceScreen(orientation: Bool) {
        ratioWidth = (orientation == true) ? SmartbookUtility.setupRatioWidthBasedOnLandscape() : SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = (orientation == true) ? SmartbookUtility.setupRatioHeightBasedOnLandscape() : SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
        
        cabangBawahanPictHeight.constant = ratioHeight * cabangBawahanPictHeight.constant
        cabangBawahanWidthPict.constant = cabangBawahanPictHeight.constant
        let cornerRadius = cabangBawahanPictHeight.constant
        cabangBawahanPict.layer.cornerRadius = cornerRadius / 2
        cabangBawahanPict.layer.masksToBounds = true
        
        cabangBawahanName.text = ""
        cabangBawahanName.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cabangBawahanName.numberOfLines = 0
        cabangBawahanName.font = cabangBawahanName.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 17)
        cabangBawahanName.sizeToFit()
        
        cabangBawahanName.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(cabangBawahanName.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
    }

}
