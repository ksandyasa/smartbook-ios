//
//  DashboardViewController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 8/30/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import Alamofire
import QuartzCore

protocol LeftMenuProtocol : class {
    func showDashboardContentViewControllerForIndex(index: Int)
}

class DashboardViewController: SlideMenuController, LeftMenuProtocol, UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var pusatViewController: MainViewController!
    var cabangViewController: CabangViewController!
    var anakViewController: AnakViewController!
    var personalInfoNavigationController: UINavigationController!
    var personalInfoViewController: PersonalInfoViewController!
    var menuViewController: MenuViewController!
    var mainSlidePopupController: MainSlidePopupViewController!
    var mainContentPopupController: MainContentPopupViewController!
    var penghargaanPopupController: PenghargaanViewController!
    var cabangPopupController: CabangPopupViewController!
    var anakContentBOCController: AnakContentBOCViewController!
    var cabangStrukturController: CabangStrukturController!
    var ubahPasswordController: UbahPasswordViewController!
    var ratioWidth: CGFloat = 0.0
    var ratioHeight: CGFloat = 0.0
    var menuItems: Array<AnyObject>! = []
    var cabangItems: Array<AnyObject>! = []
    var anakItems: Array<AnyObject>! = []
    var anakType: String! = ""
    var mainMenuIndeks: Int! = 0
    var cabangItemsIndeks: Int! = 0
    var anakItemsIndeks: Int! = 0
    var dashboardIndicator: UIActivityIndicatorView!
    var dashboardIndicatorView: UIView!
    var cabangAlertController: UIAlertController!
    var cabangPicker: UIPickerView!
    @IBOutlet weak var dashboardContainerView: UIView!
    @IBOutlet weak var slideMenuBtn: UIButton!
    @IBOutlet weak var slideMenuBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var slideMenuBtnWidth: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("CabangViewController") {
            self.mainViewController = controller
        }
        if let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MenuViewController") {
            self.leftViewController = controller
        }
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupRatioWidthAndHeightBasedOnDeviceScreen()
        self.setupDashboardIndicatorView()
        self.setupMenuItems()
    }
            
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupRatioWidthAndHeightBasedOnDeviceScreen() {
        ratioWidth = SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
                
        slideMenuBtnHeight.constant = CGFloat(ratioHeight * slideMenuBtnHeight.constant)
        slideMenuBtnWidth.constant = CGFloat(ratioWidth * slideMenuBtnWidth.constant)
        
        //self.showDashboardContentViewControllerForIndex(0)
    }
    
    func showDashboardContentViewControllerForIndex(index:Int){
        self.showDashboardIndicatorView()
        pusatViewController = nil
        cabangViewController = nil
        anakViewController = nil
        mainMenuIndeks = (index == 4) ? mainMenuIndeks : index
        switch index {
            case 0: setupPusatViewController(menuItems)
                break
            case 1: setupCabangViewController()
                break
            case 2: setupAnakItems("1")
                break
            case 3: setupAnakItems("2")
                break
            case 4: setupPersonalInfoViewController()
                break
            default: setupPusatViewController(menuItems)
                break
        }
                
    }
    
    func setupMenuViewController(items: Array<AnyObject>) {
        menuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
        menuViewController.menuDelegate = self
        menuViewController.menuItems = items
        self.leftViewController = menuViewController
        self.changeLeftViewController(menuViewController, closeLeft: true)
    }
    
    func setupPusatViewController(items: Array<AnyObject>) {
        pusatViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        pusatViewController.mainDelegate = self
        pusatViewController.mainMenuItems = items
        pusatViewController.view.frame = self.view.bounds
        self.changeMainViewController(pusatViewController, close: true)
    }
    
    func setupCabangViewController() {
        cabangViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CabangViewController") as! CabangViewController
        cabangViewController.cabangDelegate = self
        cabangViewController.cabangListIndeks = cabangItemsIndeks
        cabangViewController.mainMenuItems = menuItems
        cabangViewController.cabangHeaderItems = cabangItems
        cabangViewController.view.frame = self.view.bounds
        self.changeMainViewController(cabangViewController, close: true)
    }
    
    func setupAnakViewController(items: Array<AnyObject>) {
        anakViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AnakViewController") as! AnakViewController
        anakViewController.anakDelegate = self
        anakViewController.mainMenuItems = menuItems
        anakViewController.mainMenuItemsIndeks = mainMenuIndeks
        anakViewController.anakHeaderItems = items
        anakViewController.anakHeaderItemsIndeks = anakItemsIndeks
        anakViewController.view.frame = self.view.bounds
        self.changeMainViewController(anakViewController, close: true)
    }
    
    func setupPersonalInfoViewController() {
        personalInfoViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PersonalInfoViewController") as! PersonalInfoViewController
        personalInfoViewController.personalInfoDelegate = self
        self.navigationController!.pushViewController(personalInfoViewController, animated: true)
        self.dismissDashboardIndicatorView()
    }
    
    func setupPersonalInfoViewControllerFroMainContent(kepalaCabang: String) {
        personalInfoViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PersonalInfoViewController") as! PersonalInfoViewController
        personalInfoViewController.personalInfoDelegate = self
        personalInfoViewController.personalInfoNppKepalaCabang = kepalaCabang
        self.navigationController!.pushViewController(personalInfoViewController, animated: true)
        self.dismissDashboardIndicatorView()
    }
    
    func setupCabangPopupView() {
        self.dismissDashboardIndicatorView()
        cabangAlertController = UIAlertController(title: "Pilih Cabang",
                                                  message: "\n\n\n\n\n\n\n\n\n",
                                                  preferredStyle: .ActionSheet)
        
        let tutupAction = UIAlertAction(title: "Tutup", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in print("tutup")})
        cabangAlertController.addAction(tutupAction)
        
        cabangPicker = UIPickerView()
        cabangPicker.delegate = self
        cabangPicker.dataSource = self
        cabangPicker.showsSelectionIndicator = true
        cabangPicker.reloadAllComponents()
        cabangPicker.bounds = CGRectMake(-10, cabangPicker.bounds.origin.y, cabangPicker.bounds.size.width, cabangPicker.bounds.size.height)
        
