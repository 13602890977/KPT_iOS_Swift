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
    func popFromVCtoCarModelName(name:String)
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
        KptRequestClient.sharedInstance.GET("/plugins/changhui/port/getSeries?requestCode=001004&brandid=\(brandId)", parameters: nil, success: { (_, responseObject) -> Void in
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
        }
    }
    private lazy var seriesList:NSMutableArray = NSMutableArray()
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
            let model = self.seriesList[indexPath.row] as! CarModelModel
            if (self.delegate != nil) {
                self.delegate?.popFromVCtoCarModelName(model.modelname)
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
        
        KptRequestClient.sharedInstance.GET("/plugins/changhui/port/getModel?requestCode=001004&seriesid=\(seriesid)", parameters: nil, success: { (_, JSON) -> Void in
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
                print("请求车系年限数据 -- \(error)")
        }
    }
}
