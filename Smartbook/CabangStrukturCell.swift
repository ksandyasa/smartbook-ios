//
//  CabangStrukturCell.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 10/11/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire

class CabangStrukturCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var cabangStrukturPict: UIImageView!
    @IBOutlet weak var cabangStrukturName: UILabel!
    @IBOutlet weak var cabangStrukturBorder: UILabel!
    @IBOutlet weak var cabangStrukturBawahan: UICollectionView!
    @IBOutlet weak var cabangStrukturPictWidth: NSLayoutConstraint!
    @IBOutlet weak var cabangStrukturPictHeight: NSLayoutConstraint!
    @IBOutlet weak var cabangStrukturBawahanHeight: NSLayoutConstraint!
    weak var cabangStrukturCellDelegate: CabangStrukturController!
    var ratioWidth: CGFloat! = 0.0
    var ratioHeight: CGFloat! = 0.0
    var infoDetailNpp: String! = ""
    var infoDetailNama: String! = ""
    var infoDetailBawahan: Array<AnyObject>! = []
    let cellBawahanIdentifier: String! = "cabangStrukturBawahanCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cabangStrukturBawahan.registerNib(UINib(nibName: "CabangStrukturBawahanCell", bundle: nil), forCellWithReuseIdentifier: cellBawahanIdentifier)
        cabangStrukturBawahan.delegate = self
        cabangStrukturBawahan.dataSource = self
        cabangStrukturBawahan.contentInset = UIEdgeInsets(top: 1.25, left: 1.25, bottom: 1.25, right: 1.25)

        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupRatioWidthAndHeightBasedOnDeviceScreen(orientation: Bool) {
        ratioWidth = (orientation == true) ? SmartbookUtility.setupRatioWidthBasedOnLandscape() : SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = (orientation == true) ? SmartbookUtility.setupRatioHeightBasedOnLandscape() : SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
        
        cabangStrukturPictHeight.constant = ratioHeight * cabangStrukturPictHeight.constant
        cabangStrukturPictWidth.constant = cabangStrukturPictHeight.constant
        let cornerRadius = cabangStrukturPictHeight.constant
        cabangStrukturPict.layer.cornerRadius = cornerRadius / 2
        cabangStrukturPict.layer.masksToBounds = true
        
        cabangStrukturName.text = ""
        cabangStrukturName.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cabangStrukturName.numberOfLines = 0
        cabangStrukturName.font = cabangStrukturName.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 22)
        cabangStrukturName.sizeToFit()
        
        cabangStrukturBawahan.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(cabangStrukturBawahan.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        
        cabangStrukturBawahanHeight.constant = ratioHeight * cabangStrukturBawahanHeight.constant
        cabangStrukturBawahan.backgroundColor = UIColor.clearColor()
        cabangStrukturBawahan.backgroundView = nil
    }
    
    func setupCabangStrukturViews() {
        self.setupCabangStrukturBawahanItems()
    }
    
    func setupCabangStrukturBawahanPict(imageIcon: UIImageView, urlString: String) {
        Alamofire.request(.GET, urlString,
            parameters: nil)
            .responseJSON { response in
                
                let tempImage = UIImage(data: response.data!)
                if (tempImage != nil) {
                    imageIcon.image = SmartbookUtility.cropImageToWidth(tempImage!, width: (tempImage?.size.width)!, height: (tempImage?.size.width)!)
                }
        }
    }
    
    func setupCabangStrukturBawahanItems() {
        let params = [
            "npp" : SmartbookUtility.getUserDefaults().valueForKey("prefPersonalNpp") as! String,
            "api_token" : SmartbookUtility.getUserDefaults().valueForKey("prefApiKey") as! String,
            "nppreq" : infoDetailNpp
        ]
        
        Alamofire.request(.POST, ConstantAPI.getBawahanInfoURL(), parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.infoDetailBawahan = JSON["data"] as? Array<AnyObject>
                    UIView.transitionWithView(self.cabangStrukturBawahan, duration: 0.325, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                        if (self.infoDetailBawahan.count > 0) {
                            //print(self.infoDetailBawahan.description)
                            self.cabangStrukturBawahan.reloadData()
                        }
                        }, completion: { (finished: Bool) -> () in
                            let tapPersonalInfo = UITapGestureRecognizer(target: self, action: #selector(CabangStrukturCell.actionClick(_:)))
                            self.cabangStrukturPict.addGestureRecognizer(tapPersonalInfo)

                    })
                }
        }
    }
    
    func actionClick(sender: UITapGestureRecognizer) {
        cabangStrukturCellDelegate.actionClickFromCabangStrukturCell(infoDetailNama)
    }
    
    // UICollection View Delegate Method
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infoDetailBawahan.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let itemCell = cabangStrukturBawahan.dequeueReusableCellWithReuseIdentifier(cellBawahanIdentifier, forIndexPath: indexPath) as! CabangStrukturBawahanCell
        
        if (infoDetailBawahan.count > 0) {
            let urlImage = String(format: "%@/%@", ConstantAPI.getImageBaseURL(), infoDetailBawahan[indexPath.row]["urlfoto"] as! String)
            self.setupCabangStrukturBawahanPict(itemCell.cabangBawahanPict, urlString: urlImage)

            itemCell.cabangBawahanName.text = String(format: "%@", infoDetailBawahan[indexPath.row]["LAST_NAME"] as! String)
        }
        
        itemCell.backgroundColor = UIColor.clearColor()
        itemCell.backgroundView = nil
        
        return itemCell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(ratioWidth * 152, ratioHeight * 171)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let nppPersonal = String(format: "%@", infoDetailBawahan[indexPath.row]["LAST_NAME"] as! String)
        cabangStrukturCellDelegate.actionClickFromCabangStrukturCell(nppPersonal)

    }

}
