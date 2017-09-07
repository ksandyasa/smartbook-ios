//
//  PenghargaanViewController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 9/14/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import Alamofire

class PenghargaanViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,
 UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var penghargaanHeader: UIView!
    @IBOutlet weak var penghargaanTitle: UILabel!
    @IBOutlet weak var penghargaanClose: UIButton!
    @IBOutlet weak var penghargaanYear: UICollectionView!
    @IBOutlet weak var penghargaanList: UITableView!
    @IBOutlet weak var penghargaanHeaderHeight: NSLayoutConstraint!
    var ratioWidth: CGFloat! = 0.0
    var ratioHeight: CGFloat! = 0.0
    weak var penghargaanDelegate: DashboardViewController!
    var mainContentItems: Array<AnyObject>! = []
    var mainContentIndeks: Int!
    var mainMenuItems: Array<AnyObject>! = []
    var mainMenuIndeks: Int!
    var mainContentPopupItems: Array<AnyObject>! = []
    var penghargaanYearItems: Array<AnyObject>! = []
    var penghargaanListItems: [String:Array<AnyObject>]! = [:]
    var keyYear: String! = ""
    var penghargaanYearItemIndex: Int! = 0
    var cellYearIdentifier: String! = "penghargaanYearCell"
    var cellListIdentifier: String! = "penghargaanListCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        penghargaanYear.registerNib(UINib(nibName: "PenghargaanYearCell", bundle: nil), forCellWithReuseIdentifier: cellYearIdentifier)
        penghargaanList.registerNib(UINib(nibName: "PenghargaanListCell", bundle: nil), forCellReuseIdentifier: cellListIdentifier)
        self.setupWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        penghargaanDelegate.dismissViewControllerAnimated(true, completion: { Void in
            let tempContentItems: Array<AnyObject> = self.mainContentItems
            let tempContentIndeks: Int = self.mainContentIndeks
            self.penghargaanDelegate.penghargaanPopupController = nil
            self.penghargaanDelegate.showMainContentViewPopUp(tempContentItems, indeks: tempContentIndeks)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupWidthAndHeightBasedOnDeviceScreen(orientation: Bool) {
        ratioWidth = (orientation == true) ? SmartbookUtility.setupRatioWidthBasedOnLandscape() : SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = (orientation == true) ? SmartbookUtility.setupRatioHeightBasedOnLandscape() : SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
        
        self.view.bounds.size.width = (orientation == true) ? ratioWidth * 1024 : ratioWidth * 768
        self.view.bounds.size.height = (orientation == true) ? ratioHeight * 768 : ratioHeight * 1024
        
        penghargaanHeader.bounds.size.width = self.view.bounds.size.width
        penghargaanHeaderHeight.constant = 44.0
        
        self.setupPenghargaanHeaderWithGradientColor("0D7BD4")
        
        penghargaanTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        penghargaanTitle.numberOfLines = 0
        penghargaanTitle.font = penghargaanTitle.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 22)
        penghargaanTitle.sizeToFit()
        
        penghargaanTitle.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(penghargaanTitle.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        penghargaanYear.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(penghargaanYear.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        penghargaanList.frame = SmartbookUtility.setupViewWidthAndHeightBasedOnRatio(penghargaanList.frame, ratioWidth: ratioWidth, ratioHeight: ratioHeight)
        
        penghargaanClose.addTarget(self, action: #selector(PenghargaanViewController.dismissOPan), forControlEvents: UIControlEvents.TouchUpInside)
     
        penghargaanYear.delegate = self
        penghargaanYear.dataSource = self
        penghargaanYear.contentInset = UIEdgeInsets(top: 1.25, left: 1.25, bottom: 1.25, right: 1.25)
        
        penghargaanList.delegate = self
        penghargaanList.dataSource = self
        penghargaanList.estimatedRowHeight = 100.0
        penghargaanList.rowHeight = UITableViewAutomaticDimension
        
        self.view.setNeedsUpdateConstraints()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        self.setupPenghargaanItems()
    }
    
    func setupPenghargaanItems() {
        let mainMenuId = String(format: "%d", mainMenuItems[mainMenuIndeks]["id"] as! Int)
        let subMenuId = String(format: "%d", mainContentItems[mainContentIndeks]["id"] as! Int)
        let urlContent = ConstantAPI.getPenghargaanURL()
        let params = ["mainmenu_id" : mainMenuId,
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
                    self.setupPenghargaanYearItems(self.mainContentPopupItems)
                }
        }
    }
    
    func setupPenghargaanYearItems(items: Array<AnyObject>) {
        for i in 0...items.count-1 {
            if (keyYear != String(format: "%d", items[i]["penghargaan_year"] as! Int)) {
                keyYear = String(format: "%d", items[i]["penghargaan_year"] as! Int)
                penghargaanYearItems.append(keyYear)
            }
        }
        //print("penghargaanYearItems : ", penghargaanYearItems.description)
        self.setupPenghargaanListItems(items)
    }
    
    func setupPenghargaanListItems(items: Array<AnyObject>) {
        for i in 0...penghargaanYearItems.count-1 {
            var tempItems: Array<AnyObject>! = []
            for j in 0...items.count-1 {
                if (penghargaanYearItems[i] as! String == String(format: "%d", items[j]["penghargaan_year"] as! Int)) {
                    tempItems.append(items[j])
                }
            }
            penghargaanListItems[penghargaanYearItems[i] as! String] = tempItems
        }
        print("penghargaanListItems : ", penghargaanListItems.description)
        self.setupPenghargaanView()
    }
    
    func setupPenghargaanView() {
        penghargaanYear.reloadData()
        penghargaanYear.selectItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: .CenteredHorizontally)
        penghargaanList.reloadData()
        
        penghargaanTitle.text = mainContentItems[mainContentIndeks].valueForKey("listcontent_desc") as? String
        self.dismissDashboardIndicatorFromPenghargaanPopup()
    }
    
    func reloadPenghargaanListItems(selectedIndeks: Int) {
        penghargaanYearItemIndex = selectedIndeks
        penghargaanList.reloadData()
    }
    
    func setupPenghargaanHeaderWithGradientColor(color: String) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = penghargaanHeader.bounds
        gradient.colors = [SmartbookUtility.colorWithHexString("0D7BD4").CGColor,
                           SmartbookUtility.colorWithHexString("3FAED6").CGColor,
                           SmartbookUtility.colorWithHexString("0D7BD4").CGColor]
        penghargaanHeader.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    func dismissOPan() {
        print("pan gesture")
        
        penghargaanDelegate.dismissViewControllerAnimated(true, completion: { Void in
            self.penghargaanDelegate.penghargaanPopupController = nil
        })
    }
    
    func dismissDashboardIndicatorFromPenghargaanPopup() {
        penghargaanDelegate.dismissDashboardIndicatorView()
    }
    
    /*
    // MARK - UICollectionView Delegate Method
    */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return penghargaanYearItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let itemCell = penghargaanYear.dequeueReusableCellWithReuseIdentifier(cellYearIdentifier, forIndexPath: indexPath) as! PenghargaanYearCell
        
        if (penghargaanYearItems.count > 0) {
            itemCell.itemYear.text = penghargaanYearItems[indexPath.row] as? String
        }
                
        return itemCell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(ratioWidth * 126, ratioHeight * 63)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard case let selectedCell as PenghargaanYearCell = penghargaanYear.cellForItemAtIndexPath(indexPath) else {
            return
        }
        selectedCell.selected = true
        selectedCell.itemYear.backgroundColor = SmartbookUtility.colorWithHexString("0D7BD4")
        selectedCell.itemYear.textColor = SmartbookUtility.colorWithHexString("FFFFFF")
        self.reloadPenghargaanListItems(indexPath.row)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard case let selectedCell as PenghargaanYearCell = cell else {
            return
        }
        
        if (selectedCell.selected == true) {
            selectedCell.itemYear.backgroundColor = SmartbookUtility.colorWithHexString("0D7BD4")
            selectedCell.itemYear.textColor = SmartbookUtility.colorWithHexString("FFFFFF")
        }else{
            selectedCell.itemYear.backgroundColor = SmartbookUtility.colorWithHexString("FFFFFF")
            selectedCell.itemYear.textColor = SmartbookUtility.colorWithHexString("000000")
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        guard case let selectedCell as PenghargaanYearCell = penghargaanYear.cellForItemAtIndexPath(indexPath) else {
            return
        }
        selectedCell.selected = false
        selectedCell.itemYear.backgroundColor = SmartbookUtility.colorWithHexString("FFFFFF")
        selectedCell.itemYear.textColor = SmartbookUtility.colorWithHexString("000000")
    }
    
    /*
    // MARK - UITableView Delegate Method
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // print("The number is \(menuNames.count)")
        return (penghargaanYearItems.count > 0) ? penghargaanListItems[penghargaanYearItems[penghargaanYearItemIndex] as! String]!.count : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let itemCell = penghargaanList.dequeueReusableCellWithIdentifier(cellListIdentifier, forIndexPath: indexPath) as! PenghargaanListCell
        
        if (penghargaanListItems[penghargaanYearItems[penghargaanYearItemIndex] as! String]!.count > 0) {
            itemCell.itemTitle.text = penghargaanListItems[penghargaanYearItems[penghargaanYearItemIndex] as! String]![indexPath.row].valueForKey("penghargaan_desc") as? String
            itemCell.itemDetail.text = penghargaanListItems[penghargaanYearItems[penghargaanYearItemIndex] as! String]![indexPath.row].valueForKey("penghargaan_detail") as? String
        }
        
        return itemCell
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
