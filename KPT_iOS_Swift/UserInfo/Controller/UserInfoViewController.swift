//
//  UserInfoViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/26.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import MBProgressHUD

class UserInfoViewController: UIViewController,Kpt_NextBtnViewDelegate,Kpt_OCRImageViewDelegate {
    
    private var imageView:Kpt_OCRImageView?
    var pickerView:Kpt_PickerView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "添加对方车辆"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.whiteColor()
        view.addSubview(tableView)
       
        reloadInsurance()
    }
    
    func nextBtnClick(nextBtn: Kpt_NextBtnView) {
        //判断必填的信息是否已填
        for var i = 0; i < cellArr.count - 1;i++ {
            if self.changeDict.objectForKey(cellArr[i]) == nil {
                let alertC = UIAlertController.creatAlertWithTitle(title: nil, message: cellDetailArr[i], cancelActionTitle: "确定")
                self.presentViewController(alertC, animated: true, completion: nil)
                return
            }
            
        }
        let insuranceArr = NSArray(contentsOfFile: NSHomeDirectory() + "/Documents/insurance.plist")
        self.partiesdataDict.setValue(nil, forKey: "insurancecode")
        if let baoxian = self.changeDict.objectForKey("保险公司") as? String {
            for dict in insuranceArr! {
                
                if (dict as! NSDictionary).objectForKey("label") as! String == baoxian {
                    self.partiesdataDict.setValue((dict as! NSDictionary).objectForKey("value") as! String, forKey: "insurancecode")
                }
                
            }
             self.partiesdataDict.setValue(baoxian, forKey: "insurancename")
        }else {
             self.partiesdataDict.setValue(nil, forKey: "insurancename")
        }
        
        self.partiesdataDict.setValue(self.changeDict.objectForKey("驾驶证号") as! String, forKey: "licenseno")
        
       
        self.partiesdataDict.setValue(self.changeDict.objectForKey("电话号码") as! String, forKey: "mobile")//电话
        self.partiesdataDict.setValue(self.changeDict.objectForKey("车牌号码") as! String, forKey: "partiescarno")//车牌
        self.partiesdataDict.setValue("1", forKey: "partiesmark")//用户还是对方的标记(0代表自己)
        self.partiesdataDict.setValue(self.changeDict.objectForKey("当事人") as! String, forKey: "partiesname")
        self.partiesdataDict.setValue(self.changeDict.objectForKey("vehiclemodelsid") as! String, forKey: "vehicleid")
        self.partiesdataDict.setValue(self.changeDict.objectForKey("车型") as! String, forKey: "vehiclename")
        
        print("选择对方车辆之后的数据 -- \(self.partiesdataDict)")
        NSNotificationCenter.defaultCenter().postNotificationName("ReturnCarNo", object: self.partiesdataDict, userInfo: ["otherCar":self.changeDict.objectForKey("车牌号码")!])
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func returnOCRDataAndImage(image: UIImage?, QNImageUrl: String, data: AnyObject) {
        
    }
    private func reloadInsurance() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            self.storageAndReadingListOfInsuranceCompanies()
        }
    }
    private lazy var tableView:UITableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
    
    private lazy var cellArr = ["当事人","车牌号码","车型","驾驶证号","电话号码","保险公司"]
    private lazy var cellDetailArr = ["请输入当事人","请输入车牌号码","请选择车型","请输入驾驶证号","请输入电话号码","请选择保险公司"]
    
    lazy var changeDict:NSMutableDictionary = {
        let dict = NSMutableDictionary()
        for str in self.cellArr {
            dict.setValue(nil, forKey: str)
        }
        dict.setValue(nil, forKey:"registration")
        return dict
    }()
    ///用于保存对方的车辆的信息
    private lazy var partiesdataDict:NSMutableDictionary = NSMutableDictionary()
    
    private lazy var carBrandVC: CarBrandListTableViewController = CarBrandListTableViewController()
    
    private lazy var hud : MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view.superview, animated: true)
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UserInfoViewController : UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 44
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArr.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let idCellIndentifier = "idCellIndentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(idCellIndentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: idCellIndentifier)
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        
         cell?.textLabel?.text = cellArr[indexPath.row]
        if let str = self.changeDict.objectForKey((cell?.textLabel?.text)!) {
            if (str as? String)!.characters.count == 0 {
                cell?.detailTextLabel?.text = cellDetailArr[indexPath.row]
            }else {
                cell?.detailTextLabel?.text = str as? String
            }
        }else {
            cell?.detailTextLabel?.text = cellDetailArr[indexPath.row]
        }
       
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if cell?.textLabel?.text == "保险公司" {
            
            let insuranceArr = NSArray(contentsOfFile:NSHomeDirectory() + "/Documents/insurance.plist")
            if insuranceArr != nil {
                var carTypeArr:[String]? = [String]()
                if let arr = insuranceArr{
                    for dict in arr {
                        let label = (dict as! NSDictionary).objectForKey("label")
                        carTypeArr?.append(label as! String)
                    }
                     self.creatPicker(pickerType.OtherType, arr: carTypeArr, myCell: cell, cellIndexPath: indexPath)
                }
            }
            return
        }else if cell?.textLabel?.text == "车型" {
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
        }
        showInputField(cell?.detailTextLabel?.text,detailStr: cellDetailArr[indexPath.row])
    }
    
    //弹出输入框
    private func showInputField(str:String?,detailStr:String) {
        let alertV = UIAlertView(title: detailStr, message:"", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alertV.alertViewStyle = UIAlertViewStyle.PlainTextInput
        let textField = alertV.textFieldAtIndex(0)
        textField?.clearButtonMode = UITextFieldViewMode.WhileEditing
        if str! == detailStr {
            textField?.placeholder = str!
        }else {
            textField?.placeholder = detailStr
            textField?.text  = str!
        }
        alertV.show()
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let buttonTitle = alertView.buttonTitleAtIndex(buttonIndex)
        
        if buttonTitle == "确定" {
            let textField = alertView.textFieldAtIndex(0)
            let range = textField?.placeholder?.rangeOfString("请输入")
            let cellText = textField?.placeholder?.substringFromIndex((range?.endIndex)!)
            
            self.changeDict.setValue(textField?.text, forKey: cellText!)
            self.tableView.reloadData()
        }
    }

    //创建选择器
    private func creatPicker(type:pickerType,arr:[String]?,myCell:UITableViewCell?,cellIndexPath:NSIndexPath) {
        
        let cellHeight:CGFloat = IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 44
        
        pickerView = Kpt_PickerView.creatPickerWithFrame(CGRect(x: 0, y: SCRH - 220, width: SCRW, height: 220), type: type)
        pickerView?.pickArr = arr
        let window = UIApplication.sharedApplication().keyWindow
        window?.addSubview(self.pickerView!)
        
        //将tableview移动到指定位置
        self.tableView.scrollRectToVisible(CGRect(x: 0, y: (cellHeight + 15) * CGFloat(cellIndexPath.row + cellIndexPath.section), width: SCRW, height: SCRH), animated: true)
        
        pickerView?.ensureButtonReturnDate({ (str) -> Void in
            myCell?.detailTextLabel?.text = str
            self.changeDict.setValue(str, forKey: (myCell?.textLabel?.text)!)
        })
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 40) + 60
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (SCRW - 120) / 400 * 250 + 90
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.RGBA(218, g: 218, b: 218)
       
        view.frame = CGRect(x: 0, y:0, width: SCRW, height: (SCRW - 120) / 400 * 250 + 90)
        imageView = Kpt_OCRImageView.creatTouchImage(CGRect(x: 0, y: 0, width: SCRW, height: (SCRW - 120) / 400 * 250 + 70),documentType:"驾驶证",controller:self)
        imageView?.backgroundColor = UIColor.whiteColor()
        imageView?.ocrDelegate = self
            if self.changeDict.objectForKey("displayImageView") != nil {
                imageView?.displayImageView.image = self.changeDict.objectForKey("displayImageView") as? UIImage
                imageView?.displayImageView.contentMode = UIViewContentMode.ScaleAspectFit
            }else if self.changeDict.objectForKey("registration") != nil && (self.changeDict.objectForKey("registration") as! String).characters.count > 0 {
                imageView?.displayImageView.sd_setImageWithURL(NSURL(string: (self.changeDict.objectForKey("registration") as! String)))
        }
        view.addSubview(imageView!)
        
        return view
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cellMainHeight:CGFloat = IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 40
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: SCRW, height: cellMainHeight + 60))
        backView.backgroundColor = UIColor.RGBA(218, g: 218, b: 218)
        let view = Kpt_NextBtnView(frame: CGRect(x: 0, y: 20, width: SCRW, height: cellMainHeight + 40))
        view.delegate = self
        view.btnText = "确定"
        view.backgroundColor = UIColor.whiteColor()
        backView.addSubview(view)
        return backView
    }
}