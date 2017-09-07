//
//  LoginViewController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 9/28/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var loginBg: UIImageView!
    @IBOutlet weak var loginInputView: UIView!
    @IBOutlet weak var loginIconUser: UIImageView!
    @IBOutlet weak var loginIconPass: UIImageView!
    @IBOutlet weak var loginUserField: UITextField!
    @IBOutlet weak var loginPassField: UITextField!
    @IBOutlet weak var loginSubmitBtn: UIButton!
    @IBOutlet weak var loginLogoPict: UIImageView!
    @IBOutlet weak var loginBgHeight: NSLayoutConstraint!
    @IBOutlet weak var loginInputViewWidth: NSLayoutConstraint!
    @IBOutlet weak var loginInputViewHeight: NSLayoutConstraint!
    @IBOutlet weak var loginLogoPictWidth: NSLayoutConstraint!
    @IBOutlet weak var loginLogoPicthHeight: NSLayoutConstraint!
    @IBOutlet weak var loginContainerViewTop: NSLayoutConstraint!
    @IBOutlet weak var loginLogoPictTop: NSLayoutConstraint!
    var loginIndicator: UIActivityIndicatorView!
    var loginIndicatorView: UIView!
    var ratioWidth: CGFloat! = 0.0
    var ratioHeight: CGFloat! = 0.0
    var loginItems: Array<AnyObject> = []
    var loginMessage: String? = ""
    var dashboardViewController: DashboardViewController!
    var loginUserDefaults: NSUserDefaults!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loginUserDefaults = SmartbookUtility.getUserDefaults()
        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupRatioWidthAndHeightBasedOnDeviceScreen(orientation: Bool) {
        ratioWidth = (orientation == true) ? SmartbookUtility.setupRatioWidthBasedOnLandscape() : SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = (orientation == true) ? SmartbookUtility.setupRatioHeightBasedOnLandscape() : SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
        
        print(ratioWidth)
        print(ratioHeight)
        
        loginBg.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(loginBg.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        loginBgHeight.constant = (ratioHeight > 1) ? loginBgHeight.constant * 2 : ratioHeight * loginBgHeight.constant
        print(loginBgHeight.constant)
        
        loginContainerView.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(loginContainerView.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        loginContainerViewTop.constant = (ratioHeight > 1) ? loginContainerViewTop.constant * 2 : loginContainerViewTop.constant
        
        loginLogoPicthHeight.constant = ratioHeight * loginLogoPicthHeight.constant
        loginLogoPictWidth.constant = loginLogoPicthHeight.constant
        loginLogoPictTop.constant = (ratioHeight < 1) ? loginContainerViewTop.constant - (loginLogoPicthHeight.constant / 2) : (ratioHeight > 1) ? loginContainerViewTop.constant * 2 : loginLogoPictTop.constant
        
        loginInputViewWidth.constant = (ratioWidth < 1) ? loginInputViewWidth.constant - 80 : loginInputViewWidth.constant
        loginInputView.layer.cornerRadius = 5
        loginInputView.layer.masksToBounds = true
        
        loginIconUser.image = loginIconUser.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        loginIconUser.tintColor = SmartbookUtility.colorWithHexString("0D7BD4")
        
        loginIconPass.image = loginIconPass.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        loginIconPass.tintColor = SmartbookUtility.colorWithHexString("0D7BD4")
        
        loginSubmitBtn.layer.cornerRadius = 5
        loginSubmitBtn.layer.masksToBounds = true
        
        self.view.setNeedsUpdateConstraints()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        loginUserField.delegate = self
        loginPassField.delegate = self
        
        self.setupLoginIndicatorView()
        self.addDoneButtonOnKeyboard()
        self.navigationController?.navigationBar.hidden = true
        
        if (loginUserDefaults.valueForKey("prefLogin") != nil) {
            let isLogin = loginUserDefaults.valueForKey("prefLogin") as? Bool
            if (isLogin == true) {
                self.setupDashboardViewWithoutLogin()
            }
        }
        
    }
    
    @IBAction func ActionLogin(sender: UIButton) {
        let username = loginUserField.text
        let password = loginPassField.text
        
        self.showLoginIndicatorView()
        self.setupLoginItems(username!, password: password!)
    }
    
    func setupLoginItems(username: String, password: String) {
        let params = ["npp" : username,
                      "password": password
        ]
        
        Alamofire.request(.POST, ConstantAPI.getLoginURL(), parameters: params)
            .responseJSON { response in
                                
                switch response.result {
                    case .Success(let json):
                        self.loginPassField.resignFirstResponder()
                        self.dismissLoginIndicatorView()
                        self.loginMessage = json["message"] as? String
                        print(self.loginMessage)
                        if (self.loginMessage == "success !") {
                            self.loginItems = (json["data"] as? Array<AnyObject>)!
                            GlobalVariable.sharedInstance.itemLogin = (json["data"] as? Array<AnyObject>)!
                            self.setupDashboardView(self.loginItems)
                        }else{
                            self.showLoginAlert(self.loginMessage!)
                        }
                    break
                    
                    case .Failure(let error):
                        if let err = error as? NSURLError where err == .NotConnectedToInternet {
                            // no internet connection
                            self.dismissLoginIndicatorView()
                            self.showLoginAlert("Tidak ada koneksi internet")
                        } else {
                            // other failures
                            self.dismissLoginIndicatorView()
                            self.showLoginAlert("Terjadi kegagalan pengambilan data")
                        }
                    break
                }
                
        }
    }
    
    func setupDashboardView(items: Array<AnyObject>) {
        loginUserDefaults.setValue(items[0]["api_token"], forKey: "prefApiKey")
        loginUserDefaults.setValue(items[0]["npp"], forKey: "prefPersonalNpp")
        loginUserDefaults.setValue(true, forKey: "prefLogin")
        loginUserDefaults.synchronize()
        dashboardViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DashboardViewController") as! DashboardViewController
        let navigationController = UINavigationController(rootViewController: dashboardViewController)
        navigationController.navigationBar.hidden = true
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = navigationController
    }
    
    func setupDashboardViewWithoutLogin() {
        dashboardViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DashboardViewController") as! DashboardViewController
        let navigationController = UINavigationController(rootViewController: dashboardViewController)
        navigationController.navigationBar.hidden = true
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = navigationController
    }
    
    func showLoginAlert(message: String) {
        let alertController = UIAlertController(title: "Peringatan", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Tutup", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func setupLoginIndicatorView() {
        loginIndicatorView = UIView()
        loginIndicatorView.frame = CGRectMake(0, 0, 76, 76)
        loginIndicatorView.center = self.view.center
        loginIndicatorView.backgroundColor = SmartbookUtility.colorWithHexString("3FAED6")
        loginIndicatorView.alpha = 0.75
        loginIndicatorView.layer.cornerRadius = 10.0
        loginIndicatorView.layer.masksToBounds = true
        loginIndicatorView.hidden = true
        
        loginIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        loginIndicator.transform = CGAffineTransformMakeScale(2.0, 2.0)
        loginIndicator.center = loginIndicatorView.center
        
        self.view.addSubview(loginIndicatorView)
        self.view.addSubview(loginIndicator)
        self.view.bringSubviewToFront(loginIndicatorView)
        self.view.bringSubviewToFront(loginIndicator)
    }
    
    func showLoginIndicatorView() {
        loginIndicatorView.hidden = false
        loginIndicator.startAnimating()
    }
    
    func dismissLoginIndicatorView() {
        loginIndicatorView.hidden = true
        loginIndicator.stopAnimating()
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(LoginViewController.doneButtonAction))
        
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        
        loginPassField.inputAccessoryView = doneToolbar
        
    }
    
    func doneButtonAction()
    {
        loginPassField.resignFirstResponder()
    }
    
    /*
    // MARK - UITextField Delegate Method
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if (textField == loginUserField) {
            loginPassField.becomeFirstResponder()
        }else if (textField == loginPassField ){
            let username = loginUserField.text
            let password = loginPassField.text
            
            self.showLoginIndicatorView()
            self.setupLoginItems(username!, password: password!)
        }
        
        return true
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
