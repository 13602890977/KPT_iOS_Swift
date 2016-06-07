//
//  CarInfoViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/30.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class CarInfoViewController: UIViewController,Kpt_NextBtnViewDelegate {
    
    private var imageView:Kpt_OCRImageView?
    private var pickerView:Kpt_PickerView?
    private var ocrImage :UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = tableView
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    func nextBtnClick(nextBtn: Kpt_NextBtnView) {
        print("完成信息录入，返回首页，并自动登陆")
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    private lazy var tableView:UITableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
    private lazy var oneArr = ["车牌号码","车辆类型","车主姓名","住址"]
    private lazy var twoArr = ["发动机号","车架号","厂牌型号","品牌型号","登记日期","出险次数","投保公司","保险金额"]
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.textLabel?.text == "品牌型号" {
            print("请求车辆品牌数据")
            carBrandVC.returnMoldeNameText({ (modelName) -> Void in
                cell?.detailTextLabel?.text = modelName
                cell?.detailTextLabel?.font = UIFont.systemFontOfSize(15)
                cell?.detailTextLabel?.numberOfLines = 0
                cell?.detailTextLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
                self.changeDict.setValue(modelName, forKey: (cell?.textLabel?.text)!)
            })
            self.navigationController?.pushViewController(carBrandVC, animated: true)
            return
        }else if cell?.textLabel?.text?.hasSuffix("日期") == true {
            creatPicker(pickerType.DatePick,arr: nil)
            pickerView?.ensureButtonReturnDate({ (str) -> Void in
                cell?.detailTextLabel?.text = str
                self.changeDict.setValue(str, forKey: (cell?.textLabel?.text)!)
            })
            return
        }
    }
    func creatPicker(type:pickerType,arr:[String]?) {
        pickerView = Kpt_PickerView.creatPickerWithFrame(CGRect(x: 0, y: SCRH - 220, width: SCRW, height: 220), type: type)
        pickerView?.pickArr = arr
        let window = UIApplication.sharedApplication().keyWindow
        window?.addSubview(self.pickerView!)
    }
    private lazy var carBrandVC: CarBrandListTableViewController = CarBrandListTableViewController()
    
    
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
            imageView = Kpt_OCRImageView.creatTouchImage(CGRect(x: 0, y: 0, width: SCRW, height: 180),documentType:"行驶证",controller:self)
            if ocrImage != nil {
                imageView?.touchImageView.image = ocrImage
            }
            imageView?.backgroundColor = UIColor.whiteColor()
            view.addSubview(imageView!)
            let label = UILabel(frame: CGRect(x: 15, y: view.frame.size.height - 15, width: 100, height: 20))
            label.text = "车辆信息"
            view.addSubview(label)
            
        }else {
            view.frame = CGRect(x: 0, y: 0, width: SCRW, height: 20)
        }
        return view
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: SCRW, height: 100))
        backView.backgroundColor = UIColor.RGBA(218, g: 218, b: 218)
        let view = Kpt_NextBtnView(frame: CGRect(x: 0, y: 20, width: SCRW, height: 80))
        view.delegate = self
        view.btnText = "完成"
        view.backgroundColor = UIColor.whiteColor()
        backView.addSubview(view)
        return backView
    }
    
}
