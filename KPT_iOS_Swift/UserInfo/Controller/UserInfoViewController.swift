//
//  UserInfoViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/26.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController,Kpt_NextBtnViewDelegate {
    
    private var imageView:Kpt_OCRImageView?
    var pickerView:Kpt_PickerView?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.scrollEnabled = false
        view.addSubview(tableView)
        // Do any additional setup after loading the view.
    }
    func nextBtnClick(nextBtn: Kpt_NextBtnView) {
        self.navigationController?.pushViewController(DrivingLicenceViewController(), animated: true)
    }
    private lazy var tableView:UITableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
    
    private lazy var cellArr = ["姓名","身份证号","住址","性别","出生日期"]
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UserInfoViewController : UITableViewDelegate,UITableViewDataSource {
    
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
        }
        if indexPath.row < 3 {
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        cell?.detailTextLabel?.text = "请输入\(cellArr[indexPath.row])"
        cell?.textLabel?.text = cellArr[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.textLabel?.text == "出生日期" {
            print("点击这里了")
            creatPicker(pickerType.DatePick)
            pickerView?.ensureButtonReturnDate({ (str) -> Void in
                cell?.detailTextLabel?.text = str
                
            })
            return
        }else if cell?.textLabel?.text == "性别" {
            creatPicker(pickerType.OtherType)
            pickerView?.ensureButtonReturnDate({ (str) -> Void in
                cell?.detailTextLabel?.text = str
            })
            return
        }
    }
    
    func creatPicker(type:pickerType) {
        pickerView = Kpt_PickerView.creatPickerWithFrame(CGRect(x: 0, y: SCRH - 220, width: SCRW, height: 220), type: type)
        if type == pickerType.OtherType {
            pickerView?.pickArr = ["男","女"]
        }
        let window = UIApplication.sharedApplication().keyWindow
        window?.addSubview(self.pickerView!)
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 210
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.RGBA(218, g: 218, b: 218)
        view.frame = CGRect(x: 0, y:0, width: SCRW, height: 200)
        imageView = Kpt_OCRImageView.creatTouchImage(CGRect(x: 0, y: 0, width: SCRW, height: 180),documentType:"身份证",controller:self)
        imageView?.backgroundColor = UIColor.whiteColor()
        view.addSubview(imageView!)
        let label = UILabel(frame: CGRect(x: 15, y: view.frame.size.height - 15, width: 100, height: 20))
        label.text = "身份证信息"
        view.addSubview(label)
        
        return view
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: SCRW, height: 100))
        backView.backgroundColor = UIColor.RGBA(218, g: 218, b: 218)
        let view = Kpt_NextBtnView(frame: CGRect(x: 0, y: 20, width: SCRW, height: 80))
        view.delegate = self
        view.backgroundColor = UIColor.whiteColor()
        backView.addSubview(view)
        return backView
    }
}