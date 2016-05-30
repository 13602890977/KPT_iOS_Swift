//
//  GlobalConstant.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/18.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit


///屏幕宽
let SCRW = UIScreen.mainScreen().bounds.size.width
///屏幕高
let SCRH = UIScreen.mainScreen().bounds.size.height

///屏幕最高多高
let SCREEN_MAX_LENGTH = max(SCRW, SCRH)

///高德地图APIKey
let APIKEY = "b7882ff4e542e01d5e6f718caf6706f0"
///App主色调
let MainColor = UIColor(red: 242/255.0, green: 170/255.0, blue: 3/255.0, alpha: 1)

extension String {
     func isPhotoNumber() -> Bool {
        var regex:NSRegularExpression
        do {
           regex = try NSRegularExpression(pattern: "^[1][3578][0-9]{9}$", options: NSRegularExpressionOptions.CaseInsensitive)
            let matches = regex.matchesInString(self, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0,self.characters.count))
            if matches.count < 1 {
                return false
            }
            return true
        }catch {
            print("使用电话号码正则表达式判断失败 - error\(error)")
        }
        return false
    }
    
}


extension NSObject {
    func IS_IPHONE()->Bool {
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone
    }
    //设备(根据屏幕最大高度判读)
    func IS_IPHONE_4_OR_LESS() -> Bool {
        return IS_IPHONE() && SCREEN_MAX_LENGTH < 568.0
    }
    func IS_IPHONE_5() -> Bool {
        return IS_IPHONE() && SCREEN_MAX_LENGTH == 568.0
    }
    func IS_IPHONE_6() ->Bool {
        return IS_IPHONE() && SCREEN_MAX_LENGTH == 667.0
    }
    func IS_IPHONE_6P() ->Bool {
        return IS_IPHONE() && SCREEN_MAX_LENGTH == 736.0
    }
}