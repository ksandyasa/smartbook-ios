//
//  ViewController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 8/27/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController {

    @IBOutlet var mainSlideView: UIView!
    @IBOutlet var mainContentView: UIView!
    @IBOutlet weak var slideMenuBtn: UIButton!
    var mainSlideViewController: MainSlideViewController!
    var mainContentViewController: MainContentViewController!
    var ratioWidth: CGFloat = 0.0
    var ratioHeight: CGFloat = 0.0
    var mainMenuItems: Array<AnyObject>! = []
    var mainSlideItems: Array<AnyObject>! = []
    var mainContentItems: Array<AnyObject>! = []
    var isLoadedMain: Bool! = false
    weak var mainDelegate: DashboardViewController!
    @IBOutlet weak var slideMenuBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var slideMenuBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var mainSlideViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if (mainMenuItems.count > 0 && isLoadedMain == false) {
            isLoadedMain = true
            //print(self.mainMenuItems.description)
            self.setupSubMenuItems()
            self.setupSlideItems()
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        print("orientation changed!")
        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
        self.setupMainSlideView(mainSlideItems)
        self.setupMainContentView(mainContentItems)
    }
        
    func setupRatioWidthAndHeightBasedOnDeviceScreen(orientation: Bool) {
        ratioWidth = (orientation == true) ? SmartbookUtility.setupRatioWidthBasedOnLandscape() : SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = (orientation == true) ? SmartbookUtility.setupRatioHeightBasedOnLandscape() : SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
        
        mainSlideView.bounds.size.width = ratioWidth * self.view.bounds.size.width
        mainSlideView.bounds.size.height = (orientation == true) ? ratioHeight * 299 : ratioHeight * 351
        mainSlideViewHeight.constant = (orientation == true) ? ratioHeight * 299 : ratioHeight * 351
        
        mainContentView.bounds.size.width = ratioWidth * self.view.bounds.size.width
        mainContentView.bounds.size.height = (orientation == true) ? ratioHeight * 449 : ratioHeight * 653
        
        slideMenuBtnHeight.constant = ratioHeight * 44
        slideMenuBtnWidth.constant = slideMenuBtnHeight.constant
        
        self.view.setNeedsUpdateConstraints()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()        
    }
    
    func setupMainSlideView(slideItems: Array<AnyObject>) {
        if (mainSlideViewController != nil) {
            mainSlideViewController.removeFromParentViewController()
            mainSlideViewController = nil
        }
        mainSlideViewController = MainSlideViewController(nibName: "MainSlideViewController", bundle: nil)
        mainSlideViewController.mainSlideDelegate = self
        mainSlideViewController.slideItems = slideItems
        self.addChildViewController(mainSlideViewController)
        mainSlideViewController.view.frame = mainSlideView.bounds
        mainSlideView.addSubview(mainSlideViewController.view)
        mainSlideViewController.didMoveToParentViewController(self)
    }
    
    func setupMainContentView(contentItems: Array<AnyObject>) {
        if (mainContentViewController != nil) {
            mainContentViewController.removeFromParentViewController()
            mainContentViewController = nil
        }
        mainContentViewController = MainContentViewController(nibName: "MainContentViewController", bundle: nil)
        mainContentViewController.mainContentDelegate = self
        mainContentViewController.mainContentItems = mainContentItems
        mainContentViewController.mainMenuItems = mainMenuItems
        self.addChildViewController(mainContentViewController)
        mainContentViewController.view.frame = mainContentView.bounds
        mainContentView.addSubview(mainContentViewController.view)
        mainContentViewController.didMoveToParentViewController(self)
    }
    
    func setupSubMenuItems() {
        let params = [
            "mainmenu_id" : String(format: "%d", mainMenuItems[0]["id"] as! Int),
            "npp": SmartbookUtility.getUserDefaults().valueForKey("prefPersonalNpp") as! String,
            "api_token": SmartbookUtility.getUserDefaults().valueForKey("prefApiKey") as! String
        ]
        
        Alamofire.request(.POST, ConstantAPI.getSubMenuURL(),
            parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.mainContentItems = JSON["data"] as? Array<AnyObject>
                    //print(self.mainContentItems.description)
                    self.setupMainContentView(self.mainContentItems)
                    self.dismissDashboardIndicatorFromMain()
                }
        }
    }
    
    func setupSlideItems() {
        let params = [
            "npp": SmartbookUtility.getUserDefaults().valueForKey("prefPersonalNpp") as! String,
            "api_token": SmartbookUtility.getUserDefaults().valueForKey("prefApiKey") as! String
        ]
        
        Alamofire.request(.POST, ConstantAPI.getArtikelURL(),
            parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.mainSlideItems = JSON["data"] as? Array<AnyObject>
                    print(self.mainSlideItems.description)
                    self.setupMainSlideView(self.mainSlideItems)
                }
        }
    }

    @IBAction func ActionSlideMenuMain(sender: UIButton) {
        mainDelegate.slideMenuAction(slideMenuBtn)
    }
    
    func actionClickFromMainSlideController(slideItems: Array<AnyObject>, indeksPage: Int) {
        print("clicked from main Slide Controller")
        mainDelegate.showMainSlideViewPopUp(slideItems, indeksPage: indeksPage)
    }
    
    func actionClickFromMainContentController(contentItems: Array<AnyObject>, indeks: Int) {
        mainDelegate.showDashboardIndicatorView()
        mainDelegate.showMainContentViewPopUp(contentItems, indeks: indeks)
    }
    
    func dismissDashboardIndicatorFromMain() {
        mainDelegate.dismissDashboardIndicatorView()
    }
    
}

