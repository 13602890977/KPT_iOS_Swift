//
//  DrivingLicenceViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/27.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class DrivingLicenceViewController: UIViewController,Kpt_NextBtnViewDelegate,Kpt_OCRImageViewDelegate {

    private var imageView:Kpt_OCRImageView?
    
    private var pickerView:Kpt_PickerView?
    
    private var ocrImage :UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        view = tableView
        // Do any additional setup after loading the view.
    }
    func nextBtnClick(nextBtn: Kpt_NextBtnView) {
        self.navigationController?.pushViewController(CarInfoViewController(), animated: true)
    }
    private lazy var tableView:UITableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
    private lazy var oneArr = ["姓名","身份证号","性别","国籍","住址"]
    private lazy var twoArr = ["出生日期","初次领证日期","准驾车型","有效起始日期","有效期限"]
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension DrivingLicenceViewController : UITableViewDelegate,UITableViewDataSource {
    
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
            return 210
        }
        else {
            return 20
        }
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.RGBA(218, g: 218, b: 218)
        if section == 0 {
            view.frame = CGRect(x: 0, y:0, width: SCRW, height: 200)
            imageView = Kpt_OCRImageView.creatTouchImage(CGRect(x: 0, y: 0, width: SCRW, height: 180),documentType:"驾驶证",controller:self)
            if ocrImage != nil {
                imageView?.touchImageView.image = ocrImage
            }
            imageView?.ocrDelegate = self
            imageView?.backgroundColor = UIColor.whiteColor()
            view.addSubview(imageView!)
            let label = UILabel(frame: CGRect(x: 15, y: view.frame.size.height - 15, width: 100, height: 20))
            label.text = "驾驶证信息"
            view.addSubview(label)
            
        }else {
            view.frame = CGRect(x: 0, y: 0, width: SCRW, height: 20)
        }
        return view
    }
    func returnOCRDataAndImage(image: UIImage?, QNImageUrl: String, data: AnyObject) {
        
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: SCRW, height: 100))
        backView.backgroundColor = UIColor.RGBA(218, g: 218, b: 218)
        let view = Kpt_NextBtnView(frame: CGRect(x: 0, y: 20, width: SCRW, height: 80))
        view.btnText = "下一步"
        view.delegate = self
        view.backgroundColor = UIColor.whiteColor()
        backView.addSubview(view)
        return backView
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
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
        let changeVC = ChangeInfoController()
        changeVC.cell = cell
        changeVC.returnChangeBeforeText { (text) -> Void in
            cell?.detailTextLabel?.text = text
            self.changeDict.setValue(text, forKey: (cell?.textLabel?.text)!)
        }
        self.navigationController?.pushViewController(changeVC, animated: true)
    }
    
    func creatPicker(type:pickerType,arr:[String]?) {
        pickerView = Kpt_PickerView.creatPickerWithFrame(CGRect(x: 0, y: SCRH - 220, width: SCRW, height: 220), type: type)
        pickerView?.pickArr = arr
        let window = UIApplication.sharedApplication().keyWindow
        window?.addSubview(self.pickerView!)
    }

}
