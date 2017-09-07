//
//  PersonalInfoViewController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 8/30/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit

class PersonalInfoViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var personalSearchBar: UISearchBar!
    @IBOutlet weak var personalInfoList: UIView!
    var personalInfoListController: PersonalInfoListViewController!
    var ratioWidth: CGFloat = 0.0
    var ratioHeight: CGFloat = 0.0
    weak var personalInfoDelegate: DashboardViewController!
    var personalInfoIndicator: UIActivityIndicatorView!
    var personalInfoIndicatorView: UIView!
    var personalInfoNppKepalaCabang: String! = ""
    @IBOutlet weak var personalInfoSearchBarHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        personalSearchBar.delegate = self
        self.setupRatioWidthAndHeightBasedOnDeviceScreen()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupRatioWidthAndHeightBasedOnDeviceScreen() {
        ratioWidth = SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
        
        personalInfoSearchBarHeight.constant = 44.0
        personalInfoList.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(personalInfoList.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        
        self.setupPersonalInfoIndicatorView()

        print(personalInfoNppKepalaCabang)
        if (personalInfoNppKepalaCabang == "") {
            self.setupPersonalInfoListView("")
        }else{
            self.setupPersonalInfoListView(personalInfoNppKepalaCabang)
        }
    }
    
    func setupPersonalInfoListView(searchText: String) {
        self.showPersonalInfoIndicatorView()
        personalInfoListController = PersonalInfoListViewController(nibName: "PersonalInfoListViewController", bundle: nil)
        personalInfoListController.personalInfoListDelegate = self
        personalInfoListController.keyWord = searchText
        personalInfoListController.personalInfoNpp = ""
        self.addChildViewController(personalInfoListController)
        personalInfoListController.view.frame = personalInfoList.bounds
        personalInfoList.addSubview(personalInfoListController.view)
        personalInfoListController.didMoveToParentViewController(self)
    }
    
    func setupPersonalInfoViewFromSearch(searchText: String) {
        self.showPersonalInfoIndicatorView()
        if (personalInfoListController != nil) {
            personalInfoListController.removeFromParentViewController()
            personalInfoListController = nil
        }
        personalInfoListController = PersonalInfoListViewController(nibName: "PersonalInfoListViewController", bundle: nil)
        personalInfoListController.personalInfoListDelegate = self
        personalInfoListController.keyWord = searchText
        personalInfoListController.personalInfoNpp = ""
        self.addChildViewController(personalInfoListController)
        personalInfoListController.view.frame = personalInfoList.bounds
        personalInfoList.addSubview(personalInfoListController.view)
        personalInfoListController.didMoveToParentViewController(self)
    }
    
//    func setupPersonalInfoViewByNpp(npp: String) {
//        self.showPersonalInfoIndicatorView()
//        if (personalInfoListController != nil) {
//            personalInfoListController.removeFromParentViewController()
//            personalInfoListController = nil
//        }
//        personalInfoListController = PersonalInfoListViewController(nibName: "PersonalInfoListViewController", bundle: nil)
//        personalInfoListController.personalInfoListDelegate = self
//        personalInfoListController.keyWord = ""
//        personalInfoListController.personalInfoNpp = npp
//        self.addChildViewController(personalInfoListController)
//        personalInfoListController.view.frame = personalInfoList.bounds
//        personalInfoList.addSubview(personalInfoListController.view)
//        personalInfoListController.didMoveToParentViewController(self)
//    }
    
    func setupPersonalInfoIndicatorView() {
        personalInfoIndicatorView = UIView()
        personalInfoIndicatorView.frame = CGRectMake(0, 0, 76, 76)
        personalInfoIndicatorView.center = self.view.center
        personalInfoIndicatorView.backgroundColor = SmartbookUtility.colorWithHexString("3FAED6")
        personalInfoIndicatorView.alpha = 0.75
        personalInfoIndicatorView.layer.cornerRadius = 10.0
        personalInfoIndicatorView.layer.masksToBounds = true
        
        personalInfoIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        personalInfoIndicator.transform = CGAffineTransformMakeScale(2.0, 2.0)
        personalInfoIndicator.center = personalInfoIndicatorView.center
        
        self.view.addSubview(personalInfoIndicatorView)
        self.view.addSubview(personalInfoIndicator)
        self.view.bringSubviewToFront(personalInfoIndicatorView)
        self.view.bringSubviewToFront(personalInfoIndicator)
        self.showPersonalInfoIndicatorView()
    }
    
    func beginEditingPersonalInfoSearchBar() {
        personalSearchBar.becomeFirstResponder()
    }
    
    func showPersonalInfoIndicatorView() {
        personalInfoIndicatorView.hidden = false
        personalInfoIndicator.startAnimating()
    }
    
    func dismissPersonalInfoIndicatorView() {
        personalInfoIndicatorView.hidden = true
        personalInfoIndicator.stopAnimating()
    }
    
    /*
    // Mark Search Bar Delegate
    */
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.setupPersonalInfoViewFromSearch(searchBar.text!)
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.setupPersonalInfoListView("")
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
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
