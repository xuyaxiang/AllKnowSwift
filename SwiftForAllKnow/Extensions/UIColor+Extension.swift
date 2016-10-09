//
//  UIColor+Extension.swift
//  SwiftAllKnow
//
//  Created by enghou on 16/9/29.
//  Copyright © 2016年 xyxorigation. All rights reserved.
//

import UIKit
import Foundation
extension UIColor{
    class func colorWithHexString(hex : String)->UIColor{
        var cString = hex.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines).uppercased();
        if cString.hasPrefix("#"){
            cString = cString.substring(from: cString.index(after: cString.startIndex))
        }
        if (cString as NSString).length != 6{
            return UIColor.gray
        }
        
        let rString = cString.substring(to: cString.index(cString.startIndex, offsetBy: 2))
        let gString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 2)).substring(to: cString.index(cString.startIndex, offsetBy: 2))
        let bString = cString.substring(from: cString.index(cString.endIndex, offsetBy: -2))
        var r : CUnsignedInt = 0
        var g : CUnsignedInt = 0
        var b : CUnsignedInt = 0
        let rScan = Scanner.init(string: rString)
        rScan.scanHexInt32(&r)
        let gScan = Scanner.init(string: gString)
        gScan.scanHexInt32(&g)
        let bScan = Scanner.init(string: bString)
        bScan.scanHexInt32(&b)
        let red = CGFloat(r)/255.0
        let green = CGFloat(g)/255.0
        let blue = CGFloat(b)/255.0
        return UIColor.init(red: red, green: green, blue: blue, alpha: 1)
    }
    
    class func defaultBackGroundColor()->UIColor{
        return UIColor.colorWithHexString(hex: "00A5EE")
    }
    
    class func defaultGrayColor()->UIColor{
        return UIColor.colorWithHexString(hex: "dadada")
    }
}
