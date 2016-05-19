//
//  UIColor+Category.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/18.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

extension UIColor {
    class func RGBA(red:CGFloat, g:CGFloat, b:CGFloat) ->UIColor {
        return UIColor(red: red/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
        
    }
    class func randomColor() -> UIColor{
        let a = Int(arc4random()) % 256
        return UIColor(red: CGFloat(a) / 255.0, green: CGFloat(a)/255.0, blue: CGFloat(a)/255.0, alpha: 1)
    }
}