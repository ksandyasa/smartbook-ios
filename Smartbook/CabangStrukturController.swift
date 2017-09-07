//
//  CabangStrukturController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 10/11/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import Alamofire

class CabangStrukturController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var cabangStrukturHeader: UIView!
    @IBOutlet weak var cabangStrukturTitle: UILabel!
    @IBOutlet weak var cabangStrukturClose: UIButton!
    @IBOutlet weak var cabangStrukturBg: UIImageView!
    @IBOutlet weak var cabangStrukturList: UITableView!
    @IBOutlet weak var cabangStrukturHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var cabangStrukturCloseHeight: NSLayoutConstraint!
    @IBOutlet weak var cabangStrukturCloseWidth: NSLayoutConstraint!
    var ratioWidth: CGFloat! = 0.0
    var ratioHeight: CGFloat! = 0.0
    var cellIdentifier: String! = "cabangStrukturCell"
    var infoDetail: Array<AnyObject>! = []
    var infoDetailNpp: String! = "";
    var infoDetailNama: String! = ""
    var infoDetailUrl: String! = ""
    var infoDetailBawahan: Array<AnyObject>! = []
    weak var cabangStrukturDelegate: DashboardViewController!
    var mainContentItems: Array<AnyObject>! = []
    var mainContentIndeks: Int!
    var mainMenuItems: Array<AnyObject>! = []
    var mainMenuIndeks: Int!
    var kantorItems: Array<AnyObject>! = []
    var kantorItemsIndeks: Int!
    var mainContentPopupItems: Array<AnyObject>! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cabangStrukturList.registerNib(UINib(nibName: "CabangStrukturCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        cabangStrukturList.dataSource = self
        cabangStrukturList.delegate = self
        cabangStrukturList.tableFooterView = UIView(frame: CGRectZero)
        
        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupRatioWidthAndHeightBasedOnDeviceScreen(orientation: Bool) {
        ratioWidth = (orientation == true) ? SmartbookUtility.setupRatioWidthBasedOnLandscape() : SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = (orientation == true) ? SmartbookUtility.setupRatioHeightBasedOnLandscape() : SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
        
        self.view.bounds.size.width = (orientation == true) ? ratioWidth * 1024 : ratioWidth * 768
        self.view.bounds.size.height = (orientation == true) ? ratioHeight * 768 : ratioHeight * 1024
        
        cabangStrukturHeader.bounds.size.width = self.view.bounds.size.width
        cabangStrukturHeaderHeight.constant = 44.0
        
        self.setupCabangStrukturHeaderWithGradientColor("0D7BD4")
        
        cabangStrukturTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cabangStrukturTitle.numberOfLines = 0
        cabangStrukturTitle.font = cabangStrukturTitle.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 22)
        cabangStrukturTitle.sizeToFit()
        
        cabangStrukturTitle.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(cabangStrukturTitle.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        
        cabangStrukturBg.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(cabangStrukturBg.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        
        cabangStrukturList.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(cabangStrukturList.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        cabangStrukturList.backgroundColor = UIColor.clearColor()
        cabangStrukturList.backgroundView = nil
        
        cabangStrukturClose.addTarget(self, action: #selector(MainContentPopupViewController.dismissOPan), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.setNeedsUpdateConstraints()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        self.setupCabangStrukturItems()
    }
    
    func setupCabangStrukturHeaderWithGradientColor(color: String) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = cabangStrukturHeader.bounds
        gradient.colors = [SmartbookUtility.colorWithHexString("0D7BD4").CGColor,
                           SmartbookUtility.colorWithHexString("3FAED6").CGColor,
                           SmartbookUtility.colorWithHexString("0D7BD4").CGColor]
        cabangStrukturHeader.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    func setupCabangStrukturPict(imageIcon: UIImageView, urlString: String) {
        Alamofire.request(.GET, urlString,
            parameters: nil)
            .responseJSON { response in
                
                let tempImage = UIImage(data: response.data!)
                if (tempImage != nil) {
                    imageIcon.image = SmartbookUtility.cropImageToWidth(tempImage!, width: (tempImage?.size.width)!, height: (tempImage?.size.width)!)
                }
        }
    }
    
    func setupCabangStrukturItems() {
        let mainMenuId = String(format: "%d", mainMenuItems[mainMenuIndeks]["id"] as! Int)
        let subMenuId = String(format: "%d", mainContentItems[mainContentIndeks]["id"] as! Int)
        let kantorId = String(format: "%d", kantorItems[kantorItemsIndeks]["kantor_id"] as! Int)
        let urlContent = ConstantAPI.getCabangURL()
        
        let params = [
            "mainmenu_id" : mainMenuId,
            "menu_id": subMenuId,
            "kantor_id" : kantorId,
            "npp" : SmartbookUtility.getUserDefaults().valueForKey("prefPersonalNpp") as! String,
            "api_token" : SmartbookUtility.getUserDefaults().valueForKey("prefApiKey") as! String
        ]
        
        Alamofire.request(.POST, urlContent,
            parameters: params)
            .responseJSON { response in
                print(response.request)
                if let JSON = response.result.value {
                    self.mainContentPopupItems = JSON["data"] as? Array<AnyObject>
                    print(self.mainContentPopupItems)
                    self.infoDetailNpp = String(format: "%@", self.mainContentPopupItems[0]["npp"] as! String)
                    print(self.infoDetailNpp)
                    self.setupInfoDetailItems(self.infoDetailNpp)

                }
        }
    }
    
    func setupInfoDetailItems(npp: String) {
        let params = [
            "npp" : SmartbookUtility.getUserDefaults().valueForKey("prefPersonalNpp") as! String,
            "api_token" : SmartbookUtility.getUserDefaults().valueForKey("prefApiKey") as! String,
            "nppreq" : npp
        ]
        
        Alamofire.request(.POST, ConstantAPI.getAtasanInfoURL(), parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.infoDetail = JSON["data"] as? Array<AnyObject>
                    //print("infoDetail : ", self.infoDetail.description)
                    UIView.transitionWithView(self.cabangStrukturList, duration: 0.325, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                        if (self.infoDetail != nil) {
                            self.infoDetailNpp = String(format: "%@", self.infoDetail[0]["ASSIGNMENT_NUMBER"] as! String)
                            self.infoDetailNama = String(format: "%@", self.infoDetail[0]["LAST_NAME"] as! String)
                            self.infoDetailUrl = String(format: "%@/%@", ConstantAPI.getImageBaseURL(), self.infoDetail[0]["urlfoto"] as! String)
                            self.cabangStrukturTitle.text = self.mainContentItems[self.mainContentIndeks]["nama"] as? String
                            self.cabangStrukturList.reloadData()
                        }
                        }, completion: { (finished: Bool) -> () in
                            self.cabangStrukturDelegate.dismissDashboardIndicatorView()
                    })
                }
        }
    }
    
    func dismissOPan() {
        cabangStrukturDelegate.dismissViewControllerAnimated(true, completion: { Void in
            self.cabangStrukturDelegate.cabangStrukturController = nil
        })
    }
        
    func actionClickFromCabangStrukturCell(npp: String) {
        cabangStrukturDelegate.setupPersonalInfoViewControllerFroMainContent(npp)
        cabangStrukturDelegate.dismissViewControllerAnimated(true, completion: { Void in
            self.cabangStrukturDelegate.cabangStrukturController = nil
        })
    }
    
    /*
     // MARK - UITableView Delegate Method
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (infoDetail != nil) ? 1 : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! CabangStrukturCell
        
        // Configure the cell...
        if (infoDetail != nil) {
            //print(self.infoDetailNama)
            //print(self.infoDetailUrl)
            cell.cabangStrukturCellDelegate = self
            cell.infoDetailNpp = infoDetailNpp
            cell.infoDetailNama = infoDetailNama
            self.setupCabangStrukturPict(cell.cabangStrukturPict, urlString: infoDetailUrl)
            cell.cabangStrukturName.text = infoDetailNama
            cell.setupCabangStrukturViews()
        }
        
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = nil
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 440.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return ((ratioHeight <= 0.56) ? 260.0 : (ratioHeight > 0.56 && ratioHeight <= 0.65) ? 280.0 : (ratioHeight > 0.65 && ratioHeight <= 0.72) ? 305.0 : 440.0)
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
