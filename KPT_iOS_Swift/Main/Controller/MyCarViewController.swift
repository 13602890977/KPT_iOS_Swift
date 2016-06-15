//
//  MyCarViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/13.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import MBProgressHUD

class MyCarViewController: UIViewController {
    private var loginData: UserInfoData!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的车辆"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加", style: UIBarButtonItemStyle.Plain, target: self, action: "addMyCar")
        
       
        
        self.view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        reloadMyCarData()
        
    }
     
    func addMyCar() {
        let userDe = NSUserDefaults.standardUserDefaults()
        userDe.setValue("true", forKey: "addMyCarPush")
        userDe.synchronize()
        
        self.navigationController?.pushViewController(CarInfoViewController(), animated: true)
    }
    func reloadMyCarData() {
        self.hud.labelText = "请求数据中"
        self.hud.show(true)
        
        let loginDataName:NSDictionary = NSUserDefaults.standardUserDefaults().objectForKey("userInfoLoginData") as! NSDictionary
        loginData = UserInfoData.mj_objectWithKeyValues(loginDataName)
        let urlStr = "/plugins/changhui/port/car/getListCarInfo?requestcode=002001&accessid=\(loginData.accessid)&accesskey=\(loginData.accesskey)&userid=\(loginData.userid)"
        
        KptRequestClient.sharedInstance.Kpt_Get(urlStr, paramet: nil, viewController: self, success: { (data) -> Void in
                print(data)
            if data as? NSDictionary != nil {
                let model = MyCarModel.mj_objectWithKeyValues(data)
                self.modelArr.addObject(model)
            }else if data as? NSArray != nil {
                self.modelArr = MyCarModel.mj_objectArrayWithKeyValuesArray(data)
            }
                self.tableView.reloadData()
                self.hud.hide(true)
            }) { (_) -> Void in
                self.hud.hide(true)
        }    }
    
    private lazy var tableView : UITableView = {
       let table = UITableView(frame: self.view.bounds,style: UITableViewStyle.Grouped)
        table.delegate = self
        table.dataSource = self

        return table
    }()
    private lazy var modelArr:NSMutableArray = NSMutableArray()
    
    private lazy var hud : MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MyCarViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArr.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCRW, height: 30))
        let label = UILabel(frame: CGRect(x: 15, y: 5, width: 120, height: 20))
        label.text = "选择我的车辆"
        view.addSubview(label)
        return view
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCarTableCellIdentifier = "myCarTableCellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(myCarTableCellIdentifier) as? MyCarTableViewCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("MyCarTableViewCell", owner: nil, options: nil).last as? MyCarTableViewCell
        }
        let model = modelArr[indexPath.row] as! MyCarModel
        
        cell!.carModel = model
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MyCarTableViewCell
        cell.roundImage.image = UIImage(named: "round_y")
        NSNotificationCenter.defaultCenter().postNotificationName("ReturnCarNo", object: nil, userInfo: ["myCar":cell.myCarName.text!])
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
