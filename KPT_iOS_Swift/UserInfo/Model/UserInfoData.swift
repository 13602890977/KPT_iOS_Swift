//
//  UserInfoData.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/3.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class UserInfoData: NSObject {

    class var shareUser:UserInfoData {
        struct Static {
            static var onceToken:dispatch_once_t = 0
            static var userInfo:UserInfoData? = nil
        }
        dispatch_once(&Static.onceToken) { () -> Void in
            Static.userInfo = UserInfoData()
        }
        return Static.userInfo!
    }
    
    var accessid :String!
    var accesskey: String!
    var creationdate: String!
    var mobile: String!
    var password: String!
    var userid: String!
}
