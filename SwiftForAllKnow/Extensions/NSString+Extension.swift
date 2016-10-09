//
//  NSString+Extension.swift
//  SwiftForAllKnow
//
//  Created by enghou on 16/9/30.
//  Copyright © 2016年 xyxorigation. All rights reserved.
//

import Foundation
extension String{
    func StringSize(font : UIFont,maxSize : CGSize) -> CGSize {
        let str : NSString = NSString.init(string: self)
        let attributes = [NSFontAttributeName : font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect = str.boundingRect(with: maxSize, options: option, attributes: attributes, context: nil)
        return rect.size
    }
}
