//
//  PersonalInfoBawahanCell.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 9/4/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import QuartzCore

class PersonalInfoBawahanCell: UICollectionViewCell {

    @IBOutlet weak var personalInfoBawahanPict: UIImageView!
    @IBOutlet weak var personalInfoBawahanName: UILabel!
    @IBOutlet weak var personalInfoBawahanPictWidth: NSLayoutConstraint!
    @IBOutlet weak var personalInfoBawahanPictHeight: NSLayoutConstraint!
    var ratioWidth: CGFloat = 0.0
    var ratioHeight: CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupRatioWidthAndHeightBasedOnDeviceScreen()
    }
    
    func setupRatioWidthAndHeightBasedOnDeviceScreen() {
        ratioWidth = SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
        
        personalInfoBawahanPictHeight.constant = ratioHeight * personalInfoBawahanPictHeight.constant
        personalInfoBawahanPictWidth.constant = personalInfoBawahanPictHeight.constant
        let cornerRadius = personalInfoBawahanPictHeight.constant
        personalInfoBawahanPict.layer.cornerRadius = cornerRadius / 2
        personalInfoBawahanPict.layer.masksToBounds = true
        
        personalInfoBawahanName.lineBreakMode = NSLineBreakMode.ByWordWrapping
        personalInfoBawahanName.numberOfLines = 0
        personalInfoBawahanName.font = personalInfoBawahanName.font.fontWithSize(CGFloat(ratioHeight * 14))
        personalInfoBawahanName.sizeToFit()
        
    }
    
}
