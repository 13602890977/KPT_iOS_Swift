//
//  RepairTableViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/27.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class RepairTableViewController: UITableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "附近维修厂"
        reloadRepairData()
    }

    let parame = ["pageSize":"10","pageNo":"0","lat":NSUserDefaults.standardUserDefaults().objectForKey("Kpt_latitude")!,"lon":NSUserDefaults.standardUserDefaults().objectForKey("Kpt_longitude")!]
    
    private func reloadRepairData() {
        KptRequestClient.sharedInstance.POST("/plugins/changhui/port/getRepairShops/reparList", parameters: parame, success: { (_, JSON) -> Void in
            print(JSON)
            
            let responsecode = JSON.objectForKey("status")
            if (responsecode!.integerValue == 0) {
                self.dataArr = RepairModel.mj_objectArrayWithKeyValuesArray(((JSON as! NSDictionary).objectForKey("results") as! NSArray))
                self.tableView.reloadData()
                
            }else {
               
                let alertV = UIAlertController.creatAlertWithTitle(title: "温馨提醒", message:  JSON.objectForKey("message") as? String, cancelActionTitle: "确定")
                self.presentViewController(alertV, animated: true, completion: nil)
                }
            }) { (_, error) -> Void in
                print(error)
                let alertV = UIAlertController.creatAlertWithTitle(title: "温馨提醒", message:"链接不到服务器，请退出重试", cancelActionTitle: "确定")
                self.presentViewController(alertV, animated: true, completion: nil)
        }
    }
    private lazy var dataArr : NSMutableArray = NSMutableArray()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArr.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let repairCellReuseIdentifier = "repairCellReuseIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(repairCellReuseIdentifier) as? RepairCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("RepairCell", owner: nil, options: nil).last as? RepairCell
        }
        cell?.repairModel = self.dataArr[indexPath.row] as! RepairModel
        return cell!
    }
    

}
