//
//  UIView(EXtension).swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/23.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import Foundation

extension UIView {
    //类扩展,需要使用OC的runtime机制
    var X : CGFloat {
        get {
            return(objc_getAssociatedObject(self, &self.X) as! CGFloat)
        }
        set(newValue) {
            objc_setAssociatedObject(self, &self.X, newValue, objc_AssociationPolicy(rawValue: 0)!)
            var frame = self.frame
            frame.origin.x = X
            self.frame = frame
        }
    }
    var Y : CGFloat {
        get {
            return (objc_getAssociatedObject(self, &self.Y) as! CGFloat)
        }
        set (newValue) {
            objc_setAssociatedObject(self, &self.Y, newValue, objc_AssociationPolicy(rawValue: 0)!)
            var frame = self.frame
            frame.origin.y = Y
            self.frame = frame
        }
    }
    
}