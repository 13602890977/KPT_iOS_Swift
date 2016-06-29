//
//  MoveCarViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/22.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import MBProgressHUD

class MoveCarViewController: UIViewController {

    @IBOutlet weak var remindLabel: UILabel!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    ///
    var remindStr : String!
    ///用于接收保存任务id
    var taskId : String?
    ///当事人信息(拍照上传之后会返回，有任务id和当事人id)
    var responsibilitydata:NSDictionary!
    ///用于区分是单车拍照还是双车拍照
    var carType: String!
    ///用于接收车辆信息(拍照上传传入的)
    var partiesdataArr:NSMutableArray!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = MainColor
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.remindLabel.text = remindStr
        if carType == "twoCar" {//双车事故拍照
            self.topButton.setTitle("自助定责", forState: UIControlState.Normal)
            self.bottomButton.hidden = true
        }else {
           
        }
        
        self.title = "挪车提醒"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "展开"), style: UIBarButtonItemStyle.Plain, target: self, action: "disSelfView")
        self.navigationItem.leftBarButtonItem?.tintColor = MainColor
        // Do any additional setup after loading the view.
    }
    
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
    @IBAction func surveyOnlineBtnClick(sender: AnyObject) {
        if (sender as! UIButton).titleLabel?.text == "自助定责" {
            print("跳到定责界面")
            let sceneVC = SceneViewController(nibName:"SceneViewController",bundle: nil)
            sceneVC.partiesdataArr = self.partiesdataArr
            sceneVC.responsibilitydata = self.responsibilitydata
            
            self.navigationController?.pushViewController(sceneVC, animated: true)
        }else {
            print("跳到定损界面")
        }
    }
    @IBAction func InsuranceReportBtnClick(sender: AnyObject) {
        
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
    private lazy var hud : MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view.superview, animated: true)
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
