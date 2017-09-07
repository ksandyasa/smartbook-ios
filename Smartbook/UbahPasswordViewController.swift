//
//  UbahPasswordViewController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 10/11/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import QuartzCore
import Alamofire

class UbahPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tpasswordLama: UILabel!
    @IBOutlet weak var passwordLamaField: UITextField!
    @IBOutlet weak var tpasswordBaru: UILabel!
    @IBOutlet weak var passwordBaruField: UITextField!
    @IBOutlet weak var tconfirmPassword: UILabel!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var ubahPasswordSubmit: UIButton!
    var ratioWidth: CGFloat! = 0.0
    var ratioHeight: CGFloat! = 0.0
    var statusResponse: String! = "0"
    var msgResponse: String! = ""
    var passwordLama: String! = ""
    var passwordBaru: String! = ""
    var konfirmPassword: String! = ""
    var personalNpp: String! = ""
    weak var ubahPasswordDelegate: DashboardViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupWidthAndHeightBasedOnDeviceScreen(orientation: Bool) {
        ratioWidth = (orientation == true) ? SmartbookUtility.setupRatioWidthBasedOnLandscape() : SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = (orientation == true) ? SmartbookUtility.setupRatioHeightBasedOnLandscape() : SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
        
        tpasswordLama.lineBreakMode = NSLineBreakMode.ByWordWrapping
        tpasswordLama.numberOfLines = 0
        tpasswordLama.font = tpasswordLama.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 19)
        tpasswordLama.sizeToFit()
        
        passwordLamaField.font = passwordLamaField.font?.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 19)
        
        tpasswordBaru.lineBreakMode = NSLineBreakMode.ByWordWrapping
        tpasswordBaru.numberOfLines = 0
        tpasswordBaru.font = tpasswordBaru.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 19)
        tpasswordBaru.sizeToFit()
        
        passwordBaruField.font = passwordBaruField.font?.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 19)
        
        tconfirmPassword.lineBreakMode = NSLineBreakMode.ByWordWrapping
        tconfirmPassword.numberOfLines = 0
        tconfirmPassword.font = tconfirmPassword.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 19)
        tconfirmPassword.sizeToFit()
        
        confirmPasswordField.font = confirmPasswordField.font?.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 19)
        
        
        tpasswordLama.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(tpasswordLama.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        tpasswordBaru.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(tpasswordBaru.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        tconfirmPassword.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(tconfirmPassword.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        
        passwordLamaField.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(passwordLamaField.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        passwordBaruField.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(passwordBaruField.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        confirmPasswordField.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(confirmPasswordField.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        
        ubahPasswordSubmit.layer.cornerRadius = 5
        ubahPasswordSubmit.layer.masksToBounds = true
        
        passwordLamaField.delegate = self
        passwordBaruField.delegate = self
        confirmPasswordField.delegate = self
        
        if (SmartbookUtility.getUserDefaults().valueForKey("prefPersonalNpp") != nil) {
            personalNpp = SmartbookUtility.getUserDefaults().valueForKey("prefPersonalNpp") as? String
        }
    }
    
    func setupUbahPassword(username: String, oldpass: String, newpass: String) {
        let params = ["apikey" : SmartbookUtility.getUserDefaults().valueForKey("prefApiKey") as! String,
                      "username" : username,
                      "xpass" : oldpass,
                      "newpass" : newpass
        ]
        
        Alamofire.request(.GET, ConstantAPI.getUbahPasswordURL(), parameters: params)
            .responseJSON { response in
                print(response.request)
                switch response.result {
                case .Success(let json):
                    print(json.description)
                    self.msgResponse = json["msg"] as? String
                    self.statusResponse = json["status"] as? String
                    print(self.msgResponse)
                    print(self.statusResponse)
                    self.logoutFromUbahPassword(self.msgResponse, status: self.statusResponse)
                    break
                    
                case .Failure(let error):
                    if let err = error as? NSURLError where err == .NotConnectedToInternet {
                        // no internet connection
                    } else {
                        // other failures
                    }
                    break
                }
                
                
        }
    }
    
    func logoutFromUbahPassword(msg: String, status: String) {
        passwordLamaField.text = ""
        passwordBaruField.text = ""
        confirmPasswordField.text = ""
        passwordLama = ""
        passwordBaru = ""
        konfirmPassword = ""
        if (status == "1") {
            SmartbookUtility.getUserDefaults().setValue("", forKey: "prefPersonalNpp")
            SmartbookUtility.getUserDefaults().setValue(false, forKey: "prefLogin")
            SmartbookUtility.getUserDefaults().synchronize()
            self.showUbahPasswordAlert(msg, mode: "exit")
        }else{
            self.showUbahPasswordAlert(msg, mode: "")
        }
    }
    
    func showUbahPasswordAlert(message: String, mode: String) {
        let alertController = UIAlertController(title: "Peringatan", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Tutup", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            if (mode == "exit") {
                self.ubahPasswordDelegate.logoutFromDashboard()
            }
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func actionUbahPassword(sender: UIButton) {
        passwordLama = passwordLamaField.text
        passwordBaru = passwordBaruField.text
        konfirmPassword = confirmPasswordField.text
        
        if (konfirmPassword != passwordBaru) {
            self.showUbahPasswordAlert("Password Baru dan Konfirmasi Password tidak sama",
                                       mode: "")
        }else{                self.setupUbahPassword(personalNpp,
                                                     oldpass: passwordLama,
                                                     newpass: passwordBaru)
        }
    }
    
    /*
     // MARK - UITextField Delegate Method
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if (textField == passwordLamaField) {
            passwordBaruField.becomeFirstResponder()
        }else if (textField == passwordBaruField ){
            confirmPasswordField.becomeFirstResponder()
        }else if (textField == confirmPasswordField) {
            passwordLama = passwordLamaField.text
            passwordBaru = passwordBaruField.text
            konfirmPassword = confirmPasswordField.text
            
            if (konfirmPassword != passwordBaru) {
                self.showUbahPasswordAlert("Password Baru dan Konfirmasi Password tidak sama", mode: "")
            }else{
                self.setupUbahPassword(personalNpp,
                                       oldpass: passwordLama,
                                       newpass: passwordBaru)
            }
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
