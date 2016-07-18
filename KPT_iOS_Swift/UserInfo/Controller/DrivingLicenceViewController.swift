//
//  DrivingLicenceViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/27.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import MBProgressHUD

class DrivingLicenceViewController: UIViewController,Kpt_NextBtnViewDelegate,Kpt_OCRImageViewDelegate {

    private var imageView:Kpt_OCRImageView?
    
    private var pickerView:Kpt_PickerView?
    
    private var ocrImage :UIImage?
    
    private var indexPath :NSIndexPath!
    ///专门用于接收用户信息的驾驶证信息传入
    var carInfoData : NSMutableDictionary! {
        didSet {
            self.changeDict = self.carInfoData
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let navigationBar = self.navigationController!.navigationBar;
        //纯色image，使用view生成
        navigationBar.setBackgroundImage(self.viewBeingImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        navigationBar.shadowImage = UIImage()

        navigationBar.barTintColor = UIColor.blackColor()
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        self.navigationController?.navigationBar.tintColor = MainColor
        
        tableView.reloadData()
    }
    //让view变成image
    private func viewBeingImage() ->UIImage {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCRW, height: 64))
        view.backgroundColor = UIColor.blackColor()
        
        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        return viewImage
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "完善驾驶证资料"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFontOfSize(19.0),NSForegroundColorAttributeName:MainColor]
        
