//
//  PersonalInfoListDetailViewController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 9/21/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import Alamofire

class PersonalInfoListDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var personalInfoListDetail: UITableView!
    var cellIdentifier: String! = "personalInfoDetailDataCell"
    var cellHirarkiidentifier: String! = "personalInfoDetailHirarkiCell"
    var ratioWidth: CGFloat! = 0.0
    var ratioHeight: CGFloat! = 0.0
    var personalNpp: String! = ""
    var personalNppAtasan: String! = ""
    var personalNamaAtasan: String! = ""
    var personalUrl: String! = ""
    var personalUrlAtasan: String! = ""
    var personalInfoDetail: Array<AnyObject>! = []
    var personalInfoDetailAtasan: Array<AnyObject>! = []
    var personalInfoDetailRekan: Array<AnyObject>! = []
    var personalInfoDetailBawahan: Array<AnyObject>! = []
    var stringInfo: String! = ""
    var stringKantor: String! = ""
    var stringAgama: String! = ""
    var stringTtl: String! = ""
    var stringAlamat: String! = ""
    var stringTelp: String! = ""
    var headerView: PersonalInfoDetailHeader!
    weak var personalInfoListDetailDelegate: PersonalInfoListViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        personalInfoListDetail.registerNib(UINib(nibName: "PersonalInfoDetailDataCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        personalInfoListDetail.registerNib(UINib(nibName: "PersonalInfoDetailHirarkiCell", bundle: nil), forCellReuseIdentifier: cellHirarkiidentifier)
        personalInfoListDetail.delegate = self
        personalInfoListDetail.dataSource = self

        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        personalInfoListDetail.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupRatioWidthAndHeightBasedOnDeviceScreen(orientation: Bool) {
        ratioWidth = (orientation == true) ? SmartbookUtility.setupRatioWidthBasedOnLandscape() : SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = (orientation == true) ? SmartbookUtility.setupRatioHeightBasedOnLandscape() : SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
                
        personalInfoListDetail.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(personalInfoListDetail.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.setupDetailPersonalInfoItems(personalNpp)
    }
    
    func setupPersonalInfoDetailHeader(personalInfoDetail: Array<AnyObject>) {
        if (headerView != nil) {
            headerView.removeFromSuperview()
            headerView = nil
        }
        let className = String(PersonalInfoDetailHeader.self)
        let nibViews = NSBundle.mainBundle().loadNibNamed(className, owner: self, options: nil)
        headerView = nibViews!.first as? PersonalInfoDetailHeader
        headerView.personalInfoDetailHeaderDelegate = self
        headerView.personalInfoDetail = personalInfoDetail
        headerView.setupPersonalInfoDetailView()
        personalInfoListDetail.addSubview(headerView)
    }
        
    func dismissPersonalInfoDetailFromHeader() {
        headerView.removeFromSuperview()
        headerView = nil
        personalInfoListDetailDelegate.dismissPersonalInfoListDetail()
    }
    
    func setupDetailPeerInfoItems(npp: String) {
        let params = [
            "npp" : SmartbookUtility.getUserDefaults().valueForKey("prefPersonalNpp") as! String,
            "api_token" : SmartbookUtility.getUserDefaults().valueForKey("prefApiKey") as! String,
            "nppreq" : npp
        ]
        
        Alamofire.request(.POST, ConstantAPI.getPeerInfoURL(), parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.personalInfoDetailRekan = JSON["data"] as? Array<AnyObject>
                    //print("personalInfoDetailRekan : ", self.personalInfoDetailRekan.description)
                    self.personalInfoListDetail.reloadData()
                }
                
        }
    }
    
    func setupDetailAtasanInfoItems(npp: String) {
        let params = [
            "npp" : SmartbookUtility.getUserDefaults().valueForKey("prefPersonalNpp") as! String,
            "api_token" : SmartbookUtility.getUserDefaults().valueForKey("prefApiKey") as! String,
            "nppreq" : npp
        ]
        
        Alamofire.request(.POST, ConstantAPI.getAtasanInfoURL(), parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.personalInfoDetailAtasan = JSON["data"] as? Array<AnyObject>
                    //print("personalInfoDetailAtasan : ", self.personalInfoDetailAtasan.description)
                    if (self.personalInfoDetailAtasan.count > 0) {
                        self.personalNamaAtasan = String(format: "%@", self.personalInfoDetailAtasan[0]["LAST_NAME"] as! String)
                        if (self.personalInfoDetailAtasan[0]["urlfoto"] is NSNull) {
                            self.personalUrlAtasan = (self.personalInfoDetailAtasan[0]["SEX"] as? String == "M") ?
                                String(format: "%@/%@", ConstantAPI.getImageBaseURL(), "img/avatarM.png") : String(format: "%@/%@", ConstantAPI.getImageBaseURL(), "img/avatarF.png")
                        }else{
                            self.personalUrlAtasan = String(format: "%@/%@", ConstantAPI.getImageBaseURL(), self.personalInfoDetailAtasan[0]["urlfoto"] as! String)
                        }
                        self.setupDetailPeerInfoItems(self.personalNppAtasan)
                    }
                }
                
        }
    }
        
    func setupDetailPersonalInfoItems(npp: String) {
        personalInfoDetailAtasan.removeAll()
        personalInfoDetailRekan.removeAll()
        personalInfoDetailBawahan.removeAll()
        
        let params = [
            "npp" : SmartbookUtility.getUserDefaults().valueForKey("prefPersonalNpp") as! String,
            "api_token" : SmartbookUtility.getUserDefaults().valueForKey("prefApiKey") as! String,
            "nppreq" : npp
        ]
        
        Alamofire.request(.POST, ConstantAPI.getAtasanInfoURL(), parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.personalInfoDetail = JSON["data"] as? Array<AnyObject>
                    //print("personalInfoDetail : ", self.personalInfoDetail.description)
                    UIView.animateWithDuration(0.150, delay: 0, options: .TransitionCrossDissolve, animations: { () -> Void in
                        self.setupPersonalInfoDetailHeader(self.personalInfoDetail)
                        }, completion: { (finished: Bool) -> () in
                            if (self.personalInfoDetail != nil) {
                                if (self.personalInfoDetail[0]["urlfoto"] is NSNull) {
                                    self.personalUrl = (self.personalInfoDetail[0]["SEX"] as? String == "M") ?
                                        String(format: "%@/%@", ConstantAPI.getImageBaseURL(), "img/avatarM.png") : String(format: "%@/%@", ConstantAPI.getImageBaseURL(), "img/avatarF.png")
                                }else{
                                    self.personalUrl = String(format: "%@/%@", ConstantAPI.getImageBaseURL(), self.personalInfoDetail[0]["urlfoto"] as! String)
                                }
                                let gender = (self.personalInfoDetail[0]["SEX"] as! String == "M") ? "Laki-laki" : "Perempuan"
                                let stringDates = String(format: "%@", self.personalInfoDetail[0]["DATE_OF_BIRTH"] as! String)
                                var stringDatesArr = stringDates.characters.split{$0 == "-"}.map(String.init)
                                let tglLahir: String = String(format: "%@/%@/%@", stringDatesArr[2], stringDatesArr[1], stringDatesArr[0])
                                self.stringInfo = String(format: "%@, %@", self.personalInfoDetail[0]["ASSIGNMENT_NUMBER"] as! String, self.personalInfoDetail[0]["EMPLOYMENT_CATEGORY"] as! String)
                                self.stringKantor = String(format: "%@", self.personalInfoDetail[0]["LOCATION_ADDRESS"] as! String)
                                self.stringAgama = String(format: "%@, %@", self.personalInfoDetail[0]["AGAMA"] as! String, gender)
                                self.stringTtl = String(format: "%@, %@", self.personalInfoDetail[0]["TOWN_OF_BIRTH"] as! String, tglLahir)
                                self.stringAlamat = "-"
                                self.stringTelp = "-"
                                

                                if (self.personalInfoDetail[0]["PARENT_ASSIGNMENT_NUMBER"] is NSNull) {
                                    self.personalNppAtasan = ""
                                    self.personalInfoListDetail.reloadData()
                                }else{
                                    self.personalNppAtasan = String(format: "%@", self.personalInfoDetail[0]["PARENT_ASSIGNMENT_NUMBER"] as! String)
                                    self.setupDetailAtasanInfoItems(self.personalNppAtasan)
                                }
                            }
                    })
                }
        }
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
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.row == 0) {
            let className = String(PersonalInfoDetailDataCell.self)
            let nibViews = NSBundle.mainBundle().loadNibNamed(className, owner: self, options: nil)

            let cell = nibViews!.first as! PersonalInfoDetailDataCell
            
            cell.vInfoDetail.text = stringInfo
            cell.vKantorDetail.text = stringKantor
            cell.vAgamaDetail.text = stringAgama
            cell.vTtlDetail.text = stringTtl
            cell.vAlamatDetail.text = stringAlamat
            cell.vTelpDetail.text = stringTelp
            
            return cell
        }else{
            let className = String(PersonalInfoDetailHirarkiCell.self)
            let nibViews = NSBundle.mainBundle().loadNibNamed(className, owner: self, options: nil)
            
            let cell = nibViews!.first as! PersonalInfoDetailHirarkiCell
            
            if (cell.hirarkiView != nil) {
                cell.hirarkiView.removeFromParentViewController()
                cell.hirarkiView.view.removeFromSuperview()
                cell.hirarkiView = nil
            }
            cell.setupPersonalInfoDetailHirarki(personalNpp, itemRekan: personalInfoDetailRekan, delegate: self, itemNppAtasan: personalNppAtasan!, itemNamaAtasan: personalNamaAtasan!, itemUrl: personalUrl, itemUrlAtasan: personalUrlAtasan!)
            
            return cell
            
        }
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (indexPath.row == 0) ? 357.0 : 400.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (indexPath.row == 0) ? UITableViewAutomaticDimension : ((ratioHeight <= 0.56) ? 260.0 : (ratioHeight > 0.56 && ratioHeight <= 0.65) ? 315.0 : (ratioHeight > 0.65 && ratioHeight <= 0.72) ? 354.0 : 400.0)
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
