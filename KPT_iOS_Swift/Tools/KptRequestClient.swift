//
//  KptRequestClient.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/20.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import AFNetworking

class KptRequestClient: AFHTTPSessionManager {
    
    class var sharedInstance :KptRequestClient {
        struct Static {
            static var onceToken:dispatch_once_t = 0
            static var instance:KptRequestClient? = nil
        }
        dispatch_once(&Static.onceToken, { () -> Void in
            //string填写相应的baseUrl即可
            let url:NSURL = NSURL(string: "http://59.41.39.55:9090")!
            Static.instance = KptRequestClient(baseURL: url)
            Static.instance?.requestSerializer = AFJSONRequestSerializer()
            Static.instance?.responseSerializer = AFJSONResponseSerializer()
            Static.instance?.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
        })
        //返回本类的一个实例
        return Static.instance!
    }
    
}
