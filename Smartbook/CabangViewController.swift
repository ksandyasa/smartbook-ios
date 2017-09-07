//
//  CabangViewController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 8/30/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import Alamofire

class CabangViewController: UIViewController {

    @IBOutlet weak var cabangHeaderView: UIView!
    @IBOutlet weak var cabangContentView: UIView!
    @IBOutlet weak var cabangSlideMenu: UIButton!
    var cabangHeaderViewController: CabangHeaderViewController!
    var cabangContentViewController: CabangContentViewController!
    var ratioWidth: CGFloat = 0.0
    var ratioHeight: CGFloat = 0.0
    var mainMenuItems: Array<AnyObject>! = []
    var cabangListIndeks: Int! = 0
    var cabangHeaderItems: Array<AnyObject>! = []
    var cabangContentItems: Array<AnyObject>! = []
    var isLoadedCabang: Bool! = false
    weak var cabangDelegate: DashboardViewController!
    @IBOutlet weak var cabangSlideMenuWidth: NSLayoutConstraint!
    @IBOutlet weak var cabangSlideMenuHeight: NSLayoutConstraint!
    @IBOutlet weak var cabangHeaderViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }
    
    override func viewWillAppear(animated: Bool) {
        if (cabangHeaderItems.count > 0 && isLoadedCabang == false) {
            isLoadedCabang = true
            //print(cabangHeaderItems.description)
            setupCabangHeaderView(cabangHeaderItems)
            self.setupSubMenuItems(cabangListIndeks)            
        }
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
        setupCabangHeaderView(cabangHeaderItems)
        self.setupSubMenuItems(cabangListIndeks)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupRatioWidthAndHeightBasedOnDeviceScreen(orientation: Bool) {
        ratioWidth = (orientation == true) ? SmartbookUtility.setupRatioWidthBasedOnLandscape() : SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = (orientation == true) ? SmartbookUtility.setupRatioHeightBasedOnLandscape() : SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
                
        cabangHeaderView.bounds.size.width = ratioWidth * self.view.bounds.size.width
        cabangHeaderView.bounds.size.height = (orientation == true) ? ratioHeight * 299 : ratioHeight * 351
        cabangHeaderViewHeight.constant = (orientation == true) ? ratioHeight * 299 : ratioHeight * 351
        
        cabangContentView.bounds.size.width = ratioWidth * self.view.bounds.size.width
        cabangContentView.bounds.size.height = (orientation == true) ? ratioHeight * 449 : ratioHeight * 653
        
        cabangSlideMenuHeight.constant = ratioHeight * 44
        cabangSlideMenuWidth.constant = cabangSlideMenuHeight.constant
        
        self.view.setNeedsUpdateConstraints()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }
    
    func setupCabangHeaderView(items: Array<AnyObject>) {
        if (cabangHeaderViewController != nil) {
            cabangHeaderViewController.removeFromParentViewController()
            cabangHeaderViewController = nil
        }
        cabangHeaderViewController = CabangHeaderViewController(nibName: "CabangHeaderViewController", bundle: nil)
        cabangHeaderViewController.delegate = self
        cabangHeaderViewController.cabangHeaderIndeks = cabangListIndeks
        cabangHeaderViewController.mainMenuItems = mainMenuItems
        cabangHeaderViewController.cabangHeaderItems = items
//        cabangHeaderViewController.cabangListItems = cabangListItems
        self.addChildViewController(cabangHeaderViewController)
        cabangHeaderViewController.view.frame = cabangHeaderView.bounds
        cabangHeaderView.addSubview(cabangHeaderViewController.view)
        cabangHeaderViewController.didMoveToParentViewController(self)
    }
    
    func setupCabangContentView(items: Array<AnyObject>) {
        if (cabangContentViewController != nil) {
            cabangContentViewController.removeFromParentViewController()
            cabangContentViewController = nil
        }
        cabangContentViewController = CabangContentViewController(nibName: "CabangContentViewController", bundle: nil)
        cabangContentViewController.cabangContentDelegate = self
        cabangContentViewController.cabangContentList = items
        self.addChildViewController(cabangContentViewController)
        cabangContentViewController.view.frame = cabangContentView.bounds
        cabangContentView.addSubview(cabangContentViewController.view)
        cabangContentViewController.didMoveToParentViewController(self)
    }
    
    func setupSubMenuItems(index: Int) {
        self.setupCabangHeaderView(self.cabangHeaderItems)
        self.setupCabangContentItems(index)
    }
    
    func setupCabangContentItems(index: Int) {        
        let params = [
            "mainmenu_id" : String(format: "%d", mainMenuItems[1]["id"] as! Int),
            "npp": SmartbookUtility.getUserDefaults().valueForKey("prefPersonalNpp") as! String,
            "api_token": SmartbookUtility.getUserDefaults().valueForKey("prefApiKey") as! String
        ]
        
        Alamofire.request(.POST, ConstantAPI.getSubMenuURL(),
            parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.cabangContentItems = JSON["data"] as? Array<AnyObject>
                    //print("cabangContentItems : ", self.cabangContentItems.description)
                    self.setupCabangContentView(self.cabangContentItems)
                    self.dismissDashboardIndicatorFromCabang()
                }
        }
    }

    @IBAction func ActionSlideMenuCabang(sender: UIButton) {
        cabangDelegate.slideMenuAction(cabangSlideMenu)
    }
    
    func actionClickFromCabangContentController(contentItems: Array<AnyObject>, indeks: Int) {
        cabangDelegate.showDashboardIndicatorView()
        cabangDelegate.showMainContentViewPopUp(contentItems, indeks: indeks)
    }
    
    func setupCabangListIndeksFromHeader(headerIndeks: Int) {
        print("cabangListIndeksFromHeader : ", headerIndeks)
        cabangDelegate.setupCabangItemsIndeks(headerIndeks)
    }
    
    func dismissDashboardIndicatorFromCabang() {
        cabangDelegate.dismissDashboardIndicatorView()
    }
    
    func showDashboardIndicatorFromCabang() {
        cabangDelegate.showDashboardIndicatorView()
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
