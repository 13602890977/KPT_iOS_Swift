//
//  AutographViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/29.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class AutographViewController: UIViewController {

    @IBOutlet weak var myCarnoLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var myResponsibilityLabel: UILabel!
    @IBOutlet weak var otherCarnoLabel: UILabel!
    @IBOutlet weak var otherResponsilityLabel: UILabel!
    @IBOutlet weak var photoNumberField: UITextField!
    @IBOutlet weak var otherProgressView: UIView!
    @IBOutlet weak var verificationBtn: UIButton!
    @IBOutlet weak var verificationTextField: UITextField!
    @IBOutlet weak var myAutoGraphBtn: UIButton!
    @IBOutlet weak var otherAutographBtn: UIButton!
    
    ///用于接收车辆信息(选择责任分担之后)
    var partiesdataArr : NSMutableArray!
    ///当事人信息(主要包含任务id和当事人id)
    var responsibilitydata:NSDictionary!
    ///流程id
    var flowid : String!
    ///我的责任占比
    var myPercentage : Float!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "签名确认"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "展开"), style: UIBarButtonItemStyle.Plain, target: self, action: "disSelfView")
        self.navigationItem.leftBarButtonItem?.tintColor = MainColor
        
        self.progressView.addSubview(self.progressBackView)
        self.otherProgressView.addSubview(self.otherProgressBackView)
        ///设置圆形比例
        responsibilitySharing()
        //设置车牌号码和对方手机号码
        setCarNoAndPhotoNumber()
    }

    private func responsibilitySharing() {
        self.progressBackView.percent = myPercentage
        self.otherProgressBackView.percent = 1 - myPercentage
        
        if self.progressBackView.percent > 0.5 && self.progressBackView.percent < 1{
            self.myResponsibilityLabel.text = "我方主责  我方承担\(self.progressBackView.percent*100)%责任"
            self.otherResponsilityLabel.text = "对方次责  对方承担\(100 - self.progressBackView.percent*100)%责任"
        }else if self.progressBackView.percent  == 1{
            self.myResponsibilityLabel.text = "我方全责  我方承担100%责任"
            self.otherResponsilityLabel.text = "对方无责  对方承担0%责任"
        }else if self.progressBackView.percent  == 0.5{
            self.myResponsibilityLabel.text = "我方共同责任  我方承担50%责任"
            self.otherResponsilityLabel.text = "对方共同责任  对方承担50%责任"
        }else if self.progressBackView.percent  < 0.5 && self.progressBackView.percent > 0{
            self.myResponsibilityLabel.text = "我方次责  我方承担\(self.progressBackView.percent*100)%责任"
            self.otherResponsilityLabel.text = "对方主责  对方承担\(100 - self.progressBackView.percent*100)%责任"
        }else if self.progressBackView.percent  == 0{
            self.myResponsibilityLabel.text = "我方无责  我方承担0%责任"
            self.otherResponsilityLabel.text = "对方全责  对方承担100%责任"
        }
    }

    private func setCarNoAndPhotoNumber() {
        for dict in partiesdataArr {
            if ((dict as? NSDictionary) != nil)  {
                if dict.objectForKey("partiesmark")?.integerValue == 0 {
                    self.myCarnoLabel.text = dict.objectForKey("partiescarno") as? String
                }else if dict.objectForKey("partiesmark")?.integerValue == 1{
                    self.otherCarnoLabel.text = dict.objectForKey("partiescarno") as? String
                    self.photoNumberField.text = dict.objectForKey("mobile") as? String
                }
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ///验证码按钮点击事件
    @IBAction func verificationButtonClick(sender: AnyObject) {
    }
    ///我的签名点击事件
    @IBAction func myAutographButtonClick(sender: AnyObject) {
    }
    ///对方签名点击事件
    @IBAction func otherAutographButtonClick(sender: AnyObject) {
    }
    ///确定按钮点击事件
    @IBAction func determineButtonClick(sender: AnyObject) {
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
    
    private lazy var progressBackView : Kpt_ProgressView = {
        
        let view = Kpt_ProgressView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        view.arcBackColor = UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 1)
        view.arcFinishColor = MainColor
        view.arcUnfinishColor = MainColor
        
        return view
    }()
    
    private lazy var otherProgressBackView : Kpt_ProgressView = {
        let view = Kpt_ProgressView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        view.arcBackColor = UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 1)
        view.arcFinishColor = MainColor
        view.arcUnfinishColor = MainColor
        
        return view
    }()
    

}
