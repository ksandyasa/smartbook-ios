//
//  MenuFooterViewCell.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 9/29/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit

class MenuFooterViewCell: UITableViewCell {

    @IBOutlet weak var menuFooterTitle1: UILabel!
    @IBOutlet weak var menuFooterTitle: UILabel!
    var ratioWidth: CGFloat! = 0.0
    var ratioHeight: CGFloat! = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.setupWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWidthAndHeightBasedOnDeviceScreen(orientation: Bool) {
        ratioWidth = (orientation == true) ? SmartbookUtility.setupRatioWidthBasedOnLandscape() : SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = (orientation == true) ? SmartbookUtility.setupRatioHeightBasedOnLandscape() : SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
        
        menuFooterTitle1.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(menuFooterTitle1.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        menuFooterTitle1.font = menuFooterTitle1.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 20)
        
        menuFooterTitle.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(menuFooterTitle.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        menuFooterTitle.font = menuFooterTitle.font.fontWithSize(CGFloat(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 20))

    }
    
}
