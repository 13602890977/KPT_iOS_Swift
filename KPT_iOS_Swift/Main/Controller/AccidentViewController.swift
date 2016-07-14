//
//  AccidentViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/8.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class AccidentViewController: UIViewController {
    
    
    private var backView : AccidentView!
    ///保存我的车辆和对方车辆(双车事故才需要)
    var carTypeArr:[String]!
    ///保存返回的我的车牌号码，
    private var myCarNumber: String?
    ///保存返回的对方车辆的车牌号码
    private var otherCarNumber : String?
    
    ///记录选择的是事故类型(单车还是双车)默认是双侧事故
    private var typeAccident = "twoCar"
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let navigationBar = self.navigationController!.navigationBar
        navigationBar.barTintColor = UIColor.blackColor()
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        self.navigationController?.navigationBar.tintColor = MainColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //注册通知，用于获取车牌号码
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "optionalReturnCarNo:", name:"ReturnCarNo", object: nil)
        
        self.title = "事故类型"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFontOfSize(19.0),NSForegroundColorAttributeName:MainColor]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "展开"), style: UIBarButtonItemStyle.Plain, target: self, action: "popView")
        
        self.navigationItem.leftBarButtonItem?.tintColor = MainColor
        self.carTypeArr = ["我的车辆","对方车辆"]
        
        self.view.addSubview(self.tableView)
        self.tableView.scrollEnabled = false
        
        backView = AccidentView.creatAccidentBackgroundViewWith(frame: UIScreen.mainScreen().bounds, controller: self)
        UIApplication.sharedApplication().keyWindow!.addSubview(backView)
    }
    
   
    ///添加车辆的驾驶证页面的通知方法
    func optionalReturnCarNo(info: NSNotification?) {
        print(info?.userInfo)
        print(info?.object)
        let carDict:NSDictionary = (info?.userInfo)!
        if carDict.objectForKey("myCar") != nil {
           myCarNumber = carDict.objectForKey("myCar") as? String
            if self.partiesdata.count > 0 {
                for dicr in self.partiesdata {
                    if let dict = dicr as? NSDictionary {
                        if dict.objectForKey("partiesmark") as! String == "0" {
                            self.partiesdata.removeObject(dicr)
                        }
                    }
                }
            }
            self.partiesdata.addObject((info?.object)!)
            
        }else if carDict.objectForKey("otherCar") != nil {
            otherCarNumber = carDict.objectForKey("otherCar") as? String
            if self.partiesdata.count > 0 {
                for dicr in self.partiesdata {
                    if let dict = dicr as? NSDictionary {
                        if dict.objectForKey("partiesmark") as! String == "1" {
                            self.partiesdata.removeObject(dicr)
                        }
                    }
                }
            }
            self.partiesdata.addObject((info?.object)!)
        }
        print(self.partiesdata)
        
        self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.None)
    }
    
    func removeFromAccidentView(view:AccidentView) {
        self.backView.removeFromSuperview()
    }
    func popView() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    private lazy var tableView:UITableView = {
       let view = UITableView(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Grouped)
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    private lazy var partiesdata : NSMutableArray = NSMutableArray()
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension AccidentViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return carTypeArr.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 180
        }
        return IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 40
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        }
        return 400
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        let label = UILabel()
        label.frame = CGRect(x: 15, y: 5, width: 100, height: 20)
        label.font = UIFont.systemFontOfSize(14)
        if section == 0 {
            label.text = "选择事故类型"
        }else {
            
            label.text = "选择事故车辆"
        }
        view.addSubview(label)
        return view
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        let cellHeight = IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 40
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCRW, height: 400))
        let backView = UIView(frame: CGRect(x: 0, y: 15, width: SCRW, height: CGFloat(Int(SCRH) - 255 - cellHeight * carTypeArr.count - 64)))
        let forensicsButton = UIButton(type: UIButtonType.System)
        forensicsButton.frame = CGRect(x: 60, y: (backView.frame.height - 40) * 0.5, width: SCRW - 120, height: CGFloat(cellHeight))
        forensicsButton.backgroundColor = MainColor
        forensicsButton.setTitle("拍照取证", forState: UIControlState.Normal)
        forensicsButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        forensicsButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        forensicsButton.layer.cornerRadius = 20
        forensicsButton.addTarget(self, action: "forensicsButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        backView.addSubview(forensicsButton)
        
        backView.backgroundColor = UIColor.whiteColor()
        view.addSubview(backView)
        return view
    }
    
    func forensicsButtonClick() {
//        let agreeVC = AgreementViewController(nibName:"AgreementViewController",bundle:nil)
//        agreeVC.protocolsrc = "http://59.41.39.55:9090/plugins/changhui/web/protocolservlet?taskid=i3qIJs9W2WCP5C3w"
//        
//        self.navigationController?.pushViewController(agreeVC, animated: true)
//        return
//            
        print("跳转到拍照页面")
        if self.carTypeArr.count == 1{
            if myCarNumber == nil {
//                if #available(iOS 8.0, *) {
                    let alertC = UIAlertController.creatAlertWithTitle(title: nil, message: "请选择事故车辆", cancelActionTitle: "确定")
                    self.presentViewController(alertC, animated: true, completion: nil)
//                } else {
//                    // Fallback on earlier versions
//                }
                
                return
            }
        }else if self.carTypeArr.count == 2 {
            
            if myCarNumber == nil || otherCarNumber == nil {
//                if #available(iOS 8.0, *) {
                    let alertC = UIAlertController.creatAlertWithTitle(title: nil, message: "请选择我方/对方事故车辆", cancelActionTitle: "确定")
                    self.presentViewController(alertC, animated: true, completion: nil)
//                } else {
//                    // Fallback on earlier versions
//                }
//                
                return
            }
        }
        let photoVC = PhotoEvidenceViewController(nibName: "PhotoEvidenceViewController", bundle: nil)
        photoVC.accidentType = typeAccident
        if typeAccident == "oneCar" {
            if self.partiesdata.count > 0 {
                for dicr in self.partiesdata {
                    if let dict = dicr as? NSDictionary {
                        if dict.objectForKey("partiesmark") as! String == "1" {
                            self.partiesdata.removeObject(dicr)
                        }
                    }
                }
            }
        }
        photoVC.partiesdataArr = partiesdata
        self.navigationController?.pushViewController(photoVC, animated: true)
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = NSBundle.mainBundle().loadNibNamed("AccidentTableViewCell", owner: nil, options: nil).last as! AccidentTableViewCell
            weak var wSelf = self
            cell.returnSelectedResult({ (bl) -> Void in
                if bl {//单车事故
                    self.typeAccident = "oneCar"
                    wSelf!.carTypeArr.removeLast()
                }else {
                    self.typeAccident = "twoCar"
                    wSelf!.carTypeArr.append("对方车辆")
                }
                wSelf!.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.None)
            })
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        let accidentCellId = "accidentCellId"
        
//        var cell = tableView.dequeueReusableCellWithIdentifier(accidentCellId)
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if cell == nil {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: accidentCellId)
        }
         cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell?.textLabel?.text = carTypeArr[indexPath.row]
        if myCarNumber != nil && indexPath.row == 0 {
            cell!.detailTextLabel?.text = myCarNumber!
        }else if indexPath.row == 1 && otherCarNumber != nil {
            cell!.detailTextLabel?.text = otherCarNumber!
        }
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if (cell?.textLabel?.text) == "我的车辆" {
            print(cell?.textLabel?.text)
            let myCarVC = MyCarViewController()
            myCarVC.isWhatControllerPushIn = "accidentVC"
            self.navigationController?.pushViewController(myCarVC, animated: true)
            return
        }else if cell?.textLabel?.text == "对方车辆" {
            self.navigationController?.pushViewController(UserInfoViewController(), animated: true)
            return
        }

    }
}
