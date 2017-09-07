//
//  PersonalInfoRekanCell.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 9/4/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import QuartzCore

class PersonalInfoRekanCell: UICollectionViewCell {

    @IBOutlet weak var personalInfoRekanPict: UIImageView!
    var ratioWidth: CGFloat = 0.0
    var ratioHeight: CGFloat = 0.0
    @IBOutlet weak var personalInfoRekanPictWidth: NSLayoutConstraint!
    @IBOutlet weak var personalInfoRekanPictHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupRatioWidthAndHeightBasedOnDeviceScreen()
    }
    
    func setupRatioWidthAndHeightBasedOnDeviceScreen() {
        ratioWidth = SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()

        personalInfoRekanPictHeight.constant = ratioHeight * personalInfoRekanPictHeight.constant
        personalInfoRekanPictWidth.constant = personalInfoRekanPictHeight.constant
        let cornerRadius = personalInfoRekanPictHeight.constant
        personalInfoRekanPict.layer.cornerRadius = cornerRadius / 2
        personalInfoRekanPict.layer.masksToBounds = true
    }
    
}
