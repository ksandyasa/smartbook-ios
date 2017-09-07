//
//  AnakContentBOCViewController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 9/15/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire
import QuartzCore

class AnakContentBOCViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var anakContentBOCHeader: UIView!
    @IBOutlet weak var anakContentBOCTitle: UILabel!
    @IBOutlet weak var anakContentBOCClose: UIButton!
    @IBOutlet weak var anakContentBOCList: UITableView!
    var ratioWidth: CGFloat! = 0.0
    var ratioHeight: CGFloat! = 0.0
    var cellIdentifier: String! = "anakContentBOCCell"
    weak var anakContentBOCDelegate: DashboardViewController!
    var anakContentBOCAlertController: UIAlertController!
    var mainContentItems: Array<AnyObject>! = []
    var mainContentIndeks: Int!
    var mainMenuItems: Array<AnyObject>! = []
    var mainMenuIndeks: Int!
    var kantorItems: Array<AnyObject>! = []
    var kantorItemsIndeks: Int!
    var anakContentBOCItems: Array<AnyObject>! = []
    var anakUrlImage: String! = ""
    @IBOutlet weak var anakContentBOCHeaderHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        anakContentBOCList.registerNib(UINib(nibName: "AnakContentBOCCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.setupWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
        
        anakContentBOCList.delegate = self
        anakContentBOCList.dataSource = self
        anakContentBOCList.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        anakContentBOCDelegate.dismissViewControllerAnimated(true, completion: { Void in
            let tempContentItems: Array<AnyObject> = self.mainContentItems
            let tempContentIndeks: Int = self.mainContentIndeks
            self.anakContentBOCDelegate.anakContentBOCController = nil
            self.anakContentBOCDelegate.showMainContentViewPopUp(tempContentItems, indeks: tempContentIndeks)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupWidthAndHeightBasedOnDeviceScreen(orientation: Bool) {
        ratioWidth = (orientation == true) ? SmartbookUtility.setupRatioWidthBasedOnLandscape() : SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = (orientation == true) ? SmartbookUtility.setupRatioHeightBasedOnLandscape() : SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
        
        self.view.bounds.size.width = (orientation == true) ? ratioWidth * 1024 : ratioWidth * 768
        self.view.bounds.size.height = (orientation == true) ? ratioHeight * 768 : ratioHeight * 1024

        anakContentBOCHeader.bounds.size.width = self.view.bounds.size.width
        anakContentBOCHeaderHeight.constant = 44.0
        
        self.setupAnakContentBOCHeaderWithGradientColor("0D7BD4")
        
        anakContentBOCTitle.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(anakContentBOCTitle.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        anakContentBOCTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        anakContentBOCTitle.numberOfLines = 0
        anakContentBOCTitle.font = anakContentBOCTitle.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 21)
        anakContentBOCTitle.sizeToFit()
        
        anakContentBOCClose.addTarget(self, action: #selector(AnakContentBOCViewController.dismissOPan), forControlEvents: UIControlEvents.TouchUpInside)
        
        anakContentBOCList.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(anakContentBOCList.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        
        self.view.setNeedsUpdateConstraints()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        self.setupAnakContentBOCItems()
    }
    
    func setupAnakContentBOCPict(imageIcon: UIImageView, urlString: String) {
        Alamofire.request(.GET, urlString,
            parameters: nil)
            .responseJSON { response in
                let tempImage = UIImage(data: response.data!)
                if (tempImage != nil) {
                    imageIcon.image = SmartbookUtility.cropImageToWidth(tempImage!, width: (tempImage?.size.width)!, height: (tempImage?.size.width)!)
                }
        }
    }
    
    func setupAnakContentBOCItems() {
        print("mainMenuItems = : ", mainMenuIndeks)
        print("mainMenuId = : ", (mainMenuItems[mainMenuIndeks]["id"] as? Int)!)
        print("mainContentIndeks = : ", mainContentIndeks)
        print("mainContentId = : ", (mainContentItems[mainContentIndeks]["id"] as? Int)!)
        print("kantorItemIndeks = : ", kantorItemsIndeks)
        print("kantorId = : ", (kantorItems[kantorItemsIndeks]["id"] as? Int)!)
        
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
                    self.anakContentBOCItems = JSON["data"] as! Array<AnyObject>
                    //print("tempArray : ", self.anakContentBOCItems.description)
                    self.setupAnakContentBOCView()
                }
                self.anakContentBOCDelegate.dismissDashboardIndicatorView()
        }
    }
    
    func setupAnakContentBOCView() {
        if (anakContentBOCItems.count > 0) {
            anakContentBOCList.reloadData()
        }
        anakContentBOCTitle.text = String(format: "%@", mainContentItems[mainContentIndeks]["nama"] as! String)
    }
    
    func setupAnakContentBOCPopupView(nama: String, jabatan: String, urlPict: String) {
        anakContentBOCAlertController = UIAlertController(title: nama,
                                                          message: "\n\n\n\n\n\n\n\n\n\n\n\n",
                                                          preferredStyle: .ActionSheet)
        
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            anakContentBOCAlertController.popoverPresentationController!.sourceView = self.view
            anakContentBOCAlertController.popoverPresentationController!.sourceRect = CGRectMake(self.view.bounds.size.width / 2, self.view.bounds.size.height, 1.0, 1.0)
        }
        
        let profilImage = UIImageView()
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            profilImage.frame = CGRectMake(55, 55, 190, 190)
        }else{
            profilImage.frame = CGRectMake(self.view.bounds.size.width / 2 - 105, anakContentBOCAlertController.view.bounds.size.height / 2 - 230, 190, 190)
        }

        profilImage.layer.cornerRadius = 10.0
        profilImage.layer.masksToBounds = true
        self.setupAnakContentBOCPict(profilImage, urlString: urlPict)
        
        anakContentBOCAlertController.view.addSubview(profilImage)

        let tutupAction = UIAlertAction(title: "Tutup", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in print("tutup")})
        anakContentBOCAlertController.addAction(tutupAction)
        
        self.presentViewController(anakContentBOCAlertController, animated: true, completion: nil)
    }
    
    func setupAnakContentBOCHeaderWithGradientColor(color: String) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = anakContentBOCHeader.bounds
        gradient.colors = [SmartbookUtility.colorWithHexString("0D7BD4").CGColor,
                           SmartbookUtility.colorWithHexString("3FAED6").CGColor,
                           SmartbookUtility.colorWithHexString("0D7BD4").CGColor]
        anakContentBOCHeader.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    func dismissOPan() {
        print("pan gesture")
        
        anakContentBOCDelegate.dismissViewControllerAnimated(true, completion: { Void in
            self.anakContentBOCDelegate.anakContentBOCController = nil
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
        print(anakContentBOCItems.count)
        return anakContentBOCItems.count
    }
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! AnakContentBOCCell
        
        if (anakContentBOCItems.count > 0) {
            if (anakUrlImage != String(format: "%@", anakContentBOCItems[indexPath.row]["photo"] as! String)) {
                anakUrlImage = String(format: "%@%@", ConstantAPI.getImageBaseURL(), anakContentBOCItems[indexPath.row]["photo"] as! String)
            }
            print("url : ", anakUrlImage)
            self.setupAnakContentBOCPict(cell.itemAnakBOCPict, urlString: anakUrlImage.stringByReplacingOccurrencesOfString("\n", withString: ""))
            cell.itemAnakBOCName.text = String(format: "%@", anakContentBOCItems[indexPath.row]["Nama"] as! String)
            cell.itemAnakBOCJabatan.text = String(format: "%@", anakContentBOCItems[indexPath.row]["Jabatan"] as! String)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ratioHeight * 95.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("presenting BOC Popup")
        let anakJabatan = String(format: "%@", anakContentBOCItems[indexPath.row]["Jabatan"] as! String)
        let anakUrlPict = String(format: "%@%@", ConstantAPI.getImageBaseURL(), anakContentBOCItems[indexPath.row]["photo"] as! String)
        let anakName = String(format: "%@", anakContentBOCItems[indexPath.row]["Nama"] as! String)
        self.setupAnakContentBOCPopupView(anakName, jabatan: anakJabatan, urlPict: anakUrlPict.stringByReplacingOccurrencesOfString("\n", withString: ""))
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
