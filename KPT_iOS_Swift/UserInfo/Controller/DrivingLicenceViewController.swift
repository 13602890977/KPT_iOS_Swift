//
//  DrivingLicenceViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/27.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class DrivingLicenceViewController: UIViewController,Kpt_NextBtnViewDelegate {

    var imageView:Kpt_OCRImageView?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        // Do any additional setup after loading the view.
    }
    func nextBtnClick(nextBtn: Kpt_NextBtnView) {
        self.navigationController?.pushViewController(Kpt_LoginViewController(), animated: true)
    }
    private lazy var tableView:UITableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension DrivingLicenceViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let DrivingCell = "DrivingCellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(DrivingCell)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: DrivingCell)
        }
        cell?.textLabel?.text = "ahaha"
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
        view.backgroundColor = UIColor.lightGrayColor()
        if section == 0 {
            view.frame = CGRect(x: 0, y:0, width: SCRW, height: 200)
            imageView = Kpt_OCRImageView.creatTouchImage(CGRect(x: 0, y: 0, width: SCRW, height: 180),documentType:"驾驶证")
            imageView?.backgroundColor = UIColor.whiteColor()
            view.addSubview(imageView!)
            let label = UILabel(frame: CGRect(x: 15, y: view.frame.size.height - 15, width: 100, height: 20))
            label.text = "驾驶证信息"
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
        backView.backgroundColor = UIColor.lightGrayColor()
        let view = Kpt_NextBtnView(frame: CGRect(x: 0, y: 20, width: SCRW, height: 80))
        view.delegate = self
        view.backgroundColor = UIColor.whiteColor()
        backView.addSubview(view)
        return backView
    }
}
