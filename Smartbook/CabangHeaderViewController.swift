//
//  CabangHeaderViewController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 8/30/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import Alamofire

class CabangHeaderViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var cabangContent: UIView!
    @IBOutlet weak var cabangViewBg: UIImageView!
    @IBOutlet weak var cabangIconView: UIImageView!
    @IBOutlet weak var cabangName: UILabel!
    @IBOutlet weak var cabangContentList: UICollectionView!
    let cellIdentifier: String = "cabangContentCell"
    var ratioWidth: CGFloat = 0.0
    var ratioHeight: CGFloat = 0.0
    @IBOutlet weak var cabangIconViewWidth: NSLayoutConstraint!
    @IBOutlet weak var cabangIconViewHeight: NSLayoutConstraint!
    @IBOutlet weak var cabangContentHeight: NSLayoutConstraint!
    @IBOutlet weak var cabangContentWidth: NSLayoutConstraint!
    @IBOutlet weak var cabangContentListHeight: NSLayoutConstraint!
    var mainMenuItems: Array<AnyObject>! = []
    var cabangHeaderItems: Array<AnyObject>! = []
    var cabangHeaderIndeks: Int! = 0
    var isHeaderListLoaded: Bool! = false
    weak var delegate: CabangViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cabangContentList.registerNib(UINib(nibName: "CabangContentCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        cabangContentList.delegate = self
        cabangContentList.dataSource = self
        
        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }
    
    override func viewDidAppear(animated: Bool) {
        if (cabangHeaderItems.count > 0 && isHeaderListLoaded == false) {
            print("cabangItemsIndeks : ", cabangHeaderIndeks)
            isHeaderListLoaded = true
            cabangContentList.reloadData()
            cabangContentList.selectItemAtIndexPath(NSIndexPath(forRow: cabangHeaderIndeks, inSection: 0), animated: true, scrollPosition: .CenteredHorizontally)
        }
        self.setupHeaderItemsView()
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
        
        self.view.bounds.size.width = (orientation == true) ? ratioWidth * 1024 : ratioWidth * 768
        self.view.bounds.size.height = (orientation == true) ? ratioHeight * 299 : ratioHeight * 351
        
        cabangViewBg.bounds.size.width = self.view.bounds.size.width
        cabangViewBg.bounds.size.height = self.view.bounds.size.height
        
        cabangContentWidth.constant = self.view.bounds.size.width
        cabangContentHeight.constant = self.view.bounds.size.height / 2
        
        cabangContentList.bounds.size.width = ratioWidth * cabangContentList.bounds.size.width
        cabangContentListHeight.constant = (orientation == true) ? ratioHeight * 47 : ratioHeight * 63
        
        cabangName.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cabangName.numberOfLines = 0
        cabangName.font = cabangName.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 22)
        cabangName.sizeToFit()
        
        cabangName.bounds.size.width = ratioWidth * cabangName.bounds.size.width
        cabangName.bounds.size.height = ratioHeight * 30
        
        cabangIconViewHeight.constant = ratioHeight * 95
        cabangIconViewWidth.constant = cabangIconViewHeight.constant
        
        self.view.bringSubviewToFront(cabangIconView)        
    }
    
    func setupCabangIcon(imageIcon: UIImageView, urlString: String) {
        Alamofire.request(.GET, urlString,
            parameters: nil)
            .responseJSON { response in
                
                imageIcon.image = UIImage(data: response.data!)
        }
    }
    
//    func setupHeaderItems(index: Int) {
//        let params = ["id" : ((mainMenuItems[1].valueForKey("link_content")?.valueForKey("mainmenu_id")) as? String)!,
//                      "kantorid": ((cabangListItems[index].valueForKey("kantor_id")) as? String!)!,
//                      "apikey" : SmartbookUtility.getUserDefaults().valueForKey("prefApiKey") as! String
//        ]
//        
//        Alamofire.request(.GET, ConstantAPI.getSubMenuURL(),
//            parameters: params)
//            .responseJSON { response in
//                
//                if let JSON = response.result.value {
//                    self.cabangHeaderItems = JSON["header"] as? NSArray
//                    self.setupHeaderItemsView()
//                }
//        }
//    }
    
    func setupHeaderItemsView() {
        if (cabangHeaderItems.count > 0) {
            let urlImage = String(format: "%@%@", ConstantAPI.getImageBaseURL(), cabangHeaderItems[cabangHeaderIndeks]["kantor_icon"] as! String)
            print("urlImage : ",urlImage)
            self.setupCabangIcon(cabangIconView, urlString: urlImage)
            cabangName.text = String(format: "%@", cabangHeaderItems[cabangHeaderIndeks]["kantor_desc"] as! String)
        }
    }
    
    // UICollection View Delegate Method
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cabangHeaderItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let itemCell = cabangContentList.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! CabangContentCell

        if (cabangHeaderItems.count > 0) {
            itemCell.cabangContentTitle.text = String(format: "%@", cabangHeaderItems[indexPath.row]["kantor_desc"] as! String)
        }
        
        return itemCell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return (UIDevice.currentDevice().orientation.isLandscape == true) ? CGSizeMake(ratioWidth * 276, ratioHeight * 47) : CGSizeMake(ratioWidth * 276, ratioHeight * 63)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.25, left: 1.25, bottom: 1.25, right: 1.25)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return ratioWidth * 10
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return ratioHeight * 10
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard case let selectedCell as CabangContentCell = cell else {
            return
        }
        
        if (selectedCell.selected == true) {
            selectedCell.cabangContentTitle.backgroundColor = SmartbookUtility.colorWithHexString("FF5216")
        }else{
            selectedCell.cabangContentTitle.backgroundColor = SmartbookUtility.colorWithHexString("0D7BD4")
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard case let selectedCell as CabangContentCell = cabangContentList.cellForItemAtIndexPath(indexPath) else {
            return
        }
        selectedCell.selected = true
        cabangHeaderIndeks = indexPath.row
        selectedCell.cabangContentTitle.backgroundColor = SmartbookUtility.colorWithHexString("FF5216")
        delegate.showDashboardIndicatorFromCabang()
        self.setupHeaderItemsView()
        //self.setupHeaderItems(indexPath.row)
        delegate.setupCabangContentItems(indexPath.row)
        delegate.setupCabangListIndeksFromHeader(indexPath.row)
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        guard case let selectedCell as CabangContentCell = cabangContentList.cellForItemAtIndexPath(indexPath) else {
            return
        }
        selectedCell.selected = false
        selectedCell.cabangContentTitle.backgroundColor = SmartbookUtility.colorWithHexString("0D7BD4")
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
