//
//  MenuViewController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 8/29/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import Alamofire

class MenuViewController: UITableViewController {
    
    var cellIdentifier: String! = "cellLeft"
    var cellHeaderIdentifier: String! = "menuHeaderCell"
    var cellFooterIndentifier: String! = "menuFooterCell"
    var ratioWidth: CGFloat = 0.0
    var ratioHeight: CGFloat = 0.0
    var mainViewController: UIViewController!
    weak var menuDelegate: DashboardViewController!
    var responseMenu: NSDictionary!
    var menuItems: Array<AnyObject>! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // print(menuItems.description)
        
        self.tableView.registerNib(UINib(nibName: "MenuHeaderViewCell", bundle: nil), forCellReuseIdentifier: cellHeaderIdentifier)
        self.tableView.registerNib(UINib(nibName: "MenuFooterViewCell", bundle: nil), forCellReuseIdentifier: cellFooterIndentifier)
        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        //self.tableView.reloadData()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupRatioWidthAndHeightBasedOnDeviceScreen(orientation: Bool) {
        ratioWidth = (orientation == true) ? SmartbookUtility.setupRatioWidthBasedOnLandscape() : SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = (orientation == true) ? SmartbookUtility.setupRatioHeightBasedOnLandscape() : SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
        
        self.tableView.frame = self.view.bounds
        
        self.view.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(1.0)
        self.tableView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(1.0)
        
        //print(self.menuItems.description)
    }
    
    func setupMenuIcons(imageIcon: UIImageView, urlString: String) {
        Alamofire.request(.GET, urlString,
            parameters: nil)
            .responseJSON { response in
                
                imageIcon.image = UIImage(data: response.data!)
        }
    }
    
    func actionUbahPassword(sender: UITapGestureRecognizer) {
        self.closeLeft()
        menuDelegate.showUbahPasswordViews()
    }
    
    func actionLogout(sender: UITapGestureRecognizer) {
        self.closeLeft()
        SmartbookUtility.getUserDefaults().setValue(false, forKey: "prefLogin")
        SmartbookUtility.getUserDefaults().synchronize()
        menuDelegate.showDashboardLogoutAlert("Logout dari Smartbook?")
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // print("The number is \(menuNames.count)")
        return menuItems.count - 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
           let cell = tableView.dequeueReusableCellWithIdentifier(cellHeaderIdentifier) as! MenuHeaderViewCell

            if (menuItems.count > 0) {
                let urlImage = String(format: "%@%@", ConstantAPI.getImageBaseURL(), menuItems[indexPath.row]["icon"] as! String)
                print(urlImage)
                self.setupMenuIcons(cell.menuHeaderIcon, urlString: urlImage)
                cell.menuHeaderTitle.text = menuItems[indexPath.row]["nama"] as? String
            }
            
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
            cell.backgroundView = nil
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! MenuCell

            if (menuItems.count > 0) {
                let urlImage = String(format: "%@%@", ConstantAPI.getImageBaseURL(), menuItems[indexPath.row]["icon"] as! String)
                self.setupMenuIcons(cell.menuIcon, urlString: urlImage)
                cell.menuTitle.text = menuItems[indexPath.row]["nama"] as? String
            }
            
            if (indexPath.row == 1) {
                cell.menuIconLeft.constant = cell.menuIconLeft.constant * 4
                cell.resizeMenuIconWidthAndHeight()
                cell.menuTitleLeft.constant = cell.menuTitleLeft.constant * 2
                cell.menuTitle.font = cell.menuTitle.font.fontWithSize(CGFloat(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 17))
            }else{
                cell.menuTitle.font = cell.menuTitle.font.fontWithSize(CGFloat(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 20))
            }

            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
            cell.backgroundView = nil
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellFooterIndentifier) as! MenuFooterViewCell
        
        cell.menuFooterTitle1.text = "Ubah Password"
        let tapUbahPassword = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.actionUbahPassword(_:)))
        cell.menuFooterTitle1.addGestureRecognizer(tapUbahPassword)
        
        cell.menuFooterTitle.text = "Logout"
        let tapLogout = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.actionLogout(_:)))
        cell.menuFooterTitle.addGestureRecognizer(tapLogout)

        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (indexPath.row == 0) ? ratioHeight * 411 : ratioHeight * 65.0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return ratioHeight * 140.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Clicked")
        self.closeLeft()
        if (indexPath.row == 1) {
            menuDelegate.cabangItemsIndeks = 0
        }else if (indexPath.row == 2 || indexPath.row == 3) {
            menuDelegate.anakItemsIndeks = 0
        }        
        menuDelegate.showDashboardContentViewControllerForIndex(indexPath.row)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
