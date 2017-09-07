//
//  AnakCell.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 8/30/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit

class AnakCell: UICollectionViewCell {

    @IBOutlet weak var anakThumb: UIImageView!
    @IBOutlet weak var anakTitle: UILabel!
    @IBOutlet weak var anakThumbHeight: NSLayoutConstraint!
    @IBOutlet weak var anakThumbWidth: NSLayoutConstraint!
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
        
        anakThumbHeight.constant = ratioHeight * anakThumbHeight.constant
        anakThumbWidth.constant = anakThumbHeight.constant
        
        anakTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        anakTitle.numberOfLines = 0
        anakTitle.font = anakTitle.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 18)
        anakTitle.sizeToFit()
        
        anakTitle.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(anakTitle.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
    }

}
