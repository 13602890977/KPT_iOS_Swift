//
//  KPTHomePageViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/19.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class KPTHomePageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.randomColor()
//        KptRequestClient.sharedInstance.GET("/plugins/changhui/port/getBrand?requestCode=001004", parameters: nil, progress: nil, success: { (AFHTTPRequestOperation, JSON) -> Void in
//            print(JSON)
//            }) { (_, error) -> Void in
//                print(error)
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
