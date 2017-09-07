//
//  MenuCell.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 8/29/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var menuTitle: UILabel!
    @IBOutlet weak var menuIconHeight: NSLayoutConstraint!
    @IBOutlet weak var menuIconWidth: NSLayoutConstraint!
    var ratioWidth: CGFloat = 0.0
    var ratioHeight: CGFloat = 0.0
    @IBOutlet weak var menuIconLeft: NSLayoutConstraint!
    @IBOutlet weak var menuTitleLeft: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupRatioWidthAndHeightBasedOnDeviceScreen(orientation: Bool) {
        ratioWidth = (orientation == true) ? SmartbookUtility.setupRatioWidthBasedOnLandscape() : SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = (orientation == true) ? SmartbookUtility.setupRatioHeightBasedOnLandscape() : SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
        
        menuIconHeight.constant = ratioHeight * menuIconHeight.constant
        menuIconWidth.constant = menuIconHeight.constant
        
        menuTitle.font = menuTitle.font.fontWithSize(CGFloat(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 20))
        
        menuTitle.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(menuTitle.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)        
    }
    
    func resizeMenuIconWidthAndHeight() {
        menuIconHeight.constant = menuIconHeight.constant - (ratioHeight * 20)
        menuIconWidth.constant = menuIconHeight.constant
    }

}
