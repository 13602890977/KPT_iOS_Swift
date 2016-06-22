//
//  HistoryDetailsViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/17.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import MBProgressHUD

class HistoryDetailsViewController: UIViewController {

    ///接收保存传入的任务id，用于请求数据的标示
    var taskId : String!
    ///模型
    private var detailModel : HistoryDetailModel?
    ///事故车辆
    var carnoLabelText:String!
    ///事故类型
    var accidentLabelText:String!
    ///事故地址
    var addressLabelStr:String!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let navigationBar = self.navigationController!.navigationBar
        navigationBar.barTintColor = UIColor.blackColor()
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "历史详情"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFontOfSize(19.0),NSForegroundColorAttributeName:MainColor]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "展开"), style: UIBarButtonItemStyle.Plain, target: self, action: "cancelBtnClick")
        self.navigationItem.leftBarButtonItem?.tintColor = MainColor
        
        self.view = self.tableView
        ///不显示cell的分隔线
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        reloadHistoryDetailData()
        // Do any additional setup after loading the view.
    }
    private func reloadHistoryDetailData() {
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        //全部填写完成之后上传车辆信息
        let personalData = userDefault.objectForKey("userInfoLoginData") as! NSDictionary
        let userInfoData = UserInfoData.mj_objectWithKeyValues(personalData)
        self.hud.labelText = "加载数据中"
        self.hud.show(true)
        
        KptRequestClient.sharedInstance.Kpt_Get("/plugins/changhui/port/history/getTaskDetail?requestcode=004002&accessid=\(userInfoData.accessid)&accesskey=\(userInfoData.accesskey)&userid=\(userInfoData.userid)&taskid=\(taskId)", paramet: nil, viewController: self, success: { (data) -> Void in
            
            if let dict = data as? NSDictionary {
                
                //责任分担(在线定责)
                let dutyData = dict.objectForKey("dutydata")
                if let dict = dutyData as? NSDictionary {
                    let data = dutydataModel.mj_objectWithKeyValues(dict)
                    self.modelDict.setValue(data, forKey: "dutydata")
                }
                //维修费用(在线定损)
                let lossdata = dict.objectForKey("lossdata")
                if let dict = lossdata as? NSDictionary {
                    let data = lossdataModel.mj_objectWithKeyValues(dict)
                    self.modelDict.setValue(data, forKey: "lossdata")
                }
                //事故车辆详情(没有用到)
                let partiesdata = dict.objectForKey("partiesdata")
                let dataArr = NSMutableArray()
                if let arr = partiesdata as? NSArray {
                    for dict in arr {
                        if let data = dict as? NSDictionary {
                            let model = partiesdataModel.mj_objectWithKeyValues(data)
                            dataArr.addObject(model)
                        }
                    }
//                    self.modelDict.setValue(dataArr, forKey: "partiesdata")
                }
                //事故拍照取证(拍照取证)
                let photodata = dict.objectForKey("photodata")
                if let dict = photodata as? NSDictionary {
                    let data = photodataModel.mj_objectWithKeyValues(dict)
                    self.modelDict.setValue(data, forKey: "photodata")
                }
                
                let reportdata = dict.objectForKey("reportdata")
                if let dict = reportdata as? NSDictionary {
                    let data = reportdataModel.mj_objectWithKeyValues(dict)
                    
                    self.modelDict.setValue(data, forKey: "reportdata")
                }
            }
            ///要按顺序添加进去
            for key in self.modelDict.allKeys {
                if key as? String == "reportdata" {
                    self.modelArr[0] = self.modelDict.objectForKey(key)!
                }
                if key as? String == "lossdata" {
                    self.modelArr[1] = self.modelDict.objectForKey(key)!
                }
                if key as? String == "dutydata" {
                    self.modelArr[2] = self.modelDict.objectForKey(key)!
                }
                if key as? String == "photodata" {
                    self.modelArr[3] = self.modelDict.objectForKey(key)!
                }
            }
            
            for object in self.modelArr {
                if object as? String == "false" {
                    self.modelArr.removeObject(object)
                }
            }
            print(self.modelArr)
            self.tableView.reloadData()
            self.hud.hide(true)
            }) { (_) -> Void in
                self.hud.hide(true)
        }
    }
    func cancelBtnClick() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    private lazy var tableView :UITableView = {
        let tableview = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        tableview.delegate = self
        tableview.dataSource = self
        return tableview
    }()
    
    ///数据数组
    private lazy var modelArr:NSMutableArray = ["false","false","false","false"]
    private lazy var modelDict:NSMutableDictionary = NSMutableDictionary()
     private lazy var hud : MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension HistoryDetailsViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 110
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 110))
        view.backgroundColor = UIColor.whiteColor()
        ///车牌号码
        let carnoLabel = UILabel(frame: CGRect(x: 15, y: 10, width:UIScreen.mainScreen().bounds.width, height: 20))
        carnoLabel.text = "车牌号：\(carnoLabelText)"
        view.addSubview(carnoLabel)
        ///事故类型Label
        let accidentLabel = UILabel(frame: CGRect(x: 15, y: carnoLabel.frame.origin.y + carnoLabel.frame.height + 10, width:UIScreen.mainScreen().bounds.width, height: 20))
        accidentLabel.text = "事故类型：\(accidentLabelText)"
        accidentLabel.font = UIFont.systemFontOfSize(15)
        view.addSubview(accidentLabel)
        ///事故地址Label
        let addressLabelText = UILabel(frame: CGRect(x: 15, y:  accidentLabel.frame.origin.y + accidentLabel.frame.height + 10, width:UIScreen.mainScreen().bounds.width, height: 20))
        addressLabelText.text = "事故地址："
        addressLabelText.font = UIFont.systemFontOfSize(15)
        view.addSubview(addressLabelText)
        
        let addressLabel = UILabel(frame: CGRect(x: 90, y:  accidentLabel.frame.origin.y + accidentLabel.frame.height + 5, width:UIScreen.mainScreen().bounds.width - 95, height: 40))
        addressLabel.font = UIFont.systemFontOfSize(15)
        addressLabel.numberOfLines = 0
        addressLabel.text = addressLabelStr
        view.addSubview(addressLabel)
        ///底部划线
        let image = UIImageView(frame: CGRect(x: 0, y: view.frame.height - 1, width: UIScreen.mainScreen().bounds.width, height: 1))
        image
            .backgroundColor = UIColor.lightGrayColor()
        view.addSubview(image)
        
        return view
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.modelArr[0].isKindOfClass(reportdataModel.classForCoder()) && indexPath.row == 0 {
            return 75
        }
        return 115
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.modelDict.allKeys)
        return self.modelDict.allKeys.count > 0 ? self.modelDict.allKeys.count : 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "cellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? HistoryDetailsCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("HistoryDetailsCell", owner: nil, options: nil).last as? HistoryDetailsCell
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
        }
        cell?.data = self.modelArr[indexPath.row]
        cell?.indexPathRow = indexPath.row
        return cell!
    }
}