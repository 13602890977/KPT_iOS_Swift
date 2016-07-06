//
//  DamageResultsViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/25.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import MBProgressHUD

class DamageResultsViewController: UIViewController,Kpt_NextBtnViewDelegate {

    ///接收任务id
    var taskId : String!
    ///接收模型数据
    var damageDataArr : NSArray!
    ///区分单车双车事故外的定损界面进入的
    var isWhatControllerPushIn : String?
    ///用于标记是否点击第一组收起
    private var isExpand : Bool = false
    ///用于标记第二组数据是否需要收起
    private var seclectedSection : Bool = false
    ///用于保存后台返回的建议
    private var proposalStr : String?
    private var strSize : CGSize?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "定损结果"
        
        self.view.addSubview(self.tableView)
        if isWhatControllerPushIn == nil {
            //计算建议文字高度，如果有才显示，没有就不显示
            CalculateHeightOfText()
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "展开"), style: UIBarButtonItemStyle.Plain, target: self, action: "disSelfView")
            self.navigationItem.leftBarButtonItem?.tintColor = MainColor
        }
        // Do any additional setup after loading the view.
    }
    
    private func CalculateHeightOfText() {
        let dict = damageDataArr.firstObject as! DamageModel
        if dict.advice != nil {
            let advice = dict.advice
            proposalStr = advice
            let attrs = NSDictionary(object: UIFont.systemFontOfSize(16), forKey: NSFontAttributeName)
            //                let attrs = [NSFontAttributeName:14]//这样写是错误的
            let maxSize = CGSizeMake(SCRW, CGFloat(MAXFLOAT))
            let option = NSStringDrawingOptions.UsesLineFragmentOrigin
            let str : NSString = advice!
            
            strSize = str.boundingRectWithSize(maxSize, options: option, attributes: attrs as? [String : AnyObject], context: nil).size
        }
    }
    ///点击左侧导航栏返回键
    func disSelfView() {
        let alertC = UIAlertController(title: nil, message: "是否退出此任务？\n\n", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "继续", style: UIAlertActionStyle.Default) { (action) -> Void in
            alertC.dismissViewControllerAnimated(true, completion: nil)
        }
        cancelAction .setValue(MainColor, forKey: "titleTextColor")
        alertC.addAction(cancelAction)
        
        let action = UIAlertAction(title: "退出", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }
        action.setValue(UIColor.grayColor(), forKey: "titleTextColor")
        alertC.addAction(action)
        
        self.presentViewController(alertC, animated: true, completion: nil)
    }
    
    func nextBtnClick(nextBtn: Kpt_NextBtnView) {
        self.navigationController?.pushViewController(RepairTableViewController(), animated: true)
    }

    private lazy var tableView : UITableView = {
        let view = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    private lazy var hud : MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view.superview, animated: true)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
extension DamageResultsViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.damageDataArr.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isExpand && section == 0{
            return 0
        }else if seclectedSection && section == 1 {
            return 0
        }
        return (self.damageDataArr[section] as! DamageModel).parts.count + 2
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let damageCellIdentifier = "damageCellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(damageCellIdentifier) as? DamageResultCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("DamageResultCell", owner: nil, options: nil).last as? DamageResultCell
        }
        if indexPath.row == 0 {
            
        }else if indexPath.row == (self.damageDataArr[indexPath.section] as! DamageModel).parts.count + 1 {
            cell?.totalLabel.hidden = false
            cell?.positionLabel.hidden = true
            cell?.degreeLabel.hidden = true
            cell?.costLabel.hidden = true
            cell?.totalLabel?.text = "参考费用：\((self.damageDataArr[indexPath.section] as! DamageModel).repairsumprice)元"
            
        }else {
            cell?.positionDict = (self.damageDataArr[indexPath.section] as! DamageModel).parts[indexPath.row - 1] as! NSMutableDictionary
        }
        return cell!
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel(frame: CGRect(x: 15, y: 10, width: 100, height: 20))
        label.text = (self.damageDataArr[section] as! DamageModel).partiescarno
        view.addSubview(label)
        
        let button = UIButton(type: UIButtonType.Custom)
        
        button.frame = CGRect(x: SCRW - 15 - 40, y: 0, width: 40, height: 40)
        button.contentMode = UIViewContentMode.ScaleAspectFit
        
        if isExpand && section == 0{
             button.setImage(UIImage(named: "round_y"), forState: UIControlState.Normal)
        }else if seclectedSection && section == 1 {
             button.setImage(UIImage(named: "round_y"), forState: UIControlState.Normal)
        }else {
            button.setImage(UIImage(named: "round_w"), forState: UIControlState.Normal)
        }
        button.tag = 100 + section
        button.addTarget(self, action: "imageButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let lineImage = UIImageView(frame: CGRect(x: 0, y: 40 - 1, width: SCRW, height: 1))
        lineImage.backgroundColor = UIColor.lightGrayColor()
        view.addSubview(lineImage)
        
        view.addSubview(button)
        return view
    }
    func imageButtonClick(sender:UIButton) {
        if sender.tag == 100 {
            isExpand = !isExpand
        }else if sender.tag == 101{
            seclectedSection = !seclectedSection
        }
        self.tableView.reloadSections(NSIndexSet(index: sender.tag - 100), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == damageDataArr.count - 1 {
            if strSize?.height > 10 {
                return (IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 40) + 60 + (strSize?.height)! + 40
            }
            return (IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 40) + 60
        }
        return 0.00001
        
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == damageDataArr.count - 1 {//判断是最后一组
            let cellMainHeight:CGFloat = IS_IPHONE_6P() ? 60 : IS_IPHONE_6() ? 50 : 40
            let backView = UIView(frame: CGRect(x: 0, y: 0, width: SCRW, height: cellMainHeight + 60))
            backView.backgroundColor = UIColor.RGBA(218, g: 218, b: 218)
            if isWhatControllerPushIn == nil {
                let view = UIView()
                
                if strSize?.height > 10 {
                    let label = UILabel()
                    label.frame = CGRect(x: 10, y: 10, width: 200, height: 20)
                    label.font = UIFont.systemFontOfSize(18)
                    label.backgroundColor = UIColor.clearColor()
                    label.text = "快赔通建议"
                    label.textColor = UIColor.blackColor()
                    backView.addSubview(label)
                    
                    let proposalLabel = UILabel(frame: CGRect(x: 0, y: label.frame.origin.y + label.frame.height + 10, width: SCRW, height: (strSize?.height)!))
                    proposalLabel.font = UIFont.systemFontOfSize(16)
                    proposalLabel.numberOfLines = 0
                    proposalLabel.backgroundColor = UIColor.whiteColor()
                    proposalLabel.text = proposalStr
                    proposalLabel.textColor = UIColor.grayColor()
                    backView.addSubview(proposalLabel)
                    
                    view.frame = CGRect(x: 0, y: 40 + (strSize?.height)! + 10, width: SCRW, height: cellMainHeight + 60)
                }else {
                    view.frame = CGRect(x: 0, y: 20, width: SCRW, height: cellMainHeight + 40)
                }
                
                view.backgroundColor = UIColor.whiteColor()
                
                let repairButton = UIButton(type: UIButtonType.Custom)
                repairButton.frame = CGRect(x: 20, y: (view.frame.height - cellMainHeight) * 0.5, width: SCRW * 0.5 - 70, height: cellMainHeight)
                repairButton.setBackgroundImage(UIImage(named: "不完善"), forState: UIControlState.Normal)
                repairButton.setTitle("自行维修", forState: UIControlState.Normal)
                repairButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                repairButton.titleLabel?.font = UIFont.systemFontOfSize(25)
                repairButton.addTarget(self, action: "repairBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
                view.addSubview(repairButton)
                
                let reportButton = UIButton(type: UIButtonType.Custom)
                reportButton.frame = CGRect(x: SCRW - 20 - (SCRW * 0.5 - 70), y: (view.frame.height - cellMainHeight) * 0.5, width: SCRW * 0.5 - 70, height: cellMainHeight)
                reportButton.setBackgroundImage(UIImage(named: "完善"), forState: UIControlState.Normal)
                reportButton.setTitle("保险报案", forState: UIControlState.Normal)
                reportButton.titleLabel?.font = UIFont.systemFontOfSize(25)
                reportButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                reportButton.addTarget(self, action: "reportBtnClick", forControlEvents: UIControlEvents.TouchUpInside)
                view.addSubview(reportButton)
                
                backView.addSubview(view)
            }else {
                let view = Kpt_NextBtnView(frame: CGRect(x: 0, y: 20, width: SCRW, height: cellMainHeight + 40))
                view.delegate = self
                view.btnText = "自行维修"
                
                view.backgroundColor = UIColor.whiteColor()
                backView.addSubview(view)
               
            }
             return backView
        }else {
            return nil
        }
        

    }
    ///自行维修
    func repairBtnClick() {
        self.navigationController?.pushViewController(RepairTableViewController(), animated: true)
    }
    ///保险报案
    func reportBtnClick() {
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        let personalData = userDefault.objectForKey("userInfoLoginData") as! NSDictionary
        let userInfoData = UserInfoData.mj_objectWithKeyValues(personalData)
        
        let paramet = ["requestcode":"003006","accessid":userInfoData.accessid,"accesskey":userInfoData.accesskey,"userid":userInfoData.userid,"taskid":taskId]
        
        self.hud.labelText = "报案中..."
        self.hud.show(true)
        
        KptRequestClient.sharedInstance.Kpt_post("/plugins/changhui/port/task/taskReport", paramet: paramet, viewController: self, success: { (data) -> Void in
            print(data)
            self.hud.hide(true)
            self.navigationController?.pushViewController(ReportSuccessViewController(nibName:"ReportSuccessViewController",bundle: nil), animated: true)
            }) { (_) -> Void in
                self.hud.hide(true)
        }

    }
}
