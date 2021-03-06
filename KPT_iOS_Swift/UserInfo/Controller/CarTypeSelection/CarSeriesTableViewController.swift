//
//  CarSeriesTableViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/1.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import MJExtension
import MBProgressHUD

enum carType: Int {
    ///车系
    case CarSeries = 0
    ///车年限
    case CarModel = 1
}
protocol CarModelDelegate :AnyObject {
    func popFromVCtoCarModelName(model:CarModelModel)
}
class CarSeriesTableViewController: UIViewController {

    var brandId:String! {
        didSet {
            reloadCarData()
        }
    }
    ///用于标记列表数据类型
    var carListType: carType!

    private var tableView :UITableView!
    var delegate : CarModelDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        carListType = carType.CarSeries
        //防止tableview不置顶(上面留白)
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: SCRW * 0.5, height: SCRH - 64), style: UITableViewStyle.Plain)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        view.addSubview(tableView)
        //防止cell下面显示分隔cell
        tableView.tableFooterView = UIView()
        
        
    }

    private func reloadCarData() {
        self.hud.labelText = "获取中..."
        self.hud.show(true)
        KptRequestClient.sharedInstance.GET("/plugins/changhui/port/getSeries?requestCode=001004&brandid=\(brandId)", parameters: nil, success: { (_, responseObject) -> Void in
            self.hud.hide(true)
            if responseObject.objectForKey("responseCode")?.integerValue == 1 {
                let dataArr = responseObject.objectForKey("responseData") as? NSArray
                self.seriesList = CarSeriesModel.mj_objectArrayWithKeyValuesArray(dataArr)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }else {
                print("请求不到数据")
            }
            }) { (_, error) -> Void in
                print(error)
                self.hud.hide(true)
        }
    }
    private lazy var seriesList:NSMutableArray = NSMutableArray()
    private lazy var hud : MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension CarSeriesTableViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.seriesList.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellNameIdentifier = "cellNameIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellNameIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellNameIdentifier)
        }
        if carListType == carType.CarSeries {
            let model = self.seriesList[indexPath.row] as! CarSeriesModel
            cell?.textLabel?.text = model.seriesname
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }else {
            let model = self.seriesList[indexPath.row] as! CarModelModel
            cell?.textLabel?.text = model.modelname
            cell?.accessoryType = UITableViewCellAccessoryType.None
        }
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if carListType == carType.CarSeries {
            return 50
        }else {
            return 60
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if carListType == carType.CarModel {
            let model = self.seriesList[indexPath.row] as! CarModelModel//如果网速慢，没加载出来，可能会导致崩溃
            if (self.delegate != nil) {
                self.delegate?.popFromVCtoCarModelName(model)
            }
            print("点击了车款列表 -- \(model.modelname)")
            return
        }
        let model = self.seriesList[indexPath.row] as! CarSeriesModel
        //根据车系的id 加载年款数据
        reloadCarModelDataWithSeriesid(model.seriesid)
    }
    
    private func reloadCarModelDataWithSeriesid(seriesid:String) {
        carListType = carType.CarModel
        self.hud.labelText = "获取中..."
        self.hud.show(true)
        KptRequestClient.sharedInstance.GET("/plugins/changhui/port/getModel?requestCode=001004&seriesid=\(seriesid)", parameters: nil, success: { (_, JSON) -> Void in
            self.hud.hide(true)
            if JSON.objectForKey("responseCode")?.integerValue == 1 {
                let dataArr = JSON.objectForKey("responseData") as? NSArray
                self.seriesList = CarModelModel.mj_objectArrayWithKeyValuesArray(dataArr)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }else {
                print("请求不到数据")
            }
            }) { (_, error) -> Void in
                self.hud.hide(true)
                print("请求车系年限数据 -- \(error)")
        }
    }
}
