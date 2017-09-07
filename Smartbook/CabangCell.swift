//
//  CabangCell.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 8/30/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit

class CabangCell: UICollectionViewCell {

    @IBOutlet weak var cabangThumb: UIImageView!
    @IBOutlet weak var cabangTitle: UILabel!
    @IBOutlet weak var cabangThumbHeight: NSLayoutConstraint!
    @IBOutlet weak var cabangThumbWidth: NSLayoutConstraint!
    var ratioWidth: CGFloat! = 0.0
    var ratioHeight: CGFloat! = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.setupWidthAndHeightBasedOnDeviceScreen()
    }
    
    func setupWidthAndHeightBasedOnDeviceScreen() {
        ratioWidth = (UIDevice.currentDevice().orientation.isLandscape == true) ? SmartbookUtility.setupRatioWidthBasedOnLandscape() : SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = (UIDevice.currentDevice().orientation.isLandscape == true) ? SmartbookUtility.setupRatioHeightBasedOnLandscape() : SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
        
        cabangThumbHeight.constant = ratioHeight * cabangThumbHeight.constant
        cabangThumbWidth.constant = cabangThumbHeight.constant
        
        cabangTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cabangTitle.numberOfLines = 0
        cabangTitle.font = cabangTitle.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 18)
        cabangTitle.sizeToFit()
        
        cabangTitle.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(cabangTitle.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
    }

}
