//
//  PenghargaanListCell.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 9/14/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import QuartzCore

class PenghargaanListCell: UITableViewCell {

    @IBOutlet weak var itemIcon: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDetail: UILabel!
    @IBOutlet weak var itemIconWidth: NSLayoutConstraint!
    @IBOutlet weak var itemIconHeight: NSLayoutConstraint!
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
    
        itemTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        itemTitle.numberOfLines = 0
        itemTitle.font = itemTitle.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 19)
        itemTitle.sizeToFit()
        
        itemDetail.lineBreakMode = NSLineBreakMode.ByWordWrapping
        itemDetail.numberOfLines = 0
        itemDetail.font = itemDetail.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 16)
        itemDetail.sizeToFit()
        
        itemTitle.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(itemTitle.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        itemDetail.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(itemDetail.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        
    }
    
}
