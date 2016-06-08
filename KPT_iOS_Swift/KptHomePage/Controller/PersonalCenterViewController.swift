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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let navigationBar = self.navigationController!.navigationBar
        navigationBar.barTintColor = UIColor.blackColor()
       UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        reloadUserData()
        self.title = "个人中心"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor(),NSFontAttributeName:UIFont(name: "Heiti SC", size: 20.0)!]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back"), style: UIBarButtonItemStyle.Plain, target: self, action: "cancelBtnClick:")
        
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
        let loginDataName:NSDictionary = NSUserDefaults.standardUserDefaults().objectForKey("userInfoLoginData") as! NSDictionary
        loginData = UserInfoData.mj_objectWithKeyValues(loginDataName)
        
        let paramet = ["requestcode":"001007","accessid":loginData.accessid,"accesskey":loginData.accesskey,"userid":loginData.userid]
        KptRequestClient.sharedInstance.Kpt_post("/plugins/changhui/port/user/getUserInfo", paramet: paramet, viewController: self) { (data) -> Void in
            print(data)
        }
    }
    private lazy var tableView :UITableView = {
       let table = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        
        return table
    }()
    private let msgArr = ["驾驶证信息","车辆信息"]
    private let setArr = ["软件设置","修改密码","意见反馈","关于我们"]
    private let msgImageArr = ["用户信息","车辆"]
    private let setImageArr = ["设置","改密码","意见","关于我们"]
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
        var cell = tableView.dequeueReusableCellWithIdentifier(personalCenterCell)
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
    
    func ExitLogin() {
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "userInfoLoginData")
        NSUserDefaults.standardUserDefaults().synchronize()
        let nav = UINavigationController(rootViewController: Kpt_LoginViewController(nibName: "Kpt_LoginViewController", bundle: nil))
        self.presentViewController(nav, animated: true, completion: nil)
        
    }
}
