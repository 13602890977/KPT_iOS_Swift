//
//  KptRequestClient.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/20.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import AFNetworking
import XMLDictionary

class KptRequestClient: AFHTTPSessionManager{
    
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
    ///请求接口再封装，把请求失败的操作封装起来
    func Kpt_post(urlStr:String,paramet:AnyObject?,viewController:UIViewController,success: ( AnyObject? -> Void)?) {
        KptRequestClient.sharedInstance.POST(urlStr, parameters: paramet, progress: nil, success: { (task:NSURLSessionDataTask!, JSON) -> Void in
            let responsecode = JSON?.objectForKey("responsecode") as? String
            if (responsecode! == "1") {
                success!(JSON?.objectForKey("data"))
            }else {
                let alertV = UIAlertController(title: "温馨提醒", message: JSON!.objectForKey("errormessage") as? String, preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
                alertV.addAction(action)
                viewController.presentViewController(alertV, animated: true, completion: nil)
            }
            }) { (_, error) -> Void in
                print(error)
        }
    }
        
    
}
