//
//  CarInfoViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/30.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD

protocol CarInfoViewControllerDelegate:AnyObject {
    
    func optionalReturnCarNo(carno:String?)
}

class CarInfoViewController: UIViewController,Kpt_NextBtnViewDelegate,UIAlertViewDelegate,Kpt_OCRImageViewDelegate {
    ///用于接收从哪个控制器跳转过来的
    var comeFormWhere : String?
    ///用于接收车辆id（查询车辆信息会返回)
    var carid : String?
    private var imageView:Kpt_OCRImageView?
    private var pickerView:Kpt_PickerView?
    
    weak var delegate:CarInfoViewControllerDelegate?
    
    private var carno:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "车辆信息"
        self.view = tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        //提前准备好保险公司列表(异步)
        reloadInsurance()
    }
    func nextBtnClick(nextBtn: Kpt_NextBtnView) {
        print("完成信息录入，返回首页，并自动登陆")
        //判断必填的信息是否已填
        let arr = ["车牌号码","车辆类型","车主姓名","车型名称"]
        for key in arr {
            if self.changeDict.objectForKey(key) == nil {
//                if #available(iOS 8.0, *) {
                    let alertC = UIAlertController.creatAlertWithTitle(title: nil, message: "请输入\(key)", cancelActionTitle: "确定")
                    self.presentViewController(alertC, animated: true, completion: nil)
//                } else {
//                    // Fallback on earlier versions
//                }
//                
                return
            }
            
        }
        let userDefault = NSUserDefaults.standardUserDefaults()
        ///将恶心的数据格式转化放在一起
        let data = taiEXinLe()
        
        if comeFormWhere == "VehicleManagementController" {//从车辆管理进来
            let isAddMyCarPush = userDefault.objectForKey("addMyCarPush")
            if isAddMyCarPush != nil && (isAddMyCarPush as! String) == "true"{//代表添加车辆信息
                addCar(data)
            }else {//否则是更新车辆信息
                updateCar(data)
            }
            self.navigationController?.popViewControllerAnimated(true)
        }else if comeFormWhere == "discoverVC" {
            addCar(data)
            let onlineVC = OnlineInsuranceViewController(nibName:"OnlineInsuranceViewController",bundle: nil)
            onlineVC.carType = "oneCar"
            onlineVC.carnoStr = self.changeDict.objectForKey("车牌号码") as! String
            onlineVC.isWhatControllerPushIn = comeFormWhere
            onlineVC.carmodelStr = self.changeDict.objectForKey("车型名称") as! String
            self.navigationController?.pushViewController(onlineVC, animated: true)
        }else {//从车辆管理进来的
            addCar(data)
            //上传之后跳转并将车牌号码传递给事故类型界面上的我的车辆
            let isAddMyCarPush = userDefault.objectForKey("addMyCarPush")
            if isAddMyCarPush != nil && (isAddMyCarPush as! String) == "true"{
                
                creatPartiesDataMyCarDict(data)
                NSNotificationCenter.defaultCenter().postNotificationName("ReturnCarNo", object: self.partiesdataDict, userInfo: ["myCar":self.changeDict.objectForKey("车牌号码")!])
                self.navigationController?.popToRootViewControllerAnimated(true)
            }else {
                //这是注册之后的跳转
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
    }
    private func creatPartiesDataMyCarDict(data:NSDictionary) {
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        let personalData = userDefault.objectForKey("userInfoLoginData") as! NSDictionary
        let userInfoData = UserInfoData.mj_objectWithKeyValues(personalData)
        
        let insuranceArr = NSArray(contentsOfFile: NSHomeDirectory() + "/Documents/insurance.plist")
        
        for dict in insuranceArr! {//根据投保公司名称查找公司id，前提是公司有选择
            if let insurecompany = self.changeDict.objectForKey("投保公司") as? String {
                if (dict as! NSDictionary).objectForKey("label") as! String == insurecompany {
                    self.partiesdataDict.setValue((dict as! NSDictionary).objectForKey("value") as! String, forKey: "insurancecode")
                }
                self.partiesdataDict.setValue(insurecompany, forKey: "insurancename")
            }

        }
            
        self.partiesdataDict.setValue(userInfoData.mobile, forKey: "mobile")//电话
        self.partiesdataDict.setValue(self.changeDict.objectForKey("车牌号码"), forKey: "partiescarno")//车牌
        self.partiesdataDict.setValue("0", forKey: "partiesmark")//用户还是对方的标记(0代表自己)
        self.partiesdataDict.setValue(self.changeDict.objectForKey("车主姓名"), forKey: "partiesname")
        self.partiesdataDict.setValue(self.changeDict.objectForKey("vehiclemodelsid"), forKey: "vehicleid")
        self.partiesdataDict.setValue(self.changeDict.objectForKey("车型名称"), forKey: "vehiclename")
    }
    
    private func updateCar(data:NSDictionary) {
        let userDefault = NSUserDefaults.standardUserDefaults()
        let personalData = userDefault.objectForKey("userInfoLoginData") as! NSDictionary
        let userInfoData = UserInfoData.mj_objectWithKeyValues(personalData)
        
        self.hud.labelText = "更新车辆信息中..."
        self.hud.show(true)
        let dataDict = data.mutableCopy() as! NSMutableDictionary
        dataDict.setValue(carid!, forKey: "carid")
        let vehicleParamets:NSMutableDictionary = ["requestcode":"002002","accessid":userInfoData.accessid,"accesskey":userInfoData.accesskey,"userid":userInfoData.userid]
        vehicleParamets.setValue(dataDict, forKey: "data")
        
        KptRequestClient.sharedInstance.Kpt_post("/plugins/changhui/port/car/updateCarInfo", paramet: vehicleParamets, viewController: self, success: { (data) -> Void in
            self.hud.labelText = "更新成功"
            self.hud.hide(true, afterDelay: 1.0)
            print(data)
            }) { (_) -> Void in
                self.hud.hide(true)
        }
    }
    private func addCar(data:NSDictionary) {
        let userDefault = NSUserDefaults.standardUserDefaults()
        let personalData = userDefault.objectForKey("userInfoLoginData") as! NSDictionary
        let userInfoData = UserInfoData.mj_objectWithKeyValues(personalData)
        
        
        self.hud.labelText = "添加车辆信息中..."
        self.hud.show(true)
        let paramets:NSMutableDictionary = ["requestcode":"002003","accessid":userInfoData.accessid,"accesskey":userInfoData.accesskey,"userid":userInfoData.userid]
        paramets.setValue(data, forKey: "data")
        KptRequestClient.sharedInstance.Kpt_post("/plugins/changhui/port/car/addCarInfo", paramet: paramets, viewController: self, success: { (data) -> Void in
            print(data)
            self.hud.hide(true)
            }) { (_) -> Void in
                self.hud.hide(true)
        }
    }
    private lazy var tableView:UITableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
    private lazy var oneArr = ["车牌号码","车辆类型","车主姓名","住址"]
    private lazy var twoArr = ["发动机号","车架号","厂牌型号","车型名称","登记日期","发证日期","出险次数","投保公司","保险金额"]
    private lazy var oneDetailArr = ["请输入车牌号码","请选择车辆类型","请输入车主姓名","请输入地址"]
    
    private lazy var twoDetailArr = ["请输入发动机号","请输入车架号","请输入厂牌型号","请选择车型","请选择登记日期","请选择发证日期","请选择出险次数","请选择投保公司","请输入保险金额"]
    
    lazy var changeDict:NSMutableDictionary = {
        let dict = NSMutableDictionary()
        for str in self.oneArr {
            dict.setValue(nil, forKey: str)
        }
        for str in self.twoArr {
            dict.setValue(nil, forKey: str)
        }
        dict.setValue(nil, forKey:"registration")
        return dict
    }()
    ///从事故类型添加车辆进入，用于保存车辆信息
    private lazy var partiesdataDict: NSMutableDictionary = NSMutableDictionary()
    private func reloadInsurance() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            self.storageAndReadingListOfInsuranceCompanies()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if self.pickerView != nil {
            self.pickerView?.removeFromSuperview()
        }
        if cell?.textLabel?.text == "车型名称" {
            print("请求车辆品牌数据")
            carBrandVC.returnMoldeNameText({ (model) -> Void in
                cell?.detailTextLabel?.text = model.modelname
                
                cell?.detailTextLabel?.font = UIFont.systemFontOfSize(15)
                cell?.detailTextLabel?.numberOfLines = 0
                cell?.detailTextLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
                self.changeDict.setValue(model.modelname, forKey: (cell?.textLabel?.text)!)
                self.changeDict.setObject(model.modelid, forKey: "vehiclemodelsid")
            })
            self.navigationController?.pushViewController(carBrandVC, animated: true)
            return
        }else if cell?.textLabel?.text?.hasSuffix("日期") == true {
            let cellHeight:CGFloat = IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 44
            creatPicker(pickerType.DatePick,arr: nil)
            //将tableview移动到指定位置
            self.tableView.scrollRectToVisible(CGRect(x: 0, y: (cellHeight + 15) * CGFloat(indexPath.row + indexPath.section), width: SCRW, height: SCRH), animated: true)
            pickerView?.ensureButtonReturnDate({ (str) -> Void in
                cell?.detailTextLabel?.text = str
                self.changeDict.setValue(str, forKey: (cell?.textLabel?.text)!)
            })
            return
        }else if cell?.textLabel?.text == "车辆类型" {
            let cellHeight:CGFloat = IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 44
            let carTypeArr = ["小型普通客车","中型普通客车","大型普通客车","重型普通货车","重型箱式货车","重型自卸货车","中型封闭货车","其他"]
            creatPicker(pickerType.OtherType,arr: carTypeArr)
            //将tableview移动到指定位置
            self.tableView.scrollRectToVisible(CGRect(x: 0, y: (cellHeight + 15) * CGFloat(indexPath.row + indexPath.section), width: SCRW, height: SCRH), animated: true)
            pickerView?.ensureButtonReturnDate({ (str) -> Void in
                cell?.detailTextLabel?.text = str
                self.changeDict.setValue(str, forKey: (cell?.textLabel?.text)!)
            })
            return
        }else if cell?.textLabel?.text == "出险次数" {
            let cellHeight:CGFloat = IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 44
            let carTypeArr = ["连续3年未出险","连续2年未出险","上年度未出险","上年度出险1次","上年度出险2次","上年度出险3次","上年度出险4次","上年度出险5次"]
            creatPicker(pickerType.OtherType,arr: carTypeArr)
            //将tableview移动到指定位置
            self.tableView.scrollRectToVisible(CGRect(x: 0, y: (cellHeight + 15) * CGFloat(indexPath.row + indexPath.section), width: SCRW, height: SCRH), animated: true)
            pickerView?.ensureButtonReturnDate({ (str) -> Void in
                var changeStr = "次"
                if str == carTypeArr[0] {
                    changeStr = "-3次"
                }else if str == carTypeArr[1] {
                    changeStr = "-2次"
                }else if str == carTypeArr[2] {
                    changeStr = "0次"
                }else if str == carTypeArr[3] {
                    changeStr = "1次"
                }else if str == carTypeArr[4] {
                    changeStr = "2次"
                }else if str == carTypeArr[5] {
                    changeStr = "3次"
                }else if str == carTypeArr[6] {
                    changeStr = "4次"
                }else if str == carTypeArr[7] {
                    changeStr = "5次"
                }
                cell?.detailTextLabel?.text = changeStr
                self.changeDict.setValue(changeStr, forKey: (cell?.textLabel?.text)!)
            })
            return
        }else if cell?.textLabel?.text == "投保公司" {
            let cellHeight:CGFloat = IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 44
            
            let insuranceArr = NSArray(contentsOfFile:NSHomeDirectory() + "/Documents/insurance.plist")
            if insuranceArr != nil {
                var carTypeArr:[String]? = [String]()
                if let arr = insuranceArr{
                    for dict in arr {
                        let label = (dict as! NSDictionary).objectForKey("label")
                        carTypeArr?.append(label as! String)
                    }
                    self.creatPicker(pickerType.OtherType, arr: carTypeArr)
                    
                    //将tableview移动到指定位置
                    self.tableView.scrollRectToVisible(CGRect(x: 0, y: (cellHeight + 15) * CGFloat(indexPath.row + indexPath.section), width: SCRW, height: SCRH), animated: true)
                    self.pickerView?.ensureButtonReturnDate({ (str) -> Void in
                        cell?.detailTextLabel?.text = str
                        self.changeDict.setValue(str, forKey: (cell?.textLabel?.text)!)
                    })
                }
            }
            return
        }
        showInputField(cell?.textLabel?.text,detailStr:cell?.detailTextLabel?.text)
    }
    //弹出输入框
    private func showInputField(str:String?,detailStr:String?) {
        let alertV = UIAlertView(title: "请输入\(str!)", message:"", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alertV.alertViewStyle = UIAlertViewStyle.PlainTextInput
        let textField = alertV.textFieldAtIndex(0)
        textField?.clearButtonMode = UITextFieldViewMode.WhileEditing
        if "请输入\(str!)" == detailStr {
            textField?.placeholder = detailStr!
        }else {
            textField?.placeholder = "请输入\(str!)"
            textField?.text  = detailStr!
        }
        
        alertV.show()
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let buttonTitle = alertView.buttonTitleAtIndex(buttonIndex)
        
        if buttonTitle == "确定" {
            let textField = alertView.textFieldAtIndex(0)
            let range = textField?.placeholder?.rangeOfString("请输入")
            let cellText = textField?.placeholder?.substringFromIndex((range?.endIndex)!)
            if cellText == "车牌号码" {
                carno = textField?.text
            }
            self.changeDict.setValue(textField?.text, forKey: cellText!)
            self.tableView.reloadData()
        }
    }
    
    //创建选择器
    private func creatPicker(type:pickerType,arr:[String]?) {
        pickerView = Kpt_PickerView.creatPickerWithFrame(CGRect(x: 0, y: SCRH - 220, width: SCRW, height: 220), type: type)
        pickerView?.pickArr = arr
        let window = UIApplication.sharedApplication().keyWindow
        window?.addSubview(self.pickerView!)
        
    }
    
    private lazy var carBrandVC: CarBrandListTableViewController = CarBrandListTableViewController()
    
    private lazy var hud : MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view.superview, animated: true)
    
    //这个太恶心，不想看到
    private func taiEXinLe() ->NSDictionary {
        //出险次数 格式转换
        var numberStr = self.changeDict.objectForKey(twoArr[6])
        var number = String()
        if numberStr != nil {
            let str = (numberStr as! String).characters
            numberStr =  (numberStr as! NSString).substringToIndex(str.count - 1)
            number = numberStr as! String
        }
        var renewed = String()
        if changeDict.objectForKey(oneArr[2]) != nil {
            renewed = changeDict.objectForKey(oneArr[2]) as! String
        }
        var address = String()
        if changeDict.objectForKey(oneArr[3]) != nil {
            address = changeDict.objectForKey(oneArr[3])  as! String
        }
        var cartype = String()
        if changeDict.objectForKey(oneArr[1]) != nil {
            cartype = changeDict.objectForKey(oneArr[1])as! String
        }
        var carno = String()
        if changeDict.objectForKey(oneArr[0]) != nil {
            carno = changeDict.objectForKey(oneArr[0]) as! String
        }
        var engineno = String()
        if changeDict.objectForKey(twoArr[0]) != nil {
            engineno = changeDict.objectForKey(twoArr[0])as! String
        }
        var vinno = String()
        if changeDict.objectForKey(twoArr[1]) != nil {
            vinno = changeDict.objectForKey(twoArr[1])as! String
        }
        var brandno = String()
        if changeDict.objectForKey(twoArr[2]) != nil {
            brandno = changeDict.objectForKey(twoArr[2])as! String
        }
        var initialdate = String()
        if changeDict.objectForKey(twoArr[4]) != nil {
            initialdate = changeDict.objectForKey(twoArr[4])as! String
        }
        var registration = String()
        if changeDict.objectForKey("registration") != nil {
            registration = changeDict.objectForKey("registration")as! String
        }
        var vehiclemodels = String()
        if changeDict.objectForKey(twoArr[3]) != nil {
            vehiclemodels = self.changeDict.objectForKey(twoArr[3])as! String
        }
        var vehiclemodelsid = String()
        if changeDict.objectForKey("vehiclemodelsid") != nil {
            vehiclemodelsid = self.changeDict.objectForKey("vehiclemodelsid")as! String
        }
        var insurecompany = ""
        if changeDict.objectForKey(twoArr[7]) != nil {
            insurecompany = self.changeDict.objectForKey(twoArr[7]) as! String
        }
        var insuremoney = Double()
        if changeDict.objectForKey(twoArr[8]) != nil {
            insuremoney = (self.changeDict.objectForKey(twoArr[8])?.doubleValue)!
        }
        let data:NSDictionary = [
            "renewed":renewed,
            "address":address,
            "cartype":cartype,
            "carno":carno,
            "engineno":engineno,
            "vinno":vinno,
            "brandno":brandno,
            "beindangertime":number,
            "initialdate":initialdate,
            "registration":registration,
            "vehiclemodels":vehiclemodels,
            "vehiclemodelsid":vehiclemodelsid,
            "insurecompany":insurecompany,
            "insuremoney":insuremoney]
        return data
    }
    
}
extension CarInfoViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 44
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return oneArr.count
        }
        return twoArr.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let CarinfoCellIdentifier = "CarinfoCellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(CarinfoCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: CarinfoCellIdentifier)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        if indexPath.section == 0 {
            cell?.textLabel?.text = oneArr[indexPath.row]
            
        } else {
            cell?.textLabel?.text = twoArr[indexPath.row]
            
        }
        
