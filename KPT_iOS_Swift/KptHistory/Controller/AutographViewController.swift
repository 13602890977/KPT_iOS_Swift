//
//  AutographViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/29.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import MBProgressHUD

class AutographViewController: UIViewController {

    @IBOutlet weak var mainScrollerView: UIScrollView!
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = MainColor
    }
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
        //给scrollview加个点击手势，用于收起键盘
        setTapWithScroll()
    }
    private func setTapWithScroll() {
        let tap = UITapGestureRecognizer(target: self, action: "resignFirst")
        self.mainScrollerView.addGestureRecognizer(tap)
    }
    func resignFirst() {
        self.photoNumberField.resignFirstResponder()
        self.verificationTextField.resignFirstResponder()
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
        
        //先判读电话号码无误
        let bl = photoNumberField.text?.isPhotoNumber()
        print("\(bl!) 正规电话号码")
        //调用后台验证码接口，获取验证码，比对用户输入的验证码
        let paramet: [String:AnyObject] = ["requestcode":"001003","mobile":self.photoNumberField.text!]
        KptRequestClient.sharedInstance.POST("/plugins/changhui/port/getVcode", parameters: paramet, success: { (task:NSURLSessionDataTask!, JSON) -> Void in
            let responsecode = JSON.objectForKey("responseCode") as? String
            if (responsecode! == "1") {
                
            }else {
//                if #available(iOS 8.0, *) {
                    let alertV = UIAlertController(title: "温馨提醒", message: JSON.objectForKey("errorMessage") as? String, preferredStyle: UIAlertControllerStyle.Alert)
                    let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
                    alertV.addAction(action)
                    self.presentViewController(alertV, animated: true, completion: nil)
//                } else {
//                    // Fallback on earlier versions
//                }
                
            }
            }) { (_, error) -> Void in
                
//                if #available(iOS 8.0, *) {
                    let alertV = UIAlertController(title: "温馨提醒", message: "链接不到服务器,请确定网络正常之后重试", preferredStyle: UIAlertControllerStyle.Alert)
                    let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
                    alertV.addAction(action)
                    self.presentViewController(alertV, animated: true, completion: nil)
//                } else {
//                    // Fallback on earlier versions
//                }
//                
        }
        
        //开始倒计时
        //1.设定计时时长
        var timeout:Int = 60//结束时间
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
                    weakSelf?.verificationBtn.setTitle("重新获取", forState: UIControlState.Normal)
                    weakSelf?.verificationBtn.userInteractionEnabled = true
                })
            }else {
                let seconds = timeout
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    weakSelf?.verificationBtn.setTitle("\(seconds) 秒", forState: UIControlState.Normal)
                    weakSelf?.verificationBtn.userInteractionEnabled = false
                })
            }
            timeout--
        }
        //6.启动计时器
        dispatch_resume(timer)
    }
    ///我的签名点击事件
    @IBAction func myAutographButtonClick(sender: AnyObject) {
        let signVC = SignatureViewController(nibName:"SignatureViewController",bundle: nil)
        signVC.returnSignResult { (image) -> Void in
            print(image)
            
           image.QiniuPhotoUpdateReturnImageUrlStr(image, success: { (urlStr) -> Void in
              print(urlStr)
                let arr = self.responsibilitydata.objectForKey("responsibilitydata") as! NSMutableArray
                let dataDict = NSMutableDictionary()
                for dict in arr {
                    if let _ = dict as? NSMutableDictionary {
                        if dict.objectForKey("partiesmark")!.integerValue == 0 {
                        dataDict.setValue(dict.objectForKey("partiesid")!, forKey: "partiesid")
                            
                            dataDict.setValue(urlStr, forKey: "signaturesrc")
//                        dataDict.setValue(dict.objectForKey("partiesmark")!, forKey: "partiesmark")
                        }
                       
                    }
                    
                }
                self.updateDataArr.addObject(dataDict)
           })
            
            self.myAutoGraphBtn.setTitle(nil, forState: UIControlState.Normal)
            self.myAutoGraphBtn.contentMode = UIViewContentMode.ScaleAspectFill
          
            self.myAutoGraphBtn.setBackgroundImage(image, forState: UIControlState.Normal)
        }
        self.navigationController?.pushViewController(signVC, animated: true)
    }
   
    ///对方签名点击事件
    @IBAction func otherAutographButtonClick(sender: AnyObject) {
        let signVC = SignatureViewController(nibName:"SignatureViewController",bundle: nil)
        signVC.returnSignResult { (image) -> Void in
            image.QiniuPhotoUpdateReturnImageUrlStr(image, success: { (urlStr) -> Void in
                print(urlStr)
                
                let arr = self.responsibilitydata.objectForKey("responsibilitydata") as! NSMutableArray
                let dataDict = NSMutableDictionary()
                for dict in arr {
                    if let _ = dict as? NSMutableDictionary {
                        if dict.objectForKey("partiesmark")!.integerValue == 1 {
                        dataDict.setValue(dict.objectForKey("partiesid")!, forKey: "partiesid")
                            dataDict.setValue(urlStr, forKey: "signaturesrc")
//                        dataDict.setValue(dict.objectForKey("partiesmark")!, forKey: "partiesmark")
                        }
                        
                    }
                        
                }
                self.updateDataArr.addObject(dataDict)
                
            })
            self.otherAutographBtn.setTitle(nil, forState: UIControlState.Normal)
            self.otherAutographBtn.setBackgroundImage(image, forState: UIControlState.Normal)
        }
        self.navigationController?.pushViewController(signVC, animated: true)
    }
    ///确定按钮点击事件
    @IBAction func determineButtonClick(sender: AnyObject) {
//        if #available(iOS 8.0, *) {
            let alertC = UIAlertController.creatAlertWithTitle(title: nil, message: nil, cancelActionTitle: "确定")
            if self.photoNumberField.text == nil {
                alertC.message = "电话号码不正确，请确认后重试"
                self.presentViewController(alertC, animated: true, completion: nil)
                
                return
            }else if self.verificationTextField.text == nil{
                alertC.message = "请输入验证码"
                self.presentViewController(alertC, animated: true, completion: nil)
                
                return
            }else if self.updateDataArr.count != 2 {
                alertC.message = "请双方签名确认"
                self.presentViewController(alertC, animated: true, completion: nil)
                return
            }
//        } else {
//            // Fallback on earlier versions
//        }
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        let personalData = userDefault.objectForKey("userInfoLoginData") as! NSDictionary
        let userInfoData = UserInfoData.mj_objectWithKeyValues(personalData)
        
        let data = ["taskid":self.responsibilitydata.objectForKey("taskid")!,"flowid":self.flowid,"mobile":self.photoNumberField.text!,"vcode":self.verificationTextField.text!,"responsibilitydata":self.updateDataArr]
        let parame = ["requestcode":"003004","accessid":userInfoData.accessid,"accesskey":userInfoData.accesskey,"userid":userInfoData.userid,"data":data]
        self.hud.labelText = "加载数据中"
        self.hud.show(true)
        print(parame)
        KptRequestClient.sharedInstance.Kpt_post("/plugins/changhui/port/task/protocoltask", paramet: parame, viewController: self, success: { (data) -> Void in
            print(data)
            let agreeVC = AgreementViewController(nibName:"AgreementViewController",bundle:nil)
            agreeVC.protocolsrc = data?.objectForKey("protocolsrc") as! String
            agreeVC.partiesdataArr = self.partiesdataArr
            agreeVC.responsibilitydata = self.responsibilitydata
            agreeVC.flowid = self.flowid
            self.navigationController?.pushViewController(agreeVC, animated: true)
            
            self.hud.hide(true)
            }) { (_) -> Void in
                self.hud.hide(true)
        }
        
    }
    
    ///点击左侧导航栏返回键
    func disSelfView() {
//        if #available(iOS 8.0, *) {
            let alertC = UIAlertController(title: nil, message: "是否退出此任务？\n\n", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "继续", style: UIAlertActionStyle.Default) { (action) -> Void in
                alertC.dismissViewControllerAnimated(true, completion: nil)
            }
            cancelAction.setValue(MainColor, forKey: "titleTextColor")
            alertC.addAction(cancelAction)
            
            let action = UIAlertAction(title: "退出", style: UIAlertActionStyle.Cancel) { (action) -> Void in
                self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            }
            action.setValue(UIColor.grayColor(), forKey: "titleTextColor")
            alertC.addAction(action)
            
            self.presentViewController(alertC, animated: true, completion: nil)

        
//         }else {
//            // Fallback on earlier versions
//        }
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
    ///用于保存接口需要上传的数据
    private lazy var updateDataArr:NSMutableArray = NSMutableArray()
    
    private lazy var hud : MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)

}

extension AutographViewController : UIScrollViewDelegate,UITextFieldDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.mainScrollerView.scrollRectToVisible(CGRect(x: 0, y:self.mainScrollerView.frame.size.height - self.verificationTextField.frame.origin.y, width: SCRW, height: SCRH), animated: true)
        
        return true
    }
}