        view = self.tableView
        // Do any additional setup after loading the view.
    }
    func nextBtnClick(nextBtn: Kpt_NextBtnView) {
        self.hud.labelText = "提交用户信息中..."
        self.hud.show(true)
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        let personalData = userDefault.objectForKey("userInfoLoginData") as! NSDictionary
        let userInfoData = UserInfoData.mj_objectWithKeyValues(personalData)
        ///驾驶证信息
        let data = taiEXinLe()
        
        let parame = ["requestcode":"001009","accessid":userInfoData.accessid,"accesskey":userInfoData.accesskey,"userid":userInfoData.userid,"data":data]
        KptRequestClient.sharedInstance.Kpt_post("/plugins/changhui/port/user/updateDrivingLicenseInfo", paramet: parame, viewController: self, success: { (data) -> Void in
            self.hud.hide(true)
            if self.carInfoData == nil {//nil表示不是由个人中心进入这里的
//                if #available(iOS 8.0, *) {
                    let alertV = UIAlertController(title: "信息提交成功\n", message: "您的驾驶信息提交成功，您可以继续完善您的车辆信息，以便以后快速使用", preferredStyle: UIAlertControllerStyle.Alert)
                    let cancelA = UIAlertAction(title: "不完善", style: UIAlertActionStyle.Default) { (cancelA) -> Void in
                        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
                    }
                    cancelA.setValue(UIColor(red: 218/255.0, green: 218/255.0, blue: 218/255.0, alpha: 1), forKey: "titleTextColor")
                    alertV.addAction(cancelA)
                    let defauA = UIAlertAction(title: "完善", style: UIAlertActionStyle.Default) { (defauA) -> Void in
                        userDefault.setValue("false", forKey:"addMyCarPush")//表示不是添加车辆，这是之前犯下的错误，等待修改
                        userDefault.synchronize()
                        self.navigationController?.pushViewController(CarInfoViewController(), animated: true)
                    }
                    defauA .setValue(MainColor, forKey: "titleTextColor")
                    alertV.addAction(defauA)
                    self.presentViewController(alertV, animated: true, completion: nil)
//                } else {
//                    // Fallback on earlier versions
//                }
               
            }else {
                self.hud.labelText = "变更信息成功"
                self.hud.hide(true, afterDelay: 1.0)
                self.navigationController?.popViewControllerAnimated(true)
            }
            
            
            }) { (_) -> Void in
                self.hud.hide(true)
        }

    }
    
    private func taiEXinLe() ->NSDictionary {
        var drivinglicenseno = String()
        if changeDict.objectForKey("身份证号") != nil {
            drivinglicenseno = changeDict.objectForKey("身份证号") as! String
        }
        var drivinglicensename = String()
        if changeDict.objectForKey("姓名") != nil {
            drivinglicensename = changeDict.objectForKey("姓名")  as! String
        }
        var drivinglicensesex = String()
        if changeDict.objectForKey("性别") != nil {
            drivinglicensesex = changeDict.objectForKey("性别")as! String
        }
        var drivinglicensenationality = String()
        if changeDict.objectForKey("国籍") != nil {
            drivinglicensenationality = changeDict.objectForKey("国籍") as! String
        }else {
            drivinglicensenationality = "中国"
        }
        var drivinglicenseaddress = String()
        if changeDict.objectForKey("住址") != nil {
            drivinglicenseaddress = changeDict.objectForKey("住址")as! String
        }
        var drivinglicensebirthdate = String()
        if changeDict.objectForKey("出生日期") != nil {
            drivinglicensebirthdate = changeDict.objectForKey("出生日期")as! String
        }
        var drivinglicensefristdate = String()
        if changeDict.objectForKey("初始领证日期") != nil {
            drivinglicensefristdate = changeDict.objectForKey("初始领证日期")as! String
        }
        var drivinglicensecartype = String()
        if changeDict.objectForKey("准驾车型") != nil {
            drivinglicensecartype = changeDict.objectForKey("准驾车型")as! String
        }
        var drivinglicensevaliddate = String()
        if changeDict.objectForKey("有效期限") != nil {
            drivinglicensevaliddate = changeDict.objectForKey("有效期限")as! String
        }
        var drivinglicenseurl = ""
        if changeDict.objectForKey("registration") != nil {
            drivinglicenseurl = changeDict.objectForKey("registration")as! String
        }
        
        let data:NSDictionary = [
            "drivinglicenseno":drivinglicenseno,
            "drivinglicensename":drivinglicensename,
            "drivinglicensesex":drivinglicensesex,
            "drivinglicensenationality":drivinglicensenationality,
            "drivinglicenseaddress":drivinglicenseaddress,
            "drivinglicensebirthdate":drivinglicensebirthdate,
            "drivinglicensefristdate":drivinglicensefristdate,
            "drivinglicensecartype":drivinglicensecartype,
            "drivinglicensevaliddate":drivinglicensevaliddate,
            "drivinglicenseurl":drivinglicenseurl]
        return data
    }

    
    private lazy var tableView:UITableView = {
       let view = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    private lazy var oneArr = ["姓名","身份证号","性别","国籍","住址"]
    private lazy var twoArr = ["出生日期","初始领证日期","准驾车型","有效期限"]
    private lazy var changeDict:NSMutableDictionary = {
        let dict = NSMutableDictionary()
        for str in self.oneArr {
            dict.setValue(nil, forKey: str)
        }
        for str in self.twoArr {
            dict.setValue(nil, forKey: str)
        }
        return dict
    }()
    
    private lazy var hud : MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view.superview, animated: true)
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension DrivingLicenceViewController : UITableViewDelegate,UITableViewDataSource ,UIAlertViewDelegate{
    
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
        let DrivingCell = "DrivingCellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(DrivingCell)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: DrivingCell)
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
        }
        if indexPath.section == 0 {
            cell?.textLabel?.text = oneArr[indexPath.row]
        } else {
            cell?.textLabel?.text = twoArr[indexPath.row]
        }
        
        cell?.detailTextLabel?.text = self.changeDict.objectForKey((cell?.textLabel?.text)!) == nil ? "请输入\((cell?.textLabel?.text)!)" : self.changeDict.objectForKey((cell?.textLabel?.text)!) as! String
        return cell!
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01//设置为0，不会有效果，会变成默认高度
        }else {
            return 100
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
             imageView = Kpt_OCRImageView.creatTouchImage(CGRect(x: 0, y: 0, width: SCRW, height: (SCRW - 120) / 400 * 250 + 70),documentType:"驾驶证",controller:self)
            if self.changeDict.objectForKey("displayImageView") != nil {
                imageView?.displayImageView.image = self.changeDict.objectForKey("displayImageView") as? UIImage
                imageView?.displayImageView.contentMode = UIViewContentMode.ScaleAspectFit
            }else if self.changeDict.objectForKey("registration") != nil && (self.changeDict.objectForKey("registration") as! String).characters.count > 0 {
                imageView?.displayImageView.contentMode = UIViewContentMode.ScaleAspectFit
                imageView?.displayImageView.sd_setImageWithURL(NSURL(string:QinniuUrl + (self.changeDict.objectForKey("registration") as! String)))
            }
            imageView?.ocrDelegate = self
            imageView?.backgroundColor = UIColor.whiteColor()
            view.addSubview(imageView!)
            let label = UILabel(frame: CGRect(x: 15, y: view.frame.size.height - 25, width: 100, height: 20))
            label.text = "驾驶证信息"
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
                if key == "姓名" {
                    self.changeDict.setObject(value, forKey: "姓名")
                }else if key == "证号" {
                    self.changeDict.setObject(value, forKey: "身份证号")
                }
                else if key == "性别" {
                    self.changeDict.setObject(value, forKey: "性别")
                }
                else if key == "出生日期" {
                    self.changeDict.setObject(value, forKey: "出生日期")
                }
                else if key == "住址" {
                    self.changeDict.setObject(value, forKey: "住址")
                }
                else if key == "初始领证日期" {
                    self.changeDict.setObject(value, forKey: "初始领证日期")
                }
                else if key == "准驾车型" {
                    self.changeDict.setObject(value, forKey: "准驾车型")
                }
                else if key == "有效期限" {
                    self.changeDict.setObject(value, forKey: "有效期限")
                }
                self.changeDict.setObject("中国", forKey: "国籍")
            }
        }
        self.tableView.reloadData()
    }

    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: SCRW, height: 100))
        backView.backgroundColor = UIColor.RGBA(218, g: 218, b: 218)
        let view = Kpt_NextBtnView(frame: CGRect(x: 0, y: 20, width: SCRW, height: 80))
        view.btnText = "完成"
        view.delegate = self
        view.backgroundColor = UIColor.whiteColor()
        backView.addSubview(view)
        return backView
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        self.indexPath = indexPath
        
        if self.pickerView != nil {
            self.pickerView?.removeFromSuperview()
        }
        if cell?.textLabel?.text?.hasSuffix("日期") == true {
            print("点击这里了")
            creatPicker(pickerType.DatePick,arr: nil)
            pickerView?.ensureButtonReturnDate({ (str) -> Void in
                cell?.detailTextLabel?.text = str
                self.changeDict.setValue(str, forKey: (cell?.textLabel?.text)!)
            })
            return
        }else if cell?.textLabel?.text == "性别" {
            creatPicker(pickerType.OtherType,arr:["男","女"])
            pickerView?.ensureButtonReturnDate({ (str) -> Void in
                cell?.detailTextLabel?.text = str
                self.changeDict.setValue(str, forKey: (cell?.textLabel?.text)!)
            })
            return
        }else if cell?.textLabel?.text == "准驾车型" {
            creatPicker(pickerType.OtherType,arr:["A1","A2","A3","B1","B2","C1","C2","C3","C4","D","E","F","M","N","P"])
            pickerView?.ensureButtonReturnDate({ (str) -> Void in
                cell?.detailTextLabel?.text = str
                self.changeDict.setValue(str, forKey: (cell?.textLabel?.text)!)
            })
            return
        }else if cell?.textLabel?.text == "有效期限" {
            creatPicker(pickerType.OtherType,arr:["6年","10年","长期"])
            pickerView?.ensureButtonReturnDate({ (str) -> Void in
                cell?.detailTextLabel?.text = str
                self.changeDict.setValue(str, forKey: (cell?.textLabel?.text)!)
            })
            return
        }
        
        showInputText(cell?.textLabel?.text, detailStr: cell?.detailTextLabel?.text)
        ///这是系统自带的输入提醒框(安卓觉得输入框太小)
        //showInputField(cell?.textLabel?.text,detailStr:cell?.detailTextLabel?.text)
    }
    private func showInputText(str:String?,detailStr:String?) {
        
        
        let window = UIApplication.sharedApplication().keyWindow
        
        let textView = NSBundle.mainBundle().loadNibNamed("Kpt_textField", owner: nil, options: nil).last as! Kpt_textField
        textView.placeholder = str
        textView.detailsStr = detailStr
        textView.frame = UIScreen.mainScreen().bounds
        textView.returnSelectedResult { (text) -> Void in
            if text != nil {
                self.changeDict.setValue(text, forKey: str!)
                self.tableView.reloadData()
            }
        }
        window!.addSubview(textView)
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
            let cell = self.tableView.cellForRowAtIndexPath(indexPath)
            cell?.detailTextLabel?.text = textField?.text
            self.changeDict.setValue(textField?.text, forKey: cellText!)
//            self.tableView.reloadData()
//            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
        }
    }

    func creatPicker(type:pickerType,arr:[String]?) {
        pickerView = Kpt_PickerView.creatPickerWithFrame(CGRect(x: 0, y: SCRH - 220, width: SCRW, height: 220), type: type)
        pickerView?.pickArr = arr
        let window = UIApplication.sharedApplication().keyWindow
        window?.addSubview(self.pickerView!)
    }

}
