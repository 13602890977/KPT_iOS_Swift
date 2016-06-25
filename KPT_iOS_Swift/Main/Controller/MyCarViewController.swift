//
//  MyCarViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/13.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import MBProgressHUD

class MyCarViewController: UIViewController,Kpt_NextBtnViewDelegate {
    private var loginData: UserInfoData!
    ///用来接收区分是由哪一个VCpush进来的
    var isWhatControllerPushIn : String!
    ///用于记录保存选择的车辆数据
    private var selectedModel : MyCarModel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let navigationBar = self.navigationController!.navigationBar
        navigationBar.barTintColor = UIColor.blackColor()
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的车辆"
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFontOfSize(19.0),NSForegroundColorAttributeName:MainColor]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加", style: UIBarButtonItemStyle.Plain, target: self, action: "addMyCar")
        
        self.navigationItem.rightBarButtonItem?.tintColor = MainColor
        
        if isWhatControllerPushIn == "discoverVC" {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "展开"), style: UIBarButtonItemStyle.Plain, target: self, action: "cancelBtnClick")
            self.navigationItem.leftBarButtonItem?.tintColor = MainColor
        }
        
        self.view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        reloadMyCarData()
        
    }
    func cancelBtnClick() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    func addMyCar() {
        let userDe = NSUserDefaults.standardUserDefaults()
        userDe.setValue("true", forKey: "addMyCarPush")
        userDe.synchronize()
        
        self.navigationController?.pushViewController(CarInfoViewController(), animated: true)
    }
    func reloadMyCarData() {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            self.storageAndReadingListOfInsuranceCompanies()
            
            let userDefault = NSUserDefaults.standardUserDefaults()
            let personalData = userDefault.objectForKey("userInfoLoginData") as! NSDictionary
            let userInfoData = UserInfoData.mj_objectWithKeyValues(personalData)
            
            //获取驾驶证
            let getDrivingParamet = ["requestcode":"001010","accessid":userInfoData.accessid,"accesskey":userInfoData.accesskey,"userid":userInfoData.userid]
            
            KptRequestClient.sharedInstance.Kpt_post("/plugins/changhui/port/user/getDrivingLicenseInfo", paramet: getDrivingParamet, viewController: self, success: { (data) -> Void in
                if let dict = data as? NSDictionary {
                    let model = DrivingLicenseModel.mj_objectWithKeyValues(dict)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.partiesdataDict.setValue(model.drivinglicenseno, forKey: "licenseno")//驾驶证号
                    })
                    
                }
                }, failure: { (_) -> Void in
                    
            })
        }
        
        self.hud.labelText = "请求数据中"
        self.hud.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.hud.show(true)
        
        let loginDataName = NSUserDefaults.standardUserDefaults().objectForKey("userInfoLoginData")
        if loginDataName != nil {
            loginData = UserInfoData.mj_objectWithKeyValues(loginDataName as! NSDictionary)
        }
        
        
        let urlStr = "/plugins/changhui/port/car/getListCarInfo?requestcode=002001&accessid=\(loginData.accessid)&accesskey=\(loginData.accesskey)&userid=\(loginData.userid)"
        
        KptRequestClient.sharedInstance.Kpt_Get(urlStr, paramet: nil, viewController: self, success: { (data) -> Void in
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
        }
        
    }
    ///点击下一步
    func nextBtnClick(nextBtn: Kpt_NextBtnView) {
        let onlineVC = OnlineInsuranceViewController(nibName:"OnlineInsuranceViewController",bundle: nil)
        onlineVC.carnoStr = selectedModel.carno
        onlineVC.carmodelId = selectedModel.carid
        onlineVC.carmodelStr = selectedModel.vehiclemodels
        self.navigationController?.pushViewController(onlineVC, animated: true)
    }
    
    private lazy var tableView : UITableView = {
       let table = UITableView(frame: self.view.bounds,style: UITableViewStyle.Plain)
        table.delegate = self
        table.dataSource = self

        return table
    }()
    private lazy var modelArr:NSMutableArray = NSMutableArray()
    
    private lazy var hud : MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    ///用于保存我选择的车辆的信息
    private lazy var partiesdataDict:NSMutableDictionary = NSMutableDictionary()
    
    
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
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if isWhatControllerPushIn == "discoverVC" {
            return 110
        }
        return 0.0001
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if isWhatControllerPushIn == "discoverVC" {
            let cellMainHeight:CGFloat = IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 40
            let backView = UIView()
            backView.backgroundColor = UIColor.RGBA(218, g: 218, b: 218)
            let view = Kpt_NextBtnView(frame: CGRect(x: 0, y: 10, width: SCRW, height: cellMainHeight + 40))
            view.delegate = self
            view.btnText = "下一步"
            view.backgroundColor = UIColor.whiteColor()
            backView.addSubview(view)
            
            return backView
        }
        return nil
        
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCRW, height: 30))
        view.backgroundColor = UIColor.whiteColor()
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
        let model = modelArr[indexPath.row] as! MyCarModel
        model.isSelected = !model.isSelected
        
        creatPartiesDataMyCarDict(model)
        self.tableView.reloadData()
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MyCarTableViewCell
        print(self.partiesdataDict)
        if isWhatControllerPushIn == "accidentVC" {///是从事故类型进入的
            
            NSNotificationCenter.defaultCenter().postNotificationName("ReturnCarNo", object: self.partiesdataDict, userInfo: ["myCar":cell.myCarName.text!])
            self.navigationController?.popToRootViewControllerAnimated(true)
        }else if isWhatControllerPushIn == "discoverVC" {//在线定损进入的
            selectedModel = model
        }
        
    }
    private func creatPartiesDataMyCarDict(model:MyCarModel) {
        
        let insuranceArr = NSArray(contentsOfFile: NSHomeDirectory() + "/Documents/insurance.plist")
        
        for dict in insuranceArr! {
            if (dict as! NSDictionary).objectForKey("label") as! String == model.insurecompany {
                self.partiesdataDict.setValue((dict as! NSDictionary).objectForKey("value") as! String, forKey: "insurancecode")
            }
        }
        if model.insurecompany == nil || model.insurecompany.characters.count < 1 {
            
        }else {
            self.partiesdataDict.setValue(model.insurecompany, forKey: "insurancename")
        }
        
        self.partiesdataDict.setValue(loginData.mobile, forKey: "mobile")//电话
        self.partiesdataDict.setValue(model.carno, forKey: "partiescarno")//车牌
        self.partiesdataDict.setValue("0", forKey: "partiesmark")//用户还是对方的标记(0代表自己)
        self.partiesdataDict.setValue(model.renewed, forKey: "partiesname")
        self.partiesdataDict.setValue(model.vehiclemodelsid, forKey: "vehicleid")
        self.partiesdataDict.setValue(model.vehiclemodels, forKey: "vehiclename")
    }
}
