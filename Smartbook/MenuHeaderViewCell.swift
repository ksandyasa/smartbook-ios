//
//  MenuHeaderViewCell.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 9/10/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit

class MenuHeaderViewCell: UITableViewCell {

    @IBOutlet weak var menuHeaderBg: UIImageView!
    @IBOutlet weak var menuHeaderLogo: UIImageView!
    @IBOutlet weak var menuHeaderIcon: UIImageView!
    @IBOutlet weak var menuHeaderTitle: UILabel!
    @IBOutlet weak var menuHeaderBgHeight: NSLayoutConstraint!
    @IBOutlet weak var menuHeaderLogoHeight: NSLayoutConstraint!
    @IBOutlet weak var menuHeaderLogoWidth: NSLayoutConstraint!
    @IBOutlet weak var menuHeaderIconHeight: NSLayoutConstraint!
    @IBOutlet weak var menuHeaderIconWidth: NSLayoutConstraint!
    var ratioWidth: CGFloat! = 0.0
    var ratioHeight: CGFloat! = 0.0
    @IBOutlet weak var menuHeaderBgBottom: NSLayoutConstraint!
    
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
        
        menuHeaderBg.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(menuHeaderBg.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        menuHeaderBgBottom.constant = ratioHeight * menuHeaderBgBottom.constant + 10
//        menuHeaderBgHeight.constant = ratioHeight * menuHeaderBgHeight.constant
        
        menuHeaderLogoHeight.constant = ratioHeight * menuHeaderLogoHeight.constant
        menuHeaderLogoWidth.constant = menuHeaderLogoHeight.constant
        
        menuHeaderIconHeight.constant = ratioHeight * menuHeaderIconHeight.constant
        menuHeaderIconWidth.constant = menuHeaderIconHeight.constant
        
        menuHeaderTitle.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(menuHeaderTitle.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        menuHeaderTitle.font = menuHeaderTitle.font.fontWithSize(CGFloat(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 20))
    }
    
}
