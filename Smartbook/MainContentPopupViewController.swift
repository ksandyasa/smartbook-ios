//
//  MainContentPopupViewController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 9/9/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import Alamofire

class MainContentPopupViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var mainContentPopupTitle: UILabel!
    @IBOutlet weak var mainContentPopupHeader: UIView!
    @IBOutlet weak var mainContentPopupContent: UIWebView!
    @IBOutlet weak var mainContentPopupClose: UIButton!
    var mainContentPopupIndicator: UIActivityIndicatorView!
    var mainContentPopupIndicatorView: UIView!
    var ratioWidth: CGFloat = 0.0
    var ratioHeight: CGFloat = 0.0
    weak var mainContentPopupDelegate: DashboardViewController!
    var mainContentItems: Array<AnyObject>! = []
    var mainContentIndeks: Int!
    var mainMenuItems: Array<AnyObject>! = []
    var mainMenuIndeks: Int!
    var mainContentPopupItems: Array<AnyObject>! = []
    var mainContentString: String! = ""
    var kantorItems : Array<AnyObject>! = [];
    var kantorItemsIndeks: Int!
    @IBOutlet weak var mainContentPopupHeaderHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        mainContentPopupDelegate.dismissViewControllerAnimated(true, completion: { Void in
            let tempContentItems: Array<AnyObject> = self.mainContentItems
            let tempContentItemIndeks: Int = self.mainContentIndeks
            self.mainContentPopupDelegate.mainContentPopupController = nil
            self.mainContentPopupDelegate.showMainContentViewPopUp(tempContentItems, indeks: tempContentItemIndeks)
        })
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
        
        mainContentPopupHeader.frame.size.width = self.view.bounds.size.width
        mainContentPopupHeaderHeight.constant = 44.0
        
        self.setupMainContentPopupHeaderWithGradientColor("0D7BD4")
        
        mainContentPopupTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        mainContentPopupTitle.numberOfLines = 0
        mainContentPopupTitle.font = mainContentPopupTitle.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 21)
        mainContentPopupTitle.sizeToFit()
        
        mainContentPopupContent.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(mainContentPopupContent.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        
        self.view.setNeedsUpdateConstraints()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        print("mainMenuItems = : ", mainMenuIndeks)
        print("mainMenuId = : ", (mainMenuItems[mainMenuIndeks]["id"] as? Int)!)
        print("mainContentIndeks = : ", mainContentIndeks)
        print("mainContentId = : ", (mainContentItems[mainContentIndeks]["id"] as? Int)!)
        print("kantorItemIndeks = : ", kantorItemsIndeks)
        print("kantorId = : ", (kantorItems[kantorItemsIndeks]["id"] as? Int)!)
        if (mainMenuIndeks == 0) {
            if (mainContentIndeks == 3 || mainContentIndeks == 4) {
                mainContentPopupContent.scrollView.pagingEnabled = false
                mainContentPopupContent.scrollView.bounces = false
                mainContentPopupContent.scrollView.scrollEnabled = true
            }else if (mainContentIndeks == 2) {
                mainContentPopupContent.scrollView.pagingEnabled = false
                mainContentPopupContent.scrollView.bounces = false
                mainContentPopupContent.scrollView.scrollEnabled = true
                mainContentPopupContent.scalesPageToFit = true
            }else{
                mainContentPopupContent.paginationMode = UIWebPaginationMode.LeftToRight
                mainContentPopupContent.paginationBreakingMode = UIWebPaginationBreakingMode.Page
                mainContentPopupContent.scrollView.pagingEnabled = true
                mainContentPopupContent.scrollView.bounces = false
                mainContentPopupContent.scrollView.backgroundColor = UIColor.whiteColor()
            }
        }else {
            mainContentPopupContent.scrollView.pagingEnabled = false
            mainContentPopupContent.scrollView.bounces = false
            mainContentPopupContent.scrollView.scrollEnabled = true
            mainContentPopupContent.scalesPageToFit = true
        }
        mainContentPopupContent.delegate = self
        
        mainContentPopupClose.addTarget(self, action: #selector(MainContentPopupViewController.dismissOPan), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.setupMainContentPopupItems()
    }
    
    func setupMainContentPopupItems() {
        let mainMenuId = String(format: "%d", mainMenuItems[mainMenuIndeks]["id"] as! Int)
        let subMenuId = String(format: "%d", mainContentItems[mainContentIndeks]["id"] as! Int)
        let kantorId = String(format: "%d", kantorItems[kantorItemsIndeks]["kantor_id"] as! Int)
        let urlContent = (mainMenuId == "1") ? ConstantAPI.getPusatURL() : ConstantAPI.getCabangURL()
        if (mainMenuId == "1") {
            let params = [
                "mainmenu_id" : mainMenuId,
                "menu_id": subMenuId,
                "npp" : SmartbookUtility.getUserDefaults().valueForKey("prefPersonalNpp") as! String,
                "api_token" : SmartbookUtility.getUserDefaults().valueForKey("prefApiKey") as! String
            ]
            
            Alamofire.request(.POST, urlContent,
                parameters: params)
                .responseJSON { response in
                    print(response.request)
                    if let JSON = response.result.value {
                        self.mainContentPopupItems = JSON["data"] as? Array<AnyObject>
                        //print(self.mainContentPopupItems.description)
                        self.setupMainContentPopupView()
                    }
                    self.mainContentPopupDelegate.dismissDashboardIndicatorView()
            }
        }else{
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
                        print(self.mainContentPopupItems.description)
                        self.setupMainContentPopupView()
                    }
                    self.mainContentPopupDelegate.dismissDashboardIndicatorView()
            }
        }        
    }
    
    func setupMainContentPopupView() {
        mainContentPopupTitle.text = String(format: "%@", mainContentItems[mainContentIndeks]["nama"] as! String)
        //print("mainContentTitle : ", String(format: "%@", mainContentItems[mainContentIndeks]["nama"] as! String))
        
        if (mainContentPopupItems.count > 0) {
            let arrayOfKeys: NSArray = mainContentPopupItems[0].allKeys
            
            if (arrayOfKeys.containsObject("introtext")) {
                mainContentString = mainContentPopupItems[0]["introtext"] as! String
            }else if (arrayOfKeys.containsObject("konten")) {
                mainContentString = mainContentPopupItems[0]["konten"] as! String
            }else if (arrayOfKeys.containsObject("struktur")) {
                mainContentString = mainContentPopupItems[0]["struktur"] as! String
            }else if (arrayOfKeys.containsObject("kontent")) {
                mainContentString = mainContentPopupItems[0]["kontent"] as! String
            }else if (arrayOfKeys.containsObject("npp")) {
                mainContentString = mainContentPopupItems[0]["npp"] as! String
            }
            //print("mainContentString : ", mainContentString)
            
            if (mainMenuIndeks == 0) {
                if (mainContentIndeks == 2 || mainContentIndeks == 3 || mainContentIndeks == 4) {
                    mainContentPopupContent.loadHTMLString(mainContentString.stringByReplacingOccurrencesOfString("<img src=\"", withString: "<img src=\"http://202.158.49.221:8000/"), baseURL: NSURL())
                }else if (mainContentIndeks == 7) {
                    let stringUrl: String = String(format: "http://202.158.49.221:8000/download/Anggaran_dasar_ina.pdf")
                    let urlString = NSURLRequest(URL: NSURL(string: stringUrl)!)
                    mainContentPopupContent.loadRequest(urlString)
                }else{
                    mainContentPopupContent.loadHTMLString(mainContentString, baseURL: NSURL())
                }
            }else if (mainMenuIndeks == 1) {
                if (mainContentIndeks == 1) {
                    let urlString = NSURLRequest(URL: NSURL(string: mainContentString.stringByReplacingOccurrencesOfString("http://www.jasamarga.com", withString: "http://202.158.49.221:8000"))!)
                    mainContentPopupContent.loadRequest(urlString)
                }else{
                    mainContentPopupContent.loadHTMLString(mainContentString.stringByReplacingOccurrencesOfString("<img src=\"", withString: "<img src=\"http://202.158.49.221:8000/"), baseURL: NSURL())
                }
            }else if (mainMenuIndeks == 2) {
                if (mainContentIndeks == 3) {
                    let stringHTML = String(format: "%@%@", ConstantAPI.getImageBaseURL(), mainContentString)
                    let urlString = NSURLRequest(URL: NSURL(string: stringHTML)!)
                    mainContentPopupContent.loadRequest(urlString)
                }else{
                    mainContentPopupContent.loadHTMLString(mainContentString, baseURL: NSURL())
                }
            }else if (mainMenuIndeks == 3) {
                if (mainContentIndeks == 3) {
                    let stringHTML = String(format: "%@%@", ConstantAPI.getImageBaseURL(), mainContentString)
                    let urlString = NSURLRequest(URL: NSURL(string: stringHTML)!)
                    mainContentPopupContent.loadRequest(urlString)
                }else{
                    mainContentPopupContent.loadHTMLString(mainContentString, baseURL: NSURL())
                }
            }
        }        
    }
    
    func setupMainContentPopupIndicatorView() {
        mainContentPopupIndicatorView = UIView()
        mainContentPopupIndicatorView.frame = CGRectMake(0, 0, 76, 76)
        mainContentPopupIndicatorView.center = self.view.center
        mainContentPopupIndicatorView.backgroundColor = SmartbookUtility.colorWithHexString("3FAED6")
        mainContentPopupIndicatorView.alpha = 0.75
        mainContentPopupIndicatorView.layer.cornerRadius = 10.0
        mainContentPopupIndicatorView.layer.masksToBounds = true
        
        mainContentPopupIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        mainContentPopupIndicator.transform = CGAffineTransformMakeScale(2.0, 2.0)
        mainContentPopupIndicator.center = mainContentPopupIndicatorView.center
        
        self.view.addSubview(mainContentPopupIndicatorView)
        self.view.addSubview(mainContentPopupIndicator)
        self.view.bringSubviewToFront(mainContentPopupIndicatorView)
        self.view.bringSubviewToFront(mainContentPopupIndicator)
        self.showMainContentPopupIndicatorView()
    }
    
    func setupMainContentPopupHeaderWithGradientColor(color: String) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = mainContentPopupHeader.bounds
        gradient.colors = [SmartbookUtility.colorWithHexString("0D7BD4").CGColor,
                           SmartbookUtility.colorWithHexString("3FAED6").CGColor,
                           SmartbookUtility.colorWithHexString("0D7BD4").CGColor]
        mainContentPopupHeader.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    func showMainContentPopupIndicatorView() {
        mainContentPopupIndicatorView.hidden = false
        mainContentPopupIndicator.startAnimating()
    }
    
    func dismissMainContentPopupIndicatorView() {
        mainContentPopupIndicatorView.hidden = true
        mainContentPopupIndicator.stopAnimating()
    }
    
    func dismissOPan() {
        print("pan gesture")
        
        mainContentPopupDelegate.dismissViewControllerAnimated(true, completion: { Void in
            self.mainContentPopupDelegate.mainContentPopupController = nil
        })
        
        //        if gestureRecognizer.state == UIGestureRecognizerState.Began || gestureRecognizer.state == UIGestureRecognizerState.Changed {
        //
        //            let translation = gestureRecognizer.translationInView(self.view)
        //            // note: 'view' is optional and need to be unwrapped
        //            gestureRecognizer.view!.center = CGPointMake(gestureRecognizer.view!.center.x, gestureRecognizer.view!.center.y + translation.y)
        //            gestureRecognizer.setTranslation(CGPointMake(0,0), inView: self.view)
        //
        //        }else if gestureRecognizer.state == UIGestureRecognizerState.Ended {
        //            mainSlidePopupDelegate.navigationController?.popToRootViewControllerAnimated(true)
        //        }
    }

    func dismissDashboardIndicatorFromContentPopup() {
        mainContentPopupDelegate.dismissDashboardIndicatorView()
    }
    
    /*
    // MARK - UIWebView Delegate Method
    */
    func webViewDidStartLoad(webView_Pages: UIWebView) {
        self.setupMainContentPopupIndicatorView()
    }
    
    func webViewDidFinishLoad(webView_Pages: UIWebView) {
        self.dismissMainContentPopupIndicatorView()
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
