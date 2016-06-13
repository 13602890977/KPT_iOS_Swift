//
//  MyCarViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/13.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class MyCarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的车辆"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加", style: UIBarButtonItemStyle.Plain, target: self, action: "addMyCar")
        reloadMyCarData()
        
    }
    func reloadMyCarData() {
        KptRequestClient.sharedInstance.GET("/plugins/changhui/port/car/getListCarInfo", parameters: nil, success: { (_, JSON) -> Void in
                print(JSON)
            }) { (_, error) -> Void in
                print("请求车辆信息错误 - \(error)")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
