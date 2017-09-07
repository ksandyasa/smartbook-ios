//
//  PersonalInfoDetailDataCell.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 9/22/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit

class PersonalInfoDetailDataCell: UITableViewCell {

    @IBOutlet weak var tInfoDetail: UILabel!
    @IBOutlet weak var vInfoDetail: UILabel!
    @IBOutlet weak var tKantorDetail: UILabel!
    @IBOutlet weak var vKantorDetail: UILabel!
    @IBOutlet weak var tAgamaDetail: UILabel!
    @IBOutlet weak var vAgamaDetail: UILabel!
    @IBOutlet weak var tTtlDetail: UILabel!
    @IBOutlet weak var vTtlDetail: UILabel!
    @IBOutlet weak var tAlamatDetail: UILabel!
    @IBOutlet weak var vAlamatDetail: UILabel!
    @IBOutlet weak var tTelpDetail: UILabel!
    @IBOutlet weak var vTelpDetail: UILabel!
    var ratioWidth: CGFloat! = 0.0
    var ratioHeight: CGFloat! = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.setupRatioWidthAndHeightBasedOnDeviceScreen()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupRatioWidthAndHeightBasedOnDeviceScreen() {
        ratioWidth = SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
        
        tInfoDetail.lineBreakMode = NSLineBreakMode.ByWordWrapping
        tInfoDetail.numberOfLines = 0
        tInfoDetail.font = tInfoDetail.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 20)
        tInfoDetail.sizeToFit()
        
        vInfoDetail.lineBreakMode = NSLineBreakMode.ByWordWrapping
        vInfoDetail.numberOfLines = 0
        vInfoDetail.font = vInfoDetail.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 18)
        vInfoDetail.sizeToFit()
        
        tKantorDetail.lineBreakMode = NSLineBreakMode.ByWordWrapping
        tKantorDetail.numberOfLines = 0
        tKantorDetail.font = tKantorDetail.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 20)
        tKantorDetail.sizeToFit()
        
        vKantorDetail.lineBreakMode = NSLineBreakMode.ByWordWrapping
        vKantorDetail.numberOfLines = 0
        vKantorDetail.font = vKantorDetail.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 18)
        vKantorDetail.sizeToFit()
        
        tAgamaDetail.lineBreakMode = NSLineBreakMode.ByWordWrapping
        tAgamaDetail.numberOfLines = 0
        tAgamaDetail.font = tAgamaDetail.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 20)
        tAgamaDetail.sizeToFit()
        
        vAgamaDetail.lineBreakMode = NSLineBreakMode.ByWordWrapping
        vAgamaDetail.numberOfLines = 0
        vAgamaDetail.font = vAgamaDetail.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 18)
        vAgamaDetail.sizeToFit()
        
        tTtlDetail.lineBreakMode = NSLineBreakMode.ByWordWrapping
        tTtlDetail.numberOfLines = 0
        tTtlDetail.font = tTtlDetail.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 20)
        tTtlDetail.sizeToFit()
        
        vTtlDetail.lineBreakMode = NSLineBreakMode.ByWordWrapping
        vTtlDetail.numberOfLines = 0
        vTtlDetail.font = vTtlDetail.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 18)
        vTtlDetail.sizeToFit()
        
        tAgamaDetail.lineBreakMode = NSLineBreakMode.ByWordWrapping
        tAgamaDetail.numberOfLines = 0
        tAgamaDetail.font = tAgamaDetail.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 20)
        tAgamaDetail.sizeToFit()
        
        vAgamaDetail.lineBreakMode = NSLineBreakMode.ByWordWrapping
        vAgamaDetail.numberOfLines = 0
        vAgamaDetail.font = vAgamaDetail.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 18)
        vAgamaDetail.sizeToFit()
        
        tAlamatDetail.lineBreakMode = NSLineBreakMode.ByWordWrapping
        tAlamatDetail.numberOfLines = 0
        tAlamatDetail.font = tAlamatDetail.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 20)
        tAlamatDetail.sizeToFit()
        
        vAlamatDetail.lineBreakMode = NSLineBreakMode.ByWordWrapping
        vAlamatDetail.numberOfLines = 0
        vAlamatDetail.font = vAlamatDetail.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 18)
        vAlamatDetail.sizeToFit()
        
        tTelpDetail.lineBreakMode = NSLineBreakMode.ByWordWrapping
        tTelpDetail.numberOfLines = 0
        tTelpDetail.font = tTelpDetail.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 20)
        tTelpDetail.sizeToFit()
        
        vTelpDetail.lineBreakMode = NSLineBreakMode.ByWordWrapping
        vTelpDetail.numberOfLines = 0
        vTelpDetail.font = vTelpDetail.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 18)
        vTelpDetail.sizeToFit()
        
        tInfoDetail.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(tInfoDetail.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        vInfoDetail.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(vInfoDetail.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        tKantorDetail.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(tKantorDetail.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        vKantorDetail.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(vKantorDetail.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        tAgamaDetail.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(tAgamaDetail.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        vAgamaDetail.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(vAgamaDetail.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        tTtlDetail.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(tTtlDetail.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        vTtlDetail.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(vTtlDetail.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        tAlamatDetail.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(tAlamatDetail.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        vAlamatDetail.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(vAlamatDetail.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        tTelpDetail.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(tTelpDetail.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        vTelpDetail.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(vTelpDetail.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
    }
        
}
