//
//  MainSlideViewController.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 8/28/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import UIKit

class MainSlideViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate {
    
    var pageViewController: UIPageViewControllerWithOverlayIndicator!
    var ratioWidth: CGFloat = 0.0
    var ratioHeight: CGFloat = 0.0
    var slideItems: Array<AnyObject>! = []
    var currentIndex: Int = 0
    weak var mainSlideDelegate: MainViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupRatioWidthAndHeightBasedOnDeviceScreen(UIDevice.currentDevice().orientation.isLandscape)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func actionClickFromSlideContent(indeksPage: Int) {
        print("clicked from slide content")
        mainSlideDelegate.actionClickFromMainSlideController(slideItems, indeksPage: indeksPage)
    }
        
    func viewControllerAtIndex(index: Int) -> MainSlideContentViewController {
        if (slideItems.count == 0) || (index == slideItems.count) {
            return MainSlideContentViewController()
        }
        let vc = MainSlideContentViewController(nibName: "MainSlideContentViewController", bundle: nil)
        vc.mainSlideItemDelegate = self
        vc.pageIndex = index
        vc.imageBg = "cover"
        vc.mTitle = slideItems[index]["Nama"] as? String
        //let content: String? = slideItems[index]["introtext"] as? String
        vc.mContent = slideItems[index]["introtext"] as? String
        return vc
    }
    
    func setupRatioWidthAndHeightBasedOnDeviceScreen(orientation: Bool) {
        ratioWidth = (orientation == true) ? SmartbookUtility.setupRatioWidthBasedOnLandscape() : SmartbookUtility.setupRatioWidthBasedOnDeviceScreen()
        ratioHeight = (orientation == true) ? SmartbookUtility.setupRatioHeightBasedOnLandscape() : SmartbookUtility.setupRatioHeightBasedOnDeviceScreen()
        
        self.view.bounds.size.width = (orientation == true) ? ratioWidth * 1024 : ratioWidth * 768
        self.view.bounds.size.height = (orientation == true) ? ratioHeight * 299 : ratioHeight * 351
        
        self.setupPageViewController()
    }
    
    func setupPageViewController() {
        self.pageViewController = UIPageViewControllerWithOverlayIndicator(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        for view in self.pageViewController.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delegate = self
            }
        }
        self.pageViewController.setViewControllers([self.viewControllerAtIndex(0)], direction: .Forward, animated: true, completion: nil)
        self.addChildViewController(self.pageViewController)
        self.pageViewController.view.frame = self.view.bounds
        self.view.addSubview(self.pageViewController.view)
        self.view.bringSubviewToFront(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    /*
    // MARK - UIPageViewController Data Source
    */
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! MainSlideContentViewController
        var index = vc.pageIndex as Int
        currentIndex = index
        print("currentIndex : %ld", currentIndex)
        if (index == 0 || index == NSNotFound) {
            return nil
        }
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! MainSlideContentViewController
        var index = vc.pageIndex as Int
        currentIndex = index
        print("currentIndex : %ld", currentIndex)
        if (index == NSNotFound) {
            return nil
        }
        index += 1
        if (index == slideItems.count) {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return slideItems.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    /*
    // MARK - UIScrollView Delegate
    */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if currentIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        } else if currentIndex == slideItems.count - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if currentIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        } else if currentIndex == slideItems.count - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width {
            scrollView.contentOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
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

// UIPageViewController With Overlay Indicator
class UIPageViewControllerWithOverlayIndicator: UIPageViewController {
    override func viewDidLayoutSubviews() {
        for subView in self.view.subviews {
            if subView is UIScrollView {
                subView.frame = self.view.bounds
            } else if subView is UIPageControl {
                self.view.bringSubviewToFront(subView)
            }
        }
        super.viewDidLayoutSubviews()
    }
}

