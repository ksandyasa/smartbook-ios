//
//  AnakViewController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 8/30/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import Alamofire

class AnakViewController: UIViewController {
    
    var ratioWidth: CGFloat = 0.0
    var ratioHeight: CGFloat = 0.0
    @IBOutlet weak var anakHeaderView: UIView!
    @IBOutlet weak var anakContentView: UIView!
    var anakHeaderViewController: AnakHeaderViewController!
    var anakContentViewController: AnakContentViewController!
    var mainMenuItems: Array<AnyObject>! = []
    var mainMenuItemsIndeks: Int!
    var anakHeaderItems: Array<AnyObject>! = []
    var anakHeaderItemsIndeks: Int!
    var anakContentItems: Array<AnyObject>! = []
    var isLoadedAnak: Bool! = false
    weak var anakDelegate: DashboardViewController!
    @IBOutlet weak var anakSlideMenu: UIButton!
    @IBOutlet weak var anakSlideMenuWidth: NSLayoutConstraint!
    @IBOutlet weak var anakSlideMenuHeight: NSLayoutConstraint!
    @IBOutlet weak var anakHeaderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var anakContentViewHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }
    
    override func viewWillAppear(animated: Bool) {
        if (anakHeaderItems.count > 0 && isLoadedAnak == false) {
            //print(anakHeaderItems.description)
            //isLoadedAnak = true
            self.setupAnakHeaderView(anakHeaderItems)
            self.setupAnakContentItems(anakHeaderItemsIndeks)
            //self.setupSubMenuItems(0)
        }
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
        setupAnakHeaderView(anakHeaderItems)
        setupAnakContentView(anakContentItems)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupRatioWidthAndHeightBasedOnDeviceScreen(orientation: Bool) {
        ratioWidth = (orientation == true) ? SmartbookUtility.setupRatioWidthBasedOnLandscape() : SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = (orientation == true) ? SmartbookUtility.setupRatioHeightBasedOnLandscape() : SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
        
        anakHeaderView.bounds.size.width = ratioWidth * self.view.bounds.size.width
        anakHeaderView.bounds.size.height = (orientation == true) ? ratioHeight * 299 : ratioHeight * 351
        anakHeaderViewHeight.constant = (orientation == true) ? ratioHeight * 299 : ratioHeight * 351
        
        anakContentView.bounds.size.width = ratioWidth * self.view.bounds.size.width
        anakContentView.bounds.size.height = (orientation == true) ? ratioHeight * 449 : ratioHeight * 653
        
        anakSlideMenuHeight.constant = ratioHeight * 44
        anakSlideMenuWidth.constant = anakSlideMenuHeight.constant
        
        self.view.setNeedsUpdateConstraints()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    func setupAnakHeaderView(headerItems: Array<AnyObject>) {
        if (anakHeaderViewController != nil) {
            anakHeaderViewController.removeFromParentViewController()
            anakHeaderViewController = nil
        }
        anakHeaderViewController = AnakHeaderViewController(nibName: "AnakHeaderViewController", bundle: nil)
        anakHeaderViewController.delegate = self
        anakHeaderViewController.mainMenuItems = mainMenuItems
        anakHeaderViewController.anakHeaderItems = headerItems
        anakHeaderViewController.anakHeaderItemsIndeks = anakHeaderItemsIndeks
        self.addChildViewController(anakHeaderViewController)
        anakHeaderViewController.view.frame = anakHeaderView.bounds
        anakHeaderView.addSubview(anakHeaderViewController.view)
        anakHeaderViewController.didMoveToParentViewController(self)
    }
    
    func setupAnakContentView(contentItems: Array<AnyObject>) {
        if (anakContentViewController != nil) {
            anakContentViewController.removeFromParentViewController()
            anakContentViewController = nil
        }
        anakContentViewController = AnakContentViewController(nibName: "AnakContentViewController", bundle: nil)
        anakContentViewController.anakContentDelegate = self
        anakContentViewController.anakContentList = contentItems
        self.addChildViewController(anakContentViewController)
        anakContentViewController.view.frame = anakContentView.bounds
        anakContentView.addSubview(anakContentViewController.view)
        anakContentViewController.didMoveToParentViewController(self)
    }
    
    func setupSubMenuItems(index: Int) {
//        let params = ["id" : ((mainMenuItems[2].valueForKey("link_content")?.valueForKey("mainmenu_id")) as? String)!,
//                      "kantorid": ((anakListItems[index].valueForKey("anakperusahaan_id")) as? String!)!,
//                      "apikey" : SmartbookUtility.getUserDefaults().valueForKey("prefApiKey") as! String
//        ]
//        
//        Alamofire.request(.GET, ConstantAPI.getSubMenuURL(),
//            parameters: params)
//            .responseJSON { response in
//                
//                if let JSON = response.result.value {
//                    self.anakHeaderItems = JSON["header"] as? Array<AnyObject>
//                    self.anakContentItems = JSON["data"] as? Array<AnyObject>
//                    self.setupAnakHeaderView(self.anakHeaderItems)
//                    self.setupAnakContentView(self.anakContentItems)
//                    self.dismissDashboardIndicatorFromAnak()
//                }
//        }
    }
    
    func setupAnakContentItems(index: Int) {
        let params = [
            "mainmenu_id" : String(format: "%d", mainMenuItems[mainMenuItemsIndeks]["id"] as! Int),
            "npp": SmartbookUtility.getUserDefaults().valueForKey("prefPersonalNpp") as! String,
            "api_token": SmartbookUtility.getUserDefaults().valueForKey("prefApiKey") as! String
        ]
        
        Alamofire.request(.POST, ConstantAPI.getSubMenuURL(),
            parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.anakContentItems = JSON["data"] as? Array<AnyObject>
                    self.setupAnakContentView(self.anakContentItems)
                    self.dismissDashboardIndicatorFromAnak()
                }
        }        
    }

    @IBAction func ActionSlideMenuAnak(sender: UIButton) {
        anakDelegate.slideMenuAction(anakSlideMenu)
    }
    
    func actionClickFromAnakContentController(contentItems: Array<AnyObject>, indeks: Int) {
        anakDelegate.showDashboardIndicatorView()
        anakDelegate.showMainContentViewPopUp(contentItems, indeks: indeks)
    }
    
    func setupAnakListIndeksFromHeader(headerIndeks: Int) {
        anakHeaderItemsIndeks = headerIndeks
        anakDelegate.setupAnakItemsIndeks(headerIndeks)
    }
    
    func dismissDashboardIndicatorFromAnak() {
        anakDelegate.dismissDashboardIndicatorView()
    }
    
    func showDashboardIndicatorFromAnak() {
        anakDelegate.showDashboardIndicatorView()
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
