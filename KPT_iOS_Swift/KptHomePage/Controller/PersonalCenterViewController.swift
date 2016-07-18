//
//  PersonalCenterViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/3.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class PersonalCenterViewController: UIViewController {

    
    private var loginData: UserInfoData!
    ///用户的驾驶证信息
    private var personalData : PersonalModel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let navigationBar = self.navigationController!.navigationBar
        navigationBar.barTintColor = UIColor.blackColor()
       UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        reloadUserData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "个人中心"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:MainColor,NSFontAttributeName:UIFont(name: "Heiti SC", size: 20.0)!]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "展开"), style: UIBarButtonItemStyle.Plain, target: self, action: "cancelBtnClick:")
        
        UINavigationBar.appearance().tintColor = MainColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        // Do any additional setup after loading the view.
    }

    func cancelBtnClick(sender:AnyObject?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    private func reloadUserData() {
        let loginDataName = NSUserDefaults.standardUserDefaults().objectForKey("userInfoLoginData")
        if loginDataName != nil {
            loginData = UserInfoData.mj_objectWithKeyValues(loginDataName as! NSDictionary)
        }
        
        let paramet = ["requestcode":"001010","accessid":loginData.accessid,"accesskey":loginData.accesskey,"userid":loginData.userid]
        KptRequestClient.sharedInstance.Kpt_post("/plugins/changhui/port/user/getDrivingLicenseInfo", paramet: paramet, viewController: self, success: { (data) -> Void in
            print(data)
            self.personalData = PersonalModel.mj_objectWithKeyValues(data)
            self.tableView.reloadData()
            }) { (_) -> Void in
                
        }
    }
    private lazy var tableView :UITableView = {
       let table = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        
        return table
    }()
    private let msgArr = ["驾驶证信息","车辆信息"]
    private let setArr = ["软件设置","修改密码","意见反馈","关于我们"]
    private let msgImageArr = ["icon_user_info","icon_user_car"]
    private let setImageArr = ["icon_user_setting","icon_user_pwd","icon_user_comment","icon_user_aboutus"]
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension PersonalCenterViewController :UITableViewDataSource,UITableViewDelegate {
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15.0
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return (IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 40) + 20
        }
        return IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 40
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return msgArr.count;
        }else if section == 2{
            return setArr.count
        }
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let personalCenterCell = "personalCenterCell"
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell == nil {
            if indexPath.section == 0 {
                cell = NSBundle.mainBundle().loadNibNamed("PersonTableViewCell", owner: nil, options: nil).last as! PersonTableViewCell
            } else {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: personalCenterCell)
            }
            
        }
        
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell?.contentMode = UIViewContentMode.ScaleToFill
        if indexPath.section == 0 {
            (cell as! PersonTableViewCell).personPhoto.text = loginData.mobile
            if personalData != nil {
                (cell as! PersonTableViewCell).personName.text = personalData.drivinglicensename
            }
            cell?.accessoryType = UITableViewCellAccessoryType.None
            
        }else if indexPath.section == 1{
            cell?.imageView?.image = UIImage(named: msgImageArr[indexPath.row])
            cell?.textLabel?.text = msgArr[indexPath.row]
            
        }else if indexPath.section == 2{
            cell?.imageView?.image = UIImage(named: setImageArr[indexPath.row])
            cell?.textLabel?.text = setArr[indexPath.row]
            
        }else {
            let btn = UIButton(type: UIButtonType.System)
            btn.frame = CGRect(x: 0, y: ((IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 40) - 20 ) * 0.5, width: SCRW, height: 20)
            btn.setTitle("退出登录", forState: UIControlState.Normal)
            btn.titleLabel?.font = UIFont.systemFontOfSize(18)
            btn.titleLabel?.textAlignment = NSTextAlignment.Center
            btn.addTarget(self, action: "ExitLogin", forControlEvents: UIControlEvents.TouchUpInside)
            cell?.contentView.addSubview(btn)
            cell?.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.textLabel?.text == "车辆信息" {
            self.navigationController?.pushViewController(VehicleManagementController(), animated: true)
            return
        }else if cell?.textLabel?.text == "驾驶证信息" {
            let dataDic = NSMutableDictionary()
            if personalData == nil {
                dataDic.setValue("驾驶证信息", forKey: "就是用来区分的")
            }else {
                /*
                private lazy var oneArr = ["姓名","身份证号","性别","国籍","住址"]
                private lazy var twoArr = ["出生日期","初始领证日期","准驾车型","有效期限"]
                */
                dataDic.setValue(personalData.drivinglicensename, forKey: "姓名")
                dataDic.setValue(personalData.drivinglicenseno, forKey: "身份证号")
                dataDic.setValue(personalData.drivinglicensesex, forKey: "性别")
                dataDic.setValue("中国", forKey: "国籍")
                
                dataDic.setValue(personalData.drivinglicenseaddress, forKey: "住址")
                dataDic.setValue(personalData.drivinglicensebirthdate, forKey: "出生日期")
                dataDic.setValue(personalData.drivinglicensecartype, forKey: "准驾车型")
                dataDic.setValue(personalData.drivinglicensefristdate, forKey: "初始领证日期")
                dataDic.setValue(personalData.drivinglicensevaliddate, forKey: "有限日期")
                dataDic.setValue(personalData.drivinglicenseurl, forKey: "registration")
            }
            let drivingVC = DrivingLicenceViewController()
            drivingVC.carInfoData = dataDic
            self.navigationController?.pushViewController(drivingVC, animated: true)
        }else if cell?.textLabel?.text == "修改密码" {
            let modifyVC = ModifyPasswordViewController(nibName:"ModifyPasswordViewController",bundle: nil)
            self.navigationController?.pushViewController(modifyVC, animated: true)
        }
    }
    func ExitLogin() {
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "userInfoLoginData")
        NSUserDefaults.standardUserDefaults().synchronize()
        let nav = UINavigationController(rootViewController: Kpt_LoginViewController(nibName: "Kpt_LoginViewController", bundle: nil))
        self.presentViewController(nav, animated: true, completion: nil)
        
    }
}