//        cabangPopupController = CabangPopupViewController(nibName: "CabangPopupViewController", bundle: nil)
//        cabangPopupController.cabangPopupDelegate = self
//        cabangPopupController.mainMenuIndeks = mainMenuIndeks
//        cabangPopupController.mainMenuItems = menuItems
//        cabangPopupController.cabangList = cabangItems
//        cabangPopupController.view.backgroundColor = UIColor.clearColor()
//        cabangPopupController.view.opaque = false
//        cabangPopupController.modalPresentationStyle = .Popover
//        cabangPopupController.popoverPresentationController!.delegate = self
        
        cabangAlertController.view.addSubview(cabangPicker)
        
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            cabangAlertController.popoverPresentationController!.sourceView = self.view
            cabangAlertController.popoverPresentationController!.sourceRect = CGRectMake(self.view.bounds.size.width, self.view.bounds.size.height, 1.0, 1.0)
        }
        
        self.presentViewController(cabangAlertController, animated: true, completion: nil)
    }
    
    func setupDashboardIndicatorView() {
        dashboardIndicatorView = UIView()
        dashboardIndicatorView.frame = CGRectMake(0, 0, 76, 76)
        dashboardIndicatorView.center = self.view.center
        dashboardIndicatorView.backgroundColor = SmartbookUtility.colorWithHexString("3FAED6")
        dashboardIndicatorView.alpha = 0.75
        dashboardIndicatorView.layer.cornerRadius = 10.0
        dashboardIndicatorView.layer.masksToBounds = true
        
        dashboardIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        dashboardIndicator.transform = CGAffineTransformMakeScale(2.0, 2.0)
        dashboardIndicator.center = dashboardIndicatorView.center
        
        self.view.addSubview(dashboardIndicatorView)
        self.view.addSubview(dashboardIndicator)
        self.view.bringSubviewToFront(dashboardIndicatorView)
        self.view.bringSubviewToFront(dashboardIndicator)
        self.showDashboardIndicatorView()
    }
    
    func showDashboardIndicatorView() {
        dashboardIndicatorView.hidden = false
        dashboardIndicator.startAnimating()
    }
    
    func dismissDashboardIndicatorView() {
        dashboardIndicatorView.hidden = true
        dashboardIndicator.stopAnimating()
    }
        
    func setupMenuItems() {
        let params = [
            "api_token" : SmartbookUtility.getUserDefaults().valueForKey("prefApiKey") as! String,
            "npp" : SmartbookUtility.getUserDefaults().valueForKey("prefPersonalNpp") as! String
        ]
        
        Alamofire.request(.POST, ConstantAPI.getMainMenuURL(), parameters: params)
            .responseJSON { response in
                switch response.result {
                    case .Success(let json):
                        self.dismissDashboardIndicatorView()
                        self.menuItems = json["data"] as! Array<AnyObject>
                        //print(self.menuItems.description)
                        self.setupCabangItems()
                        //self.setupAnakItems("1")
                        self.setupMenuViewController(self.menuItems)
                        self.setupPusatViewController(self.menuItems)
                    break
                    
                    case .Failure(let error):
                        self.dismissDashboardIndicatorView()
                        if let err = error as? NSURLError where err == .NotConnectedToInternet {
                            // no internet connection
                            self.showDashboardAlert("Tidak ada koneksi internet")
                        } else {
                            // other failures
                            self.showDashboardAlert("Terjadi kegagalan dalam pengambilan data")
                        }
                    break
                }
                
                
        }
    }
    
    func setupCabangItems() {
        let params = [
            "mainmenu_id" : String(format: "%d", menuItems[1]["id"] as! Int),
            "npp": SmartbookUtility.getUserDefaults().valueForKey("prefPersonalNpp") as! String,
            "api_token": SmartbookUtility.getUserDefaults().valueForKey("prefApiKey") as! String
        ]

        Alamofire.request(.POST, ConstantAPI.getListPerusahaanURL(), parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.cabangItems = JSON["data"] as? Array<AnyObject>
                    print("cabangItems : ", self.cabangItems.description)
                }
        }
    }
    
    func setupAnakItems(type: String) {
        anakType = type
        let anakIndeks = (type == "1") ? 2 : 3

        let params = [
            "mainmenu_id" : String(format: "%d", menuItems[anakIndeks]["id"] as! Int),
            "npp": SmartbookUtility.getUserDefaults().valueForKey("prefPersonalNpp") as! String,
            "api_token": SmartbookUtility.getUserDefaults().valueForKey("prefApiKey") as! String
        ]

        Alamofire.request(.POST, ConstantAPI.getListPerusahaanURL(), parameters: params)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.anakItems = JSON["data"] as? Array<AnyObject>
                    self.setupAnakViewController(self.anakItems)
                }
        }
    }
    
    @IBAction func slideMenuAction(sender: UIButton) {
        self.openLeft()
    }
    
    func showMainSlideViewPopUp(slideItems: Array<AnyObject>, indeksPage: Int) {
        print("show Main Slide View Pop Up")
        mainSlidePopupController = MainSlidePopupViewController(nibName: "MainSlidePopupViewController", bundle: nil)
        mainSlidePopupController.mainSlidePopupDelegate = self
        mainSlidePopupController.indeksPage = indeksPage
        mainSlidePopupController.mainSlideItems = slideItems
//        mainSlidePopupController.modalPresentationStyle = .OverCurrentContext
        self.presentViewController(mainSlidePopupController, animated: true, completion: nil)
    }
    
    func showMainContentViewPopUp(contentItems: Array<AnyObject>, indeks: Int) {
        if (mainMenuIndeks == 0) {
            if (indeks == 5) {
                penghargaanPopupController = PenghargaanViewController(nibName: "PenghargaanViewController", bundle: nil)
                penghargaanPopupController.penghargaanDelegate = self
                penghargaanPopupController.mainContentItems = contentItems
                penghargaanPopupController.mainContentIndeks = indeks
                penghargaanPopupController.mainMenuItems = menuItems
                penghargaanPopupController.mainMenuIndeks = mainMenuIndeks
                self.presentViewController(penghargaanPopupController, animated: true, completion: nil)                
            }else if (indeks == contentItems.count - 1) {
                self.setupCabangPopupView()
            }else {
                mainContentPopupController = MainContentPopupViewController(nibName: "MainContentPopupViewController", bundle: nil)
                mainContentPopupController.mainContentPopupDelegate = self
                mainContentPopupController.mainContentItems = contentItems
                mainContentPopupController.mainContentIndeks = indeks
                mainContentPopupController.mainMenuItems = menuItems
                mainContentPopupController.mainMenuIndeks = mainMenuIndeks
                mainContentPopupController.kantorItems = cabangItems
                mainContentPopupController.kantorItemsIndeks = cabangItemsIndeks
                self.presentViewController(mainContentPopupController, animated: true, completion: nil)
            }
        }else if (mainMenuIndeks == 1) {
            if (indeks == contentItems.count - 1) {
                cabangStrukturController = CabangStrukturController(nibName: "CabangStrukturController", bundle: nil)
                cabangStrukturController.cabangStrukturDelegate = self
                cabangStrukturController.mainContentItems = contentItems
                cabangStrukturController.mainContentIndeks = indeks
                cabangStrukturController.mainMenuItems = menuItems
                cabangStrukturController.mainMenuIndeks = mainMenuIndeks
                cabangStrukturController.kantorItems = cabangItems
                cabangStrukturController.kantorItemsIndeks = cabangItemsIndeks
                self.presentViewController(cabangStrukturController, animated: true, completion: nil)
            }else {
                mainContentPopupController = MainContentPopupViewController(nibName: "MainContentPopupViewController", bundle: nil)
                mainContentPopupController.mainContentPopupDelegate = self
                mainContentPopupController.mainContentItems = contentItems
                mainContentPopupController.mainContentIndeks = indeks
                mainContentPopupController.mainMenuItems = menuItems
                mainContentPopupController.mainMenuIndeks = mainMenuIndeks
                mainContentPopupController.kantorItems = cabangItems
                mainContentPopupController.kantorItemsIndeks = cabangItemsIndeks
                self.presentViewController(mainContentPopupController, animated: true, completion: nil)
            }
        }else if (mainMenuIndeks == 2) {
            if (indeks == 1 || indeks == 2) {
                anakContentBOCController = AnakContentBOCViewController(nibName: "AnakContentBOCViewController", bundle: nil)
                anakContentBOCController.modalPresentationStyle = .CurrentContext
                anakContentBOCController.anakContentBOCDelegate = self
                anakContentBOCController.mainContentItems = contentItems
                anakContentBOCController.mainContentIndeks = indeks
                anakContentBOCController.mainMenuItems = menuItems
                anakContentBOCController.mainMenuIndeks = mainMenuIndeks
                anakContentBOCController.kantorItems = anakItems
                anakContentBOCController.kantorItemsIndeks = anakItemsIndeks
                self.presentViewController(anakContentBOCController, animated: true, completion: nil)
            }else{
                mainContentPopupController = MainContentPopupViewController(nibName: "MainContentPopupViewController", bundle: nil)
                mainContentPopupController.mainContentPopupDelegate = self
                mainContentPopupController.mainContentItems = contentItems
                mainContentPopupController.mainContentIndeks = indeks
                mainContentPopupController.mainMenuItems = menuItems
                mainContentPopupController.mainMenuIndeks = mainMenuIndeks
                mainContentPopupController.kantorItems = anakItems
                mainContentPopupController.kantorItemsIndeks = anakItemsIndeks
                self.presentViewController(mainContentPopupController, animated: true, completion: nil)
            }
        }else if (mainMenuIndeks == 3) {
            if (indeks == 1 || indeks == 2) {
                anakContentBOCController = AnakContentBOCViewController(nibName: "AnakContentBOCViewController", bundle: nil)
                anakContentBOCController.modalPresentationStyle = .CurrentContext
                anakContentBOCController.anakContentBOCDelegate = self
                anakContentBOCController.mainContentItems = contentItems
                anakContentBOCController.mainContentIndeks = indeks
                anakContentBOCController.mainMenuItems = menuItems
                anakContentBOCController.mainMenuIndeks = mainMenuIndeks
                anakContentBOCController.kantorItems = anakItems
                anakContentBOCController.kantorItemsIndeks = anakItemsIndeks
                self.presentViewController(anakContentBOCController, animated: true, completion: nil)                
            }else{
                mainContentPopupController = MainContentPopupViewController(nibName: "MainContentPopupViewController", bundle: nil)
                mainContentPopupController.mainContentPopupDelegate = self
                mainContentPopupController.mainContentItems = contentItems
                mainContentPopupController.mainContentIndeks = indeks
                mainContentPopupController.mainMenuItems = menuItems
                mainContentPopupController.mainMenuIndeks = mainMenuIndeks
                mainContentPopupController.kantorItems = anakItems
                mainContentPopupController.kantorItemsIndeks = anakItemsIndeks
                self.presentViewController(mainContentPopupController, animated: true, completion: nil)                
            }
        }        
    }
    
    func showUbahPasswordViews() {
        ubahPasswordController = UbahPasswordViewController(nibName: "UbahPasswordViewController", bundle: nil)
        ubahPasswordController.ubahPasswordDelegate = self
        ubahPasswordController.view.backgroundColor = UIColor.clearColor()
        ubahPasswordController.view.opaque = false
        ubahPasswordController.preferredContentSize = CGSizeMake(300, 242)
        ubahPasswordController.modalPresentationStyle = .Popover
        ubahPasswordController.popoverPresentationController!.delegate = self
        self.presentViewController(ubahPasswordController, animated: true, completion: nil)        
    }
    
    func setupCabangItemsIndeks(headerIndeks: Int) {
        cabangItemsIndeks = headerIndeks
    }
    
    func setupAnakItemsIndeks(headerIndeks: Int) {
        anakItemsIndeks = headerIndeks
    }
    
    func logoutFromDashboard() {
        print(SmartbookUtility.getUserDefaults().valueForKey("prefLogin"))
        let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginNavigationController") as! UINavigationController
        navigationController.navigationBar.hidden = true
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = navigationController
    }
    
    func showDashboardLogoutAlert(message: String) {
        let alertController = UIAlertController(title: "Peringatan", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ya", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            self.logoutFromDashboard()
        }
        let noAction = UIAlertAction(title: "Tidak", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(noAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showDashboardAlert(message: String) {
        let alertController = UIAlertController(title: "Peringatan", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Tutup", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    /*
    // MARK - UIPopOverPresentationController Delegate Method
    */
    func prepareForPopoverPresentation(popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.permittedArrowDirections = .Any
        popoverPresentationController.sourceView = dashboardContainerView
        popoverPresentationController.sourceRect = CGRectMake(dashboardContainerView.frame.size.width / 2, dashboardContainerView.frame.size.height, 0, 0)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    /*
    //MARK - UIPickerView Delegate Method
    */
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return (cabangItems != nil) ? cabangItems.count : 0;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return (cabangItems != nil) ? String(format: "%@", cabangItems[row]["kantor_desc"] as! String) : "";
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.setupCabangItemsIndeks(row)
        self.dismissViewControllerAnimated(true, completion: { Void -> () in
            self.showDashboardContentViewControllerForIndex(1)
        })

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

extension DashboardViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}
