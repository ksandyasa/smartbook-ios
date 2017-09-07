//
//  CabangPopupCell.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 9/15/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import QuartzCore

class CabangPopupCell: UITableViewCell {
    
    @IBOutlet weak var cabPopupTitle: UILabel!
    var ratioWidth: CGFloat! = 0.0
    var ratioHeight: CGFloat! = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.setupWidthAndHeightBasedOnDeviceScreen()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWidthAndHeightBasedOnDeviceScreen() {
        ratioWidth = SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
        
        cabPopupTitle.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(cabPopupTitle.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        cabPopupTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cabPopupTitle.numberOfLines = 0
        cabPopupTitle.font = cabPopupTitle.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 19)
        cabPopupTitle.sizeToFit()
    }
    
}
