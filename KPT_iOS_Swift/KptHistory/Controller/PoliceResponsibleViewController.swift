//
//  PoliceResponsibleViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/7/6.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class PoliceResponsibleViewController: UIViewController {

    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var refreshBtn: UIButton!
    
    ///事故信息详情
    var partiesdataArr : NSMutableArray!
    ///当事人信息(主要包含任务id和当事人id)
    var responsibilitydataDict:NSMutableDictionary!
    
    ///任务id
    var taskId : String!
    ///流程id
    var flowid : String!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "交警定责"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "展开"), style: UIBarButtonItemStyle.Plain, target: self, action:"dismissView")
        
        self.navigationItem.leftBarButtonItem?.tintColor = MainColor
        // Do any additional setup after loading the view.
    }
    ///点击左侧导航栏返回键
    func dismissView() {
//        if #available(iOS 8.0, *) {
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
//        } else {
//            // Fallback on earlier versions
//        }
//        
        
        
    }
    @IBAction func cancelBtnClick(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }

    //刷新按钮
    @IBAction func refreshBtnClick(sender: AnyObject) {
        let userDefault = NSUserDefaults.standardUserDefaults()
        let personalData = userDefault.objectForKey("userInfoLoginData") as! NSDictionary
        let userInfoData = UserInfoData.mj_objectWithKeyValues(personalData)
        
        
        let parame = ["requestcode":"003003","accessid":userInfoData.accessid,"accesskey":userInfoData.accesskey,"userid":userInfoData.userid,"taskid":taskId,"flowid":flowid]
        
        KptRequestClient.sharedInstance.Kpt_post("/plugins/changhui/port/task/trffPolicedutytask", paramet: parame, viewController: self, success: { (data) -> Void in
            print(data)
            if let arr = data as? NSArray {
                let responsibleVC = ResponsibleResultsViewController(nibName:"ResponsibleResultsViewController",bundle: nil)
                var dutyNameStr = ""
                for dict in arr {
                    if dict.objectForKey("partiesmark")?.integerValue == 0 {
                        dutyNameStr = dict.objectForKey("dutyname") as! String
                    }
                }
                responsibleVC.responsibilityStr = dutyNameStr
                responsibleVC.partiesdataArr = self.partiesdataArr
                responsibleVC.responsibilitydata = self.responsibilitydataDict
                responsibleVC.policeTypeB = true
                
                self.navigationController?.pushViewController(responsibleVC, animated: true)
            }
            
            }, failure: { (_) -> Void in
                
        })
        //开始倒计时
        //1.设定计时时长
        var timeout:Int = 9//结束时间
        //2.开启子线程
        let queue:dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        //3.创建计时器
        let timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        //4.设置计时器时长(1秒 1 * NSEC_PER_SEC）
        dispatch_source_set_timer(timer, dispatch_walltime(nil, 0), 1 * NSEC_PER_SEC, 0)
        weak var weakSelf = self//解决闭包循环引用 方法一
        //5.设置计时器的执行方法的内容
        dispatch_source_set_event_handler(timer) {/*[weak self]解决闭包循环引用 方法二*/ () -> Void in
            if timeout == 0 {
                dispatch_source_cancel(timer)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    weakSelf?.reminderLabel.text = "暂无结果返回"
                    weakSelf?.refreshBtn.userInteractionEnabled = true
                })
            }else {
                let seconds = timeout
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    weakSelf?.reminderLabel.text = "\(seconds)秒"
                    weakSelf?.refreshBtn.userInteractionEnabled = false
                })
            }
            timeout--
        }
        //6.启动计时器
        dispatch_resume(timer)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
