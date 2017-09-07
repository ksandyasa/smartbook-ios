//
//  PersonalInfoListViewController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 9/21/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import Alamofire

class PersonalInfoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var personalInfoList: UITableView!
    let cellIdentifier: String! = "personalInfoListCell"
    var ratioWidth: CGFloat = 0.0
    var ratioHeight: CGFloat = 0.0
    var personalList: Array<AnyObject> = []
    var personalInfoDetail: NSDictionary! = nil
    var isLoadMore: Bool = false
    var isMaxSize: Bool = false
    var keyWord: String! = ""
    var personalInfoNpp: String! = ""
    var personalInfoNama: String! = ""
    var personalInfoJabatan: String! = ""
    var personalInfoUrl: String! = ""
    var prevSize: Int = 0
    weak var personalInfoListDelegate: PersonalInfoViewController!
    var personalInfoListDetailController: PersonalInfoListDetailViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        personalInfoList.registerNib(UINib(nibName: "PersonalInfoListCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        personalInfoList.dataSource = self
        personalInfoList.delegate = self
        personalInfoList.tableFooterView = UIView(frame: CGRectZero)
        
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
        self.view.bounds.size.height = ratioHeight * 960
        
        personalInfoList.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(personalInfoList.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        self.automaticallyAdjustsScrollViewInsets = false
        
        print(keyWord)
        self.setupPersonalInfoItems()
    }
    
    func setupPersonalInfoItems() {
        let params = [
            "start" : "0",
            "limit" : "20",
            "word": keyWord,
            "npp": SmartbookUtility.getUserDefaults().valueForKey("prefPersonalNpp") as! String,
            "api_token": SmartbookUtility.getUserDefaults().valueForKey("prefApiKey") as! String
        ]
        
        Alamofire.request(.POST, ConstantAPI.getPersonalInfoURL(), parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.personalList = (JSON["data"] as? Array<AnyObject>)!
                    print("personalList : ", self.personalList.description)
                    UIView.transitionWithView(self.personalInfoList, duration: 0.325, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                        if (self.personalList.count > 0) {
                            self.personalInfoList.reloadData()
                        }
                        }, completion: { (finished: Bool) -> () in
                            self.prevSize = self.personalList.count
                            self.personalInfoListDelegate.dismissPersonalInfoIndicatorView()
                    })
                }
        }
    }
    
    func setupPersonalInfoItemsByNpp() {
        let params = ["npp" : personalInfoNpp,
                      "apikey" : SmartbookUtility.getUserDefaults().valueForKey("prefApiKey") as! String
        ]
        
        Alamofire.request(.GET, ConstantAPI.getPersonalInfoURL(), parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.personalInfoDetail = JSON["data"] as? NSDictionary
                    UIView.transitionWithView(self.personalInfoList, duration: 0.325, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                        if (self.personalInfoDetail != nil) {
                            self.personalInfoNpp = String(format: "%@", self.personalInfoDetail.valueForKey("npp") as! String)
                            self.personalInfoNama = String(format: "%@", self.personalInfoDetail.valueForKey("nama_personal") as! String)
                            self.personalInfoJabatan = String(format: "%@", self.personalInfoDetail.valueForKey("personal_jabatan") as! String)
                            self.personalInfoUrl = String(format: "%@", self.personalInfoDetail.valueForKey("url") as! String)
                            self.personalInfoList.reloadData()
                        }
                        }, completion: { (finished: Bool) -> () in
                            self.personalInfoList.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: .Top)
                            self.tableView(self.personalInfoList, didSelectRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))
                            self.personalInfoListDelegate.beginEditingPersonalInfoSearchBar()
                            self.personalInfoListDelegate.dismissPersonalInfoIndicatorView()
                    })
                }
        }
    }
    
    func setupMorePersonalItems() {
        let params = [
            "start" : String(format: "%ld", personalList.count),
            "limit" : "20",
            "word": keyWord,
            "npp": SmartbookUtility.getUserDefaults().valueForKey("prefPersonalNpp") as! String,
            "api_token": SmartbookUtility.getUserDefaults().valueForKey("prefApiKey") as! String
        ]
        
        Alamofire.request(.POST, ConstantAPI.getPersonalInfoURL(), parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    let tempArray = JSON["data"] as? NSArray
                    UIView.transitionWithView(self.personalInfoList, duration: 0.500, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                        if (tempArray!.count > 0) {
                            for i in 0 ..< tempArray!.count  {
                                self.personalList.append(tempArray![i])
                            }
                        }
                        }, completion: { (finished: Bool) -> () in
                            //print(self.personalList.count)
                            if (self.prevSize != self.personalList.count) {
                                self.prevSize = self.personalList.count
                            }else{
                                self.isMaxSize = true
                            }
                            self.personalInfoList.reloadData()
                            self.isLoadMore = false
                            self.personalInfoListDelegate.dismissPersonalInfoIndicatorView()
                    })
                }
        }
    }
    
    func setupPersonalInfoIcons(imageIcon: UIImageView, urlString: String) {
        Alamofire.request(.GET, urlString,
            parameters: nil)
            .responseJSON { response in
                let tempImage = UIImage(data: response.data!)
                imageIcon.image = SmartbookUtility.cropImageToWidth(tempImage!, width: (tempImage?.size.width)!, height: (tempImage?.size.width)!)
        }
    }
    
    func dismissPersonalInfoListDetail() {
        self.dismissViewControllerAnimated(true, completion: { Void in
            self.personalInfoListDetailController = nil
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
        return (personalInfoDetail != nil) ? 1 : personalList.count
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
                
        if (indexPath.row == personalList.count - 1) {
            if (isLoadMore == false && isMaxSize == false) {
                isLoadMore = true
                personalInfoListDelegate.showPersonalInfoIndicatorView()
                self.setupMorePersonalItems()
            }
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! PersonalInfoListCell
        
        // Configure the cell...
        if (personalInfoDetail != nil) {
            print(personalInfoUrl)
            self.setupPersonalInfoIcons(cell.itemListPict, urlString: personalInfoUrl)
            cell.itemListName.text = personalInfoNama
            cell.itemListJabatan.text = personalInfoJabatan
        }else{
            if (personalList.count > 0) {
                let urlImage = String(format: "%@/%@", ConstantAPI.getImageBaseURL(), personalList[indexPath.row]["urlfoto"] as! String)
                self.setupPersonalInfoIcons(cell.itemListPict, urlString: urlImage)
                cell.itemListName.text = String(format: "%@", personalList[indexPath.row]["LAST_NAME"] as! String)
                cell.itemListJabatan.text = String(format: "%@", personalList[indexPath.row]["POSITION_NAME"] as! String)
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 97.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (personalInfoDetail != nil) {
            personalInfoListDetailController = PersonalInfoListDetailViewController(nibName: "PersonalInfoListDetailViewController", bundle: nil)
            personalInfoListDetailController.personalInfoListDetailDelegate = self
            personalInfoListDetailController.personalNpp = personalInfoNpp
            self.presentViewController(personalInfoListDetailController, animated: true, completion: nil)
        }else{
            personalInfoListDetailController = PersonalInfoListDetailViewController(nibName: "PersonalInfoListDetailViewController", bundle: nil)
            personalInfoListDetailController.personalInfoListDetailDelegate = self
            personalInfoListDetailController.personalNpp = String(format: "%@", self.personalList[indexPath.row]["ASSIGNMENT_NUMBER"] as! String)
            self.presentViewController(personalInfoListDetailController, animated: true, completion: nil)
        }
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
