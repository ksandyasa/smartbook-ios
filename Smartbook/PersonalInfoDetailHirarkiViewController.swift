//
//  PersonalInfoDetailHirarkiViewController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 9/4/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire

class PersonalInfoDetailHirarkiViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var personalPict: UIImageView!
    @IBOutlet weak var personalAtasanPict: UIImageView!
    @IBOutlet weak var personalNamaAtasan: UILabel!
    @IBOutlet weak var personalBawahan: UICollectionView!
    @IBOutlet weak var personalRekan: UICollectionView!
    let cellIdentifierRekan: String! = "personalInfoRekanCell"
    let cellIdentifierBawahan: String! = "personalInfoBawahanCell"
    var ratioWidth: CGFloat = 0.0
    var ratioHeight: CGFloat = 0.0
    var infoDetailNpp: String! = ""
    var infoDetailNppAtasan: String! = ""
    var infoDetailNamaAtasan: String! = ""
    var infoDetailUrlAtasan: String! = ""
    var infoDetailUrl: String = ""
    var infoDetailRekan: Array<AnyObject>! = []
    var infoDetailBawahan: Array<AnyObject>! = []
    weak var personalInfoDetailDelegate: PersonalInfoListDetailViewController!
    @IBOutlet weak var personalAtasanPictWidth: NSLayoutConstraint!
    @IBOutlet weak var personalAtasanPictHeight: NSLayoutConstraint!
    @IBOutlet weak var personalPictWidth: NSLayoutConstraint!
    @IBOutlet weak var personalPictHeight: NSLayoutConstraint!
    @IBOutlet weak var personalBawahanHeight: NSLayoutConstraint!
    @IBOutlet weak var personalRekanWidth: NSLayoutConstraint!
    @IBOutlet weak var personalRekanHeight: NSLayoutConstraint!
    @IBOutlet weak var personalInfoRekanLine: UILabel!
    @IBOutlet weak var personalInfoAtasanLine: UILabel!
    @IBOutlet weak var personalInfoBawahanLine: UILabel!
    @IBOutlet weak var personalInfoBawahanWidth: NSLayoutConstraint!
    @IBOutlet weak var personalInfoRekanLeft: NSLayoutConstraint!
    @IBOutlet weak var personalInfoBawahanBottom: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        personalRekan.registerNib(UINib(nibName: "PersonalInfoRekanCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifierRekan)
        personalBawahan.registerNib(UINib(nibName: "PersonalInfoBawahanCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifierBawahan)
        
        personalRekan.delegate = self
        personalRekan.dataSource = self
        
        personalBawahan.delegate = self
        personalBawahan.dataSource = self
        personalBawahan.contentInset = UIEdgeInsets(top: 1.25, left: 1.25, bottom: 1.25, right: 1.25)
        
        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupRatioWidthAndHeightBasedOnDeviceScreen(orientation: Bool) {
        ratioWidth = (orientation == true) ? SmartbookUtility.setupRatioWidthBasedOnLandscape() : SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = (orientation == true) ? SmartbookUtility.setupRatioHeightBasedOnLandscape() : SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
                
        print("%@", self.view.frame.size.height)
        
        personalRekan.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(personalRekan.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        if (ratioWidth < 1) {
            personalInfoRekanLeft.constant = 8.0
        }
        personalBawahan.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(personalBawahan.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        personalInfoBawahanWidth.constant = (ratioWidth <= 0.42) ? personalInfoBawahanWidth.constant - 160 : (ratioWidth > 0.42 && ratioWidth <= 0.48) ? personalInfoBawahanWidth.constant - 120 : (ratioWidth > 0.48 && ratioWidth <= 0.54) ? personalInfoBawahanWidth.constant - 80 : personalInfoBawahanWidth.constant
        personalInfoBawahanBottom.constant = 8.0
        
        personalRekanHeight.constant = ratioHeight * personalRekanHeight.constant
        
        personalAtasanPictHeight.constant = (ratioHeight <= 0.56) ? personalAtasanPictHeight.constant - 24 : (ratioHeight > 0.56 && ratioHeight <= 0.65) ? personalAtasanPictHeight.constant - 16 : (ratioHeight > 0.65 && ratioHeight <= 0.72) ? personalAtasanPictHeight.constant - 8 : personalAtasanPictHeight.constant
        personalAtasanPictWidth.constant = personalAtasanPictHeight.constant
        let cornerRadiusAtasan = personalAtasanPictHeight.constant
        personalAtasanPict.layer.cornerRadius = cornerRadiusAtasan / 2
        personalAtasanPict.layer.masksToBounds = true
        
        personalPictHeight.constant = (ratioHeight <= 0.56) ? personalPictHeight.constant - 24 : (ratioHeight > 0.56 && ratioHeight <= 0.65) ? personalPictHeight.constant - 16 : (ratioHeight > 0.65 && ratioHeight <= 0.72) ? personalPictHeight.constant - 8 : personalPictHeight.constant
        personalPictWidth.constant = personalPictHeight.constant
        let cornerRadius = personalPictHeight.constant
        personalPict.layer.cornerRadius = cornerRadius / 2
        personalPict.layer.masksToBounds = true
        
        personalNamaAtasan.lineBreakMode = NSLineBreakMode.ByWordWrapping
        personalNamaAtasan.numberOfLines = 0
        personalNamaAtasan.font = personalNamaAtasan.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 19)
        personalNamaAtasan.sizeToFit()
        personalNamaAtasan.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(personalNamaAtasan.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)

        self.setupInfoDetailItems()
        setupInfoDetailBawahanItems()
    }
    
    func setupInfoDetailBawahanItems() {
        let params = [
            "npp" : SmartbookUtility.getUserDefaults().valueForKey("prefPersonalNpp") as! String,
            "api_token" : SmartbookUtility.getUserDefaults().valueForKey("prefApiKey") as! String,
            "nppreq" : infoDetailNpp
        ]
        
        Alamofire.request(.POST, ConstantAPI.getBawahanInfoURL(), parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.infoDetailBawahan = JSON["data"] as? Array<AnyObject>
                    UIView.transitionWithView(self.personalBawahan, duration: 0.325, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                        }, completion: { (finished: Bool) -> () in
                            if (self.infoDetailBawahan.count > 0) {
                                self.personalBawahan.reloadData()
                                self.personalBawahan.hidden = false
                                self.personalInfoBawahanLine.hidden = false
                            }else{
                                self.personalBawahan.hidden = true
                                self.personalInfoBawahanLine.hidden = true
                            }
                    })
                }
        }
    }
    
    func setupPersonalInfoIcons(imageIcon: UIImageView, urlString: String) {
        Alamofire.request(.GET, urlString,
            parameters: nil)
            .responseJSON { response in
                
                let tempImage = UIImage(data: response.data!)
                if (tempImage != nil) {
                    imageIcon.image = SmartbookUtility.cropImageToWidth(tempImage!, width: (tempImage?.size.width)!, height: (tempImage?.size.width)!)
                }
        }
    }
    
    func setupInfoDetailItems() {
        self.setupPersonalInfoIcons(personalPict, urlString: infoDetailUrl)
        if (infoDetailNppAtasan != "") {
            self.setupPersonalInfoIcons(personalAtasanPict, urlString: infoDetailUrlAtasan)
            personalAtasanPict.hidden = false
            personalNamaAtasan.hidden = false
            personalInfoAtasanLine.hidden = false
        }else{
            personalAtasanPict.hidden = true
            personalNamaAtasan.hidden = true
            personalInfoAtasanLine.hidden = true
        }
        //print(infoDetailNamaAtasan)
        personalNamaAtasan.text = infoDetailNamaAtasan
        let tapAtasan = UITapGestureRecognizer(target: self, action: #selector(PersonalInfoDetailHirarkiViewController.actionFromAtasanPictClick(_:)))
        personalAtasanPict.addGestureRecognizer(tapAtasan)
        
        if (self.infoDetailRekan.count > 0) {
            var removeIndeks: Int = 0
            for i in 0...self.infoDetailRekan.count-1 {
                if (self.infoDetailNpp == String(format: "%@", self.infoDetailRekan[i]["ASSIGNMENT_NUMBER"] as! String)) {
                    removeIndeks = i
                }
            }
            self.infoDetailRekan.removeAtIndex(removeIndeks)
            self.personalRekan.reloadData()
            self.personalInfoRekanLine.hidden = false
            self.personalRekan.hidden = false
        }else{
            self.personalInfoRekanLine.hidden = true
            self.personalRekan.hidden = true
        }
    }
    
    func actionFromAtasanPictClick(sender: UITapGestureRecognizer) {
        print("Action Clicked")
        personalInfoDetailDelegate.personalNpp = infoDetailNppAtasan
        personalInfoDetailDelegate.setupDetailPersonalInfoItems(personalInfoDetailDelegate.personalNpp)
    }
    
    /*
    // MARK - UICollectionView Delegate
    */
    
    // UICollection View Delegate Method
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (collectionView == self.personalRekan) ? infoDetailRekan.count : infoDetailBawahan.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        if (collectionView == self.personalRekan) {
            let itemCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifierRekan, forIndexPath: indexPath) as! PersonalInfoRekanCell
            
            if (infoDetailRekan.count > 0) {
                if (infoDetailRekan[indexPath.row]["urlfoto"] is NSNull) {
                    let urlRekan = (infoDetailRekan[0]["SEX"] as? String == "M") ?
                        String(format: "%@/%@", ConstantAPI.getImageBaseURL(), "img/avatarM.png") : String(format: "%@/%@", ConstantAPI.getImageBaseURL(), "img/avatarF.png")
                    self.setupPersonalInfoIcons(itemCell.personalInfoRekanPict, urlString: urlRekan)
                }else{
                    let urlRekan = String(format: "%@/%@", ConstantAPI.getImageBaseURL(), infoDetailRekan[indexPath.row]["urlfoto"] as! String)
                    self.setupPersonalInfoIcons(itemCell.personalInfoRekanPict, urlString: urlRekan)
                }
            }
            
            return itemCell
        }else{
            let itemCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifierBawahan, forIndexPath: indexPath) as! PersonalInfoBawahanCell
            
            if (infoDetailBawahan.count > 0) {
                if (infoDetailBawahan[indexPath.row]["urlfoto"] is NSNull) {
                    let urlBawahan = (infoDetailBawahan[0]["SEX"] as? String == "M") ?
                    String(format: "%@/%@", ConstantAPI.getImageBaseURL(), "img/avatarM.png") : String(format: "%@/%@", ConstantAPI.getImageBaseURL(), "img/avatarF.png")
                    self.setupPersonalInfoIcons(itemCell.personalInfoBawahanPict, urlString: urlBawahan)
                }else{
                    let urlBawahan = String(format: "%@/%@", ConstantAPI.getImageBaseURL(), infoDetailBawahan[indexPath.row]["urlfoto"] as! String)
                    self.setupPersonalInfoIcons(itemCell.personalInfoBawahanPict, urlString: urlBawahan)
                }
                itemCell.personalInfoBawahanName.text = String(format: "%@", infoDetailBawahan[indexPath.row]["LAST_NAME"] as! String)
            }
            
            return itemCell

        }
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return (collectionView == self.personalRekan) ? CGSizeMake(ratioWidth * 72, ratioHeight * 72) : CGSizeMake(ratioWidth * 100, ratioHeight * 85)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var nppPersonal: String = ""
        if (collectionView == self.personalRekan) {
            nppPersonal = String(format: "%@", infoDetailRekan[indexPath.row]["ASSIGNMENT_NUMBER"] as! String)
        }else{
            nppPersonal = String(format: "%@", infoDetailBawahan[indexPath.row]["ASSIGNMENT_NUMBER"] as! String)
        }
        personalInfoDetailDelegate.personalNpp = nppPersonal
        personalInfoDetailDelegate.setupDetailPersonalInfoItems(personalInfoDetailDelegate.personalNpp)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
