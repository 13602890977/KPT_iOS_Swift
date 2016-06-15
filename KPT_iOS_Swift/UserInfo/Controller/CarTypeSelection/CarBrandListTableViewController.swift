//
//  CarBrandListTableViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/31.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import MJExtension
import MBProgressHUD

typealias cellTextBlock = (model:CarModelModel) -> Void

class CarBrandListTableViewController: UITableViewController ,CarModelDelegate{

    private var carSeriesVC:CarSeriesTableViewController!
    
    var carBrandText : cellTextBlock?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
       self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "backPop")
        
        reloadCarBrandData()
    }

    func backPop() {
        backGaryImage.removeFromSuperview()
        self.navigationController?.popViewControllerAnimated(true)
    }
    private func reloadCarBrandData() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        KptRequestClient.sharedInstance.GET("plugins/changhui/port/getBrand?requestCode=001004", parameters: nil, success: { (_, JSON) -> Void in
            if (JSON.objectForKey("responseCode"))! as! NSObject == 1 {
                let responseObject = JSON.objectForKey("responseData") as? NSArray
                self.carBrandList = CarBrandModel.mj_objectArrayWithKeyValuesArray(responseObject)
                self.tableView.reloadData()

            }
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }) { (_, error) -> Void in
                print(error)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
        }
    }
    
    func popFromVCtoCarModelName(model: CarModelModel) {
        
        removeChildController()
        if self.carBrandText != nil {
            self.carBrandText!(model: model)
        }
        self.navigationController?.popViewControllerAnimated(true)
        print("车系年限返回的数据 -- \(model)")
    }
    //闭包返回方法
    func returnMoldeNameText(myBlock:cellTextBlock?) {
        self.carBrandText = myBlock
    }
    private lazy var carBrandList:NSMutableArray = NSMutableArray()
    ///组头 -- 26个字母数组
    private lazy var toBeReturnArr:[String] = {
        var _toBeReturned = [String]();
        for c in NSObject.creatTwenty_sixArr() {
            _toBeReturned.append("\(c)")
        }
        return _toBeReturned
    }()
    ///蒙层
    private lazy var backGaryImage:UIImageView = {
       let viewImage = UIImageView(frame: self.view.frame)
        viewImage.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        viewImage.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: "removeChildController")
        viewImage.addGestureRecognizer(tap)
        return viewImage
    }()
    ///删除子VC
    func removeChildController() {
        //移除子VC的view一定要调用此方法
        carSeriesVC.willMoveToParentViewController(nil);
        //移除子VC的view
        carSeriesVC.view.removeFromSuperview()
        //移除子VC
        carSeriesVC.removeFromParentViewController()
        //移除蒙层
        backGaryImage.removeFromSuperview()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension CarBrandListTableViewController {
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return toBeReturnArr
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 40
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return toBeReturnArr[section]
    }
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return toBeReturnArr.count
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var arr = [CarBrandModel]()
        for model in carBrandList {
            if (model as! CarBrandModel).brandinitial == toBeReturnArr[section] {
                arr.append(model as! CarBrandModel)
            }
        }
        return arr.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = CarBrandTableViewCell.creatBrandCellWithTableView(tableView)
        
        var arr = [CarBrandModel]()
        for model in carBrandList {
            if (model as! CarBrandModel).brandinitial == toBeReturnArr[indexPath.section] {
                arr.append(model as! CarBrandModel)
            }
        }
        let carbrandModel = arr[indexPath.row]
        cell.model = carbrandModel
        
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        carSeriesVC = CarSeriesTableViewController()
        carSeriesVC.delegate = self
        var arr = [CarBrandModel]()
        for model in carBrandList {
            if (model as! CarBrandModel).brandinitial == toBeReturnArr[indexPath.section] {
                arr.append(model as! CarBrandModel)
            }
        }
        let carModel = arr[indexPath.row]
        carSeriesVC.brandId = carModel.brandid
        
        carSeriesVC.view.frame = CGRect(x: SCRW, y: 64, width: SCRW*0.5, height: SCRH - 64)
        //添加子VC
        self.parentViewController?.addChildViewController(carSeriesVC)
        carSeriesVC.didMoveToParentViewController(self.parentViewController)
        self.parentViewController?.view.addSubview(carSeriesVC.view)
        //添加蒙层
        weak var weakSelf = self
        self.view.superview?.addSubview(self.backGaryImage)
        UIView.animateWithDuration(0.5) { () -> Void in
            weakSelf!.carSeriesVC.view.frame = CGRect(x: SCRW * 0.5, y: 64, width: SCRW * 0.5, height: SCRH)
        }
        
    }
    
}