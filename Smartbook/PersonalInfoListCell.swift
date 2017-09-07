//
//  PersonalInfoListCell.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 9/21/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import QuartzCore

class PersonalInfoListCell: UITableViewCell {

    @IBOutlet weak var itemListPict: UIImageView!
    @IBOutlet weak var itemListName: UILabel!
    @IBOutlet weak var itemListJabatan: UILabel!
    @IBOutlet weak var itemListPictHeight: NSLayoutConstraint!
    @IBOutlet weak var itemListPictWidth: NSLayoutConstraint!
    @IBOutlet weak var itemListNameTop: NSLayoutConstraint!
    @IBOutlet weak var itemListJabatanTop: NSLayoutConstraint!
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
        
        itemListPictHeight.constant = ratioHeight * itemListPictHeight.constant
        itemListPictWidth.constant = itemListPictHeight.constant
        let cornerRadius: CGFloat = itemListPictHeight.constant
        itemListPict.layer.cornerRadius = cornerRadius / 2
        itemListPict.layer.masksToBounds = true
        
        itemListName.lineBreakMode = NSLineBreakMode.ByWordWrapping
        itemListName.numberOfLines = 0
        itemListName.font = itemListName.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 19)
        itemListName.sizeToFit()
        
        itemListJabatan.lineBreakMode = NSLineBreakMode.ByWordWrapping
        itemListJabatan.numberOfLines = 0
        itemListJabatan.font = itemListJabatan.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 16)
        itemListJabatan.sizeToFit()
        
        itemListName.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(itemListName.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        itemListJabatan.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(itemListJabatan.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        itemListNameTop.constant = ratioHeight * itemListNameTop.constant
        itemListJabatanTop.constant = ratioHeight * itemListJabatanTop.constant
    }
    
}
