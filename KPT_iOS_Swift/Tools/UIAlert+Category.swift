//
//  UIAlert+Category.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/8.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import Foundation

extension UIAlertController {
    
    /** 只带取消按钮的alert弹框提示
     * title 标题语
     * message 提示语
     * cancelActionTitle 取消按钮的text
     */
    class func creatAlertWithTitle(title title:String?,message:String?,cancelActionTitle:String?) -> UIAlertController {
        let alertV = UIAlertController(title: title, message: message , preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: cancelActionTitle, style: UIAlertActionStyle.Cancel, handler: nil)
        alertV.addAction(action)
        return alertV
    }
}