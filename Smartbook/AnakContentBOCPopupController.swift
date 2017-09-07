//
//  AnakContentBOCPopupController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 9/16/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import Alamofire
import QuartzCore

class AnakContentBOCPopupController: UIViewController {

    @IBOutlet weak var anakContentBOCPopupPict: UIImageView!
    weak var anakContentBOCPopupDelegate: AnakContentBOCViewController!
    var ratioWidth:  CGFloat! = 0.0
    var ratioHeight: CGFloat! = 0.0
    var anakContentBOCName: String! = ""
    var anakContentBOCJabatan: String! = ""
    var anakContentBOCPict: String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupWidthAndHeightBasedOnDeviceScreen()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupWidthAndHeightBasedOnDeviceScreen() {
        ratioWidth = SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
        
        self.view.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(self.view.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        
        anakContentBOCPopupPict.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(anakContentBOCPopupPict.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        
        self.setupAnakContentBOCPopupView()
    }
    
    func setupAnakContentBOCPopupView() {
        self.setupAnakContentBOCPict(anakContentBOCPopupPict, urlString: anakContentBOCPict)
        
        let tapDismiss = UITapGestureRecognizer(target: self, action: #selector(AnakContentBOCPopupController.dismissAnakContentBOCPopupView(_:)))
        self.view.addGestureRecognizer(tapDismiss)
    }
    
    func setupAnakContentBOCPict(imageIcon: UIImageView, urlString: String) {
        Alamofire.request(.GET, urlString,
            parameters: nil)
            .responseJSON { response in
                
                imageIcon.image = UIImage(data: response.data!)                
        }
    }
    
    func dismissAnakContentBOCPopupView(sender: UITapGestureRecognizer) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
