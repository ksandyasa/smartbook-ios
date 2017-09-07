//
//  AnakHeaderViewController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 8/30/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit
import Alamofire

class AnakHeaderViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var anakImageBg: UIImageView!
    @IBOutlet weak var anakContent: UIView!
    @IBOutlet weak var anakContentName: UILabel!
    @IBOutlet weak var anakContentList: UICollectionView!
    @IBOutlet weak var anakContentIcon: UIImageView!
    let cellIdentifier: String = "anakContentCell"
    var ratioWidth: CGFloat = 0.0
    var ratioHeight: CGFloat = 0.0
    @IBOutlet weak var anakContentIconWidth: NSLayoutConstraint!
    @IBOutlet weak var anakContentIconHeight: NSLayoutConstraint!
    var mainMenuItems: Array<AnyObject>! = []
    var anakHeaderItems: Array<AnyObject>! = []
    var anakHeaderItemsIndeks: Int!
    var isAnakHeaderLoaded: Bool! = false
    weak var delegate: AnakViewController!
    @IBOutlet weak var anakContentHeight: NSLayoutConstraint!
    @IBOutlet weak var anakContentWidth: NSLayoutConstraint!
    @IBOutlet weak var anakContentListHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        anakContentList.registerNib(UINib(nibName: "AnakContentCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        anakContentList.delegate = self
        anakContentList.dataSource = self
        
        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }
    
    override func viewWillAppear(animated: Bool) {
        if (anakHeaderItems.count > 0 && isAnakHeaderLoaded == false) {
            isAnakHeaderLoaded = true
            print(anakHeaderItems.description)
            anakContentList.reloadData()
            anakContentList.selectItemAtIndexPath(NSIndexPath(forRow: anakHeaderItemsIndeks, inSection: 0), animated: true, scrollPosition: .CenteredHorizontally)
        }
        self.setupAnakHeaderView()
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
        
        anakImageBg.bounds.size.width = self.view.bounds.size.width
        anakImageBg.bounds.size.height = self.view.bounds.size.height
        
        anakContentWidth.constant = self.view.bounds.size.width
        anakContentHeight.constant = self.view.bounds.size.height / 2
        
        anakContentList.bounds.size.width = ratioWidth * anakContentList.bounds.size.width
        anakContentListHeight.constant = (orientation == true) ? ratioHeight * 47 : ratioHeight * 63
        
        anakContentName.lineBreakMode = NSLineBreakMode.ByWordWrapping
        anakContentName.numberOfLines = 0
        anakContentName.font = anakContentName.font.fontWithSize(SmartbookUtility.setupRatioFontBasedOnDeviceScreen(ratioHeight) * 22)
        anakContentName.sizeToFit()
        
        anakContentName.bounds.size.width = ratioWidth * anakContentName.bounds.size.width
        anakContentName.bounds.size.height = ratioHeight * 30
        
        anakContentIconHeight.constant = ratioHeight * 95
        anakContentIconWidth.constant = anakContentIconHeight.constant
        
        self.view.bringSubviewToFront(anakContentIcon)
    }
    
    func setupAnakIcon(imageIcon: UIImageView, urlString: String) {
        Alamofire.request(.GET, urlString,
            parameters: nil)
            .responseJSON { response in
                
                imageIcon.image = UIImage(data: response.data!)
                imageIcon.layer.cornerRadius = imageIcon.frame.size.height / 2
                imageIcon.clipsToBounds = true
        }
    }
    
    func setupAnakHeaderView() {
        if (anakHeaderItems.count > 0) {
            let urlString = String(format: "%@%@", ConstantAPI.getImageBaseURL(), anakHeaderItems[anakHeaderItemsIndeks]["kantor_icon"] as! String)
            self.setupAnakIcon(anakContentIcon, urlString: urlString)
            anakContentName.text = String(format: "%@", anakHeaderItems[anakHeaderItemsIndeks]["kantor_desc"] as! String)
        }
    }
    
    // UICollection View Delegate Method
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return anakHeaderItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let itemCell = anakContentList.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! AnakContentCell
        
        if (anakHeaderItems.count > 0) {
            itemCell.anakContentTitle.text = String(format: "%@", anakHeaderItems[indexPath.row]["kantor_desc"] as! String)
        }
        
        return itemCell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return (UIDevice.currentDevice().orientation.isLandscape == true) ? CGSizeMake(ratioWidth * 414, ratioHeight * 47) : CGSizeMake(ratioWidth * 414, ratioHeight * 63)
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
        guard case let selectedCell as AnakContentCell = cell else {
            return
        }
        
        if (selectedCell.selected == true) {
            selectedCell.anakContentTitle.backgroundColor = SmartbookUtility.colorWithHexString("F7CE1F")
        }else{
            selectedCell.anakContentTitle.backgroundColor = SmartbookUtility.colorWithHexString("0D7BD4")
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard case let selectedCell as AnakContentCell = anakContentList.cellForItemAtIndexPath(indexPath) else {
            return
        }

        selectedCell.selected = true
        selectedCell.anakContentTitle.backgroundColor = SmartbookUtility.colorWithHexString("F7CE1F")
        anakHeaderItemsIndeks = indexPath.row
        //self.setupAnakHeaderView()
        delegate.showDashboardIndicatorFromAnak()
        delegate.setupAnakListIndeksFromHeader(indexPath.row)
        delegate.setupAnakContentItems(indexPath.row)
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        guard case let selectedCell as AnakContentCell = anakContentList.cellForItemAtIndexPath(indexPath) else {
            return
        }
        
        selectedCell.selected = false
        selectedCell.anakContentTitle.backgroundColor = SmartbookUtility.colorWithHexString("0D7BD4")
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