//        if ((self.changeDict.objectForKey((cell?.textLabel?.text)!)?.isKindOfClass(NSString)) != nil) {
//            
//        }
//        
        if let str = self.changeDict.objectForKey((cell?.textLabel?.text)!) {
            if (str as? String)!.characters.count == 0 {
                cell?.detailTextLabel?.text = "请输入\((cell?.textLabel?.text)!)"
            }else {
                cell?.detailTextLabel?.text = str as? String
            }
        }else {
           cell?.detailTextLabel?.text = "请输入\((cell?.textLabel?.text)!)"
        }
//        cell?.detailTextLabel?.text = self.changeDict.objectForKey((cell?.textLabel?.text)!) == nil ? "请输入\((cell?.textLabel?.text)!)" : self.changeDict.objectForKey((cell?.textLabel?.text)!) as! String
        
        return cell!
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01//设置为0，不会有效果，会变成默认高度
        }else {
            return (IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 40) + 60
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return (SCRW - 120) / 400 * 250 + 110
        }
        else {
            return 20
        }
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.RGBA(218, g: 218, b: 218)
        if section == 0 {
            view.frame = CGRect(x: 0, y:0, width: SCRW, height: (SCRW - 120) / 400 * 250 + 110)
            imageView = Kpt_OCRImageView.creatTouchImage(CGRect(x: 0, y: 0, width: SCRW, height: (SCRW - 120) / 400 * 250 + 70),documentType:"行驶证",controller:self)
            imageView?.backgroundColor = UIColor.whiteColor()
            imageView?.ocrDelegate = self
            if self.changeDict.objectForKey("displayImageView") != nil {
                imageView?.displayImageView.image = self.changeDict.objectForKey("displayImageView") as? UIImage
                imageView?.displayImageView.contentMode = UIViewContentMode.ScaleAspectFit
                imageView?.displayImageView.clipsToBounds = true
            }else if self.changeDict.objectForKey("registration") != nil && (self.changeDict.objectForKey("registration") as! String).characters.count > 0 {
                imageView?.displayImageView.contentMode = UIViewContentMode.ScaleAspectFill
                imageView?.displayImageView.clipsToBounds = true
                imageView?.displayImageView.sd_setImageWithURL(NSURL(string:QinniuUrl + (self.changeDict.objectForKey("registration") as! String)))
            }
            view.addSubview(imageView!)
            let label = UILabel(frame: CGRect(x: 15, y: view.frame.size.height - 30, width: 100, height: 20))
            label.text = "车辆信息"
            view.addSubview(label)
            
        }else {
            view.frame = CGRect(x: 0, y: 0, width: SCRW, height: 20)
        }
        return view
    }
    //ocr图像识别代理方法
    func returnOCRDataAndImage(image:UIImage?,QNImageUrl:String,data: AnyObject) {
        self.changeDict.setObject(image!, forKey: "displayImageView")
        self.changeDict.setObject(QNImageUrl, forKey: "registration")
        for object in (data as! NSArray) {
            let value = object.objectForKey("content") as! String
            let key = object.objectForKey("desc") as! String
            if value.characters.count > 0 {
                if key == "所有人" {
                    self.changeDict.setObject(value, forKey: "车主姓名")
                }
                else if key == "号牌号码" {
                    self.changeDict.setObject(value, forKey: "车牌号码")
                }
                else if key == "车辆类型" {
                    self.changeDict.setObject(value, forKey: "车辆类型")
                }
                else if key == "住址" {
                    self.changeDict.setObject(value, forKey: "住址")
                }
                else if key == "车辆识别代号" {
                    self.changeDict.setObject(value, forKey: "车架号")
                }
                else if key == "发动机号码" {
                    self.changeDict.setObject(value, forKey: "发动机号")
                }
                else if key == "注册日期" {
                    self.changeDict.setObject(value, forKey: "登记日期")
                }
                else if key == "发证日期" {
                    self.changeDict.setObject(value, forKey: "发证日期")
                }
                else if key == "品牌型号" {
                    self.changeDict.setObject(value, forKey: "厂牌型号")
                }
            }
        }
        self.tableView.reloadData()
    }

    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let cellMainHeight:CGFloat = IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 40
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: SCRW, height: cellMainHeight + 60))
        backView.backgroundColor = UIColor.RGBA(218, g: 218, b: 218)
        let view = Kpt_NextBtnView(frame: CGRect(x: 0, y: 20, width: SCRW, height: cellMainHeight + 40))
        view.delegate = self
        view.btnText = "完成"
        view.backgroundColor = UIColor.whiteColor()
        backView.addSubview(view)
        return backView
    }
    
}
