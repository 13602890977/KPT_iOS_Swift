//
//  VehicleManagementController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/14.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import MBProgressHUD

class VehicleManagementController: UIViewController {
    private var loginData: UserInfoData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "车辆管理"
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
        let table = UITableView(frame: self.view.bounds,style: UITableViewStyle.Plain)
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
extension VehicleManagementController : UITableViewDataSource,UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelArr.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 40) + 20
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
        var cell = tableView.dequeueReusableCellWithIdentifier(myCarTableCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: myCarTableCellIdentifier)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell?.textLabel?.font = UIFont.systemFontOfSize(20)
            cell?.detailTextLabel?.font = UIFont.systemFontOfSize(16)
        }
        let model = self.modelArr[indexPath.row] as! MyCarModel
        cell?.textLabel?.text = model.carno
        cell?.detailTextLabel?.text = model.renewed
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = self.modelArr[indexPath.row] as! MyCarModel
        let carInfo = CarInfoViewController()
    
        carInfo.changeDict = ["车牌号码":model.carno,"车辆类型":model.cartype,"车主姓名":model.renewed,"住址":model.address,"发动机号":model.engineno,"车架号":model.vinno,"厂牌型号":model.brandno,"车型名称":model.vehiclemodels,"登记日期":model.initialdate,"发证日期":model.creationdate,"出险次数":"\(model.beindangertime)次","投保公司":model.insurecompany,"保险金额":model.insuremoney,"registration":model.registration]
        
        self.navigationController?.pushViewController(carInfo, animated: true)
        
    }
}