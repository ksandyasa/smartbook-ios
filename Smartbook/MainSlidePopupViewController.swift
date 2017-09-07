//
//  MainSlidePopupViewController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 9/9/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit

class MainSlidePopupViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var mainSlidePopupTitle: UILabel!
    @IBOutlet weak var mainSlidePopupHeader: UIView!
    @IBOutlet weak var mainSlidePopupContent: UIWebView!
    @IBOutlet weak var mainSlidePopupClose: UIButton!
    var ratioWidth: CGFloat = 0.0
    var ratioHeight: CGFloat = 0.0
    var indeksPage: Int!
    var mainSlideItems: Array<AnyObject>! = []
    var gradient: CAGradientLayer!
    weak var mainSlidePopupDelegate: DashboardViewController!
    @IBOutlet weak var mainSlidePopupHeaderHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        mainSlidePopupDelegate.dismissViewControllerAnimated(true, completion: { Void in
            let tempSlideItems: Array<AnyObject> = self.mainSlideItems
            let tempIndeksPage: Int = self.indeksPage
            self.mainSlidePopupDelegate.mainSlidePopupController = nil
            self.mainSlidePopupDelegate.showMainSlideViewPopUp(tempSlideItems, indeksPage: tempIndeksPage)
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
        
        mainSlidePopupHeader.frame.size.width = self.view.bounds.size.width
        mainSlidePopupHeaderHeight.constant = 44.0
        
        self.setupMainSlidePopupHeaderWithGradientColor("0D7BD4")
        
        mainSlidePopupTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        mainSlidePopupTitle.numberOfLines = 0
        mainSlidePopupTitle.font = mainSlidePopupTitle.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 19)
        mainSlidePopupTitle.sizeToFit()
        
        mainSlidePopupContent.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(mainSlidePopupContent.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
//        mainSlidePopupContent.paginationMode = UIWebPaginationMode.LeftToRight
//        mainSlidePopupContent.paginationBreakingMode = UIWebPaginationBreakingMode.Page
        mainSlidePopupContent.delegate = self
        mainSlidePopupContent.scrollView.delegate = self
        mainSlidePopupContent.scrollView.scrollEnabled = true
        mainSlidePopupContent.scrollView.pagingEnabled = false
        mainSlidePopupContent.scrollView.bounces = false
        mainSlidePopupContent.scrollView.backgroundColor = UIColor.whiteColor()
        
        self.view.setNeedsUpdateConstraints()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        mainSlidePopupClose.addTarget(self, action: #selector(MainSlidePopupViewController.dismissOPan), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.setupMainSlidePopupView()
    }
    
    func setupMainSlidePopupView() {
        mainSlidePopupTitle.text = String(format: "%@", mainSlideItems[indeksPage]["Nama"] as! String)
        
        let fontContent = UIFont(name: "Arial", size: SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 19)
        let stringContent = String(format: "<html><style type=\"text/css\">body { background-color:transparent;width:100%%;max-width:100%%;font-family:%@;font-size:%f;color: #708090;}</style><body>%@</body></html>", (fontContent?.fontName)!,
                                   (fontContent?.pointSize)!,
                                   mainSlideItems[indeksPage]["fulltext"] as! String)
        mainSlidePopupContent.loadHTMLString(stringContent.stringByReplacingOccurrencesOfString("<img src=\"", withString: "<img src=\"http://202.158.49.221:8000/").stringByReplacingOccurrencesOfString("http://www.jasamarga.com", withString: "http://202.158.49.221:8000"), baseURL: NSURL())
    }
    
    func setupMainSlidePopupHeaderWithGradientColor(color: String) {
        gradient = CAGradientLayer()
        gradient.frame = mainSlidePopupHeader.bounds
        gradient.colors = [SmartbookUtility.colorWithHexString("0D7BD4").CGColor,
                           SmartbookUtility.colorWithHexString("3FAED6").CGColor,
                           SmartbookUtility.colorWithHexString("0D7BD4").CGColor]
        mainSlidePopupHeader.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    func dismissOPan() {
        print("pan gesture")
        
        mainSlidePopupDelegate.dismissViewControllerAnimated(true, completion: { Void in
            self.mainSlidePopupDelegate.mainSlidePopupController = nil
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
    
    /*
     // MARK - UIWebView Delegate Method
     */
    func webViewDidFinishLoad(webView_Pages: UIWebView) {
        let contentSize: CGSize = webView_Pages.scrollView.contentSize;
        let viewSize: CGSize = webView_Pages.bounds.size;
        
        let rw: CGFloat = viewSize.width / contentSize.width;
        
        webView_Pages.scrollView.minimumZoomScale = rw;
        webView_Pages.scrollView.maximumZoomScale = rw;
        webView_Pages.scrollView.zoomScale = rw;
    }
    
    /*
    // MARK - UIScrollView Delegate Method
    */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.x > 0){
            scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y)
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
