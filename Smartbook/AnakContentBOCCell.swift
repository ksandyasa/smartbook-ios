//
//  AnakContentBOCCell.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 9/15/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import QuartzCore

class AnakContentBOCCell: UITableViewCell {

    @IBOutlet weak var itemAnakBOCPict: UIImageView!
    @IBOutlet weak var itemAnakBOCName: UILabel!
    @IBOutlet weak var itemAnakBOCJabatan: UILabel!
    @IBOutlet weak var itemAnakBOCPictWidth: NSLayoutConstraint!
    @IBOutlet weak var itemAnakBOCPictHeight: NSLayoutConstraint!
    @IBOutlet weak var anakItemNameTop: NSLayoutConstraint!
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
        
        itemAnakBOCPictHeight.constant = itemAnakBOCPictHeight.constant * ratioHeight
        itemAnakBOCPictWidth.constant = itemAnakBOCPictHeight.constant
        let cornerRadius: CGFloat = itemAnakBOCPictHeight.constant
        itemAnakBOCPict.layer.cornerRadius = cornerRadius / 2
        itemAnakBOCPict.layer.masksToBounds = true
        
        itemAnakBOCName.lineBreakMode = NSLineBreakMode.ByWordWrapping
        itemAnakBOCName.numberOfLines = 0
        itemAnakBOCName.font = itemAnakBOCName.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 19)
        itemAnakBOCName.sizeToFit()
        
        itemAnakBOCJabatan.lineBreakMode = NSLineBreakMode.ByWordWrapping
        itemAnakBOCJabatan.numberOfLines = 0
        itemAnakBOCJabatan.font = itemAnakBOCJabatan.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 16)
        itemAnakBOCJabatan.sizeToFit()
        
        itemAnakBOCName.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(itemAnakBOCName.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        itemAnakBOCJabatan.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(itemAnakBOCJabatan.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        anakItemNameTop.constant = ratioHeight * anakItemNameTop.constant

    }
    
}
