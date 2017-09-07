//
//  SmartbookUtility.swift
//  Smartbook
//
//  Created by Aprido Sandyasa on 8/28/16.
//  Copyright © 2016 PT. Jasa Marga Tbk. All rights reserved.
//

import Foundation
import UIKit

public class SmartbookUtility {
    
    static func getUserDefaults() -> NSUserDefaults {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        return userDefaults
    }
    
    static func getConvertArtikelContentToString(content: String) -> String {
//        let attrStr = try! NSAttributedString(
//            data: content.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: false)!,
//            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
//            documentAttributes: nil)
//        let replaced = (attrStr.string as NSString).stringByReplacingOccurrencesOfString("\n", withString: "")
        var plainText = content.stringByReplacingOccurrencesOfString("(?i)<[^>]*>", withString: "", options: .RegularExpressionSearch, range: nil)
        plainText = plainText.stringByReplacingOccurrencesOfString("  Normal 0     false false false  EN-US JA X-NONE", withString: "")
        print(plainText)
        
        return plainText.stringByReplacingOccurrencesOfString("\n", withString: "")
    }
    
    static func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    static func setupViewWidthAndHeightBasedOnRatio( frameRect: CGRect, ratioWidth: CGFloat, ratioHeight: CGFloat) -> CGRect {
        var tempRect = frameRect
        tempRect.origin.y = tempRect.origin.y - 44
        tempRect.size.height = ratioHeight * tempRect.size.height + 44
        tempRect.size.width = ratioWidth * tempRect.size.width
        return tempRect
    }
    
    static func setupRatioWidthBasedOnDeviceScreen() -> CGFloat {
        let width = UIScreen.mainScreen().bounds.size.width
        
        return width / 768
    }
    
    static func setupRatioWidthBasedOnLandscape() -> CGFloat {
        let width = UIScreen.mainScreen().bounds.size.width
        
        return width / 1024
    }
    
    static func setupRatioHeightBasedOnDeviceScreen() -> CGFloat {
        let height = UIScreen.mainScreen().bounds.size.height
        
        return height / 1024
    }
    
    static func setupRatioHeightBasedOnLandscape() -> CGFloat {
        let height = UIScreen.mainScreen().bounds.size.height
        
        return height / 768
    }
    
    static func setupLeftWidthMenuBasedOnDeviceScreen() -> CGFloat {
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        let leftWidth: CGFloat
        if (width > height) {
            leftWidth = 0.85 * height
        }else{
            leftWidth = 0.85 * width
        }
        return leftWidth
    }
    
    static func setupRatioFontBasedOnDeviceScreen(ratioHeight: CGFloat) -> CGFloat {
        if (ratioHeight == 1) {
            return ratioHeight
        }
        else{
            return 768 / 1024
        }
    }
    
    static func cropImageToWidth(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        let tempRect: CGRect = CGRectMake(0, 0, width, height)
        let imageRef = CGImageCreateWithImageInRect(image.CGImage!, tempRect)
        let image: UIImage = UIImage(CGImage: imageRef!)
        return image
    }
    
}
