//
//  UserInfoViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/26.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {

    @IBOutlet weak var backScrollView: UIScrollView!
    @IBOutlet weak var idCardImage: UIImageView!
    @IBOutlet weak var idTableView: UITableView!
    
    var pickerView:Kpt_PickerView?
    
    let cellArr = ["姓名","身份证号","住址","性别","出生日期"]
    override func viewDidLoad() {
        super.viewDidLoad()
        idTableView.delegate = self
        idTableView.dataSource = self
        idTableView.backgroundColor = UIColor.clearColor()
        //不让tableview滚动
        idTableView.scrollEnabled = false
    }

    @IBAction func nextBtnClick(sender: AnyObject) {
        self.navigationController?.pushViewController(DrivingLicenceViewController(), animated: true)
    }
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
        pickerView = Kpt_PickerView.creatPickerWithFrame(CGRect(x: 0, y: SCRH - 200, width: SCRW, height: 200), type: type)
        if type == pickerType.OtherType {
            pickerView?.pickArr = ["男","女"]
        }
        let window = UIApplication.sharedApplication().keyWindow
        window?.addSubview(self.pickerView!)
    }
}