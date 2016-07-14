//
//  KPTHistoryViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/19.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import MJRefresh
import MBProgressHUD

class KPTHistoryViewController: UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.mj_header.beginRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = self.tableView
        tableView.tableFooterView = UIView()
        //添加下拉刷新
        header.setRefreshingTarget(self, refreshingAction: "headerRefresh")
        self.tableView.mj_header = header
        
        view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
        
    }

    func headerRefresh() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        //全部填写完成之后上传车辆信息
        let personalData = userDefault.objectForKey("userInfoLoginData")
        
        if personalData != nil {
           let userInfo = UserInfoData.mj_objectWithKeyValues(personalData as! NSDictionary)
            
            self.hud.labelText = "加载数据中"
            self.hud.show(true)
            KptRequestClient.sharedInstance.Kpt_Get("/plugins/changhui/port/history/getTaskList?requestcode=004001&accessid=\(userInfo!.accessid)&accesskey=\(userInfo!.accesskey)&userid=\(userInfo!.userid)", paramet: nil, viewController: self, success: { (JSON) -> Void in
                print(JSON)
                self.historyDataArr.removeAllObjects()
                if JSON as? NSDictionary != nil {
                    let model = HistoryModel.mj_objectWithKeyValues(JSON)
                    self.historyDataArr.addObject(model)
                }else if JSON as? NSArray != nil {
                    self.historyDataArr = HistoryModel.mj_objectArrayWithKeyValuesArray(JSON)
                }else {
                    let label = UILabel(frame: CGRect(x: 0, y: 100, width: SCRW, height: 30))
                    label.text = "没有事故信息"
                    label.textAlignment = NSTextAlignment.Center
                    label.font = UIFont.systemFontOfSize(18)
                    label.textColor = UIColor.lightGrayColor()
                    self.tableView.tableFooterView!.addSubview(label)
                }
                self.tableView.reloadData()
                
                self.hud.hide(true)
                self.tableView.mj_header.endRefreshing()
                }) { (error) -> Void in
                    if error as? String == "没有" {
                        let label = UILabel(frame: CGRect(x: 0, y: 100, width: SCRW, height: 30))
                        label.text = "没有事故信息"
                        label.textAlignment = NSTextAlignment.Center
                        label.font = UIFont.systemFontOfSize(18)
                        label.textColor = UIColor.lightGrayColor()
                        self.tableView.tableFooterView!.addSubview(label)
                    }
                    self.hud.hide(true)
                    self.tableView.mj_header.endRefreshing()
            }

        }else {
            self.tableView.mj_header.endRefreshing()
        }
        
    }
    private lazy var tableView: UITableView = {
       let view = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    private lazy var historyDataArr:NSMutableArray = NSMutableArray()
    
    private lazy var header:MJRefreshNormalHeader = MJRefreshNormalHeader()
    
    private lazy var hud : MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension KPTHistoryViewController :UITableViewDelegate,UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyDataArr.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 147
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let historyCellIdentifier = "historyCellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(historyCellIdentifier) as? HistoryCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("HistoryCell", owner: nil, options: nil).last as? HistoryCell
        }
        let model = self.historyDataArr[indexPath.row] as! HistoryModel
        cell?.historyModel = model
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = self.historyDataArr[indexPath.row] as! HistoryModel
        
        var nav : UINavigationController!
        if NSUserDefaults.standardUserDefaults().objectForKey("userInfoLoginData") == nil {
            nav = UINavigationController(rootViewController: Kpt_LoginViewController(nibName: "Kpt_LoginViewController", bundle: nil))
        }else {
            let historyDetailVC = HistoryDetailsViewController()
            historyDetailVC.taskId = model.taskid
            historyDetailVC.addressLabelStr = model.accidentaddress
            historyDetailVC.accidentLabelText = model.accidenttypename
            historyDetailVC.carnoLabelText = model.partiescarno
            nav = UINavigationController(rootViewController: historyDetailVC)
        }
        let vc = UIApplication.sharedApplication().keyWindow?.rootViewController
        
        vc!.presentViewController(nav, animated: true, completion: nil)
    }
}
