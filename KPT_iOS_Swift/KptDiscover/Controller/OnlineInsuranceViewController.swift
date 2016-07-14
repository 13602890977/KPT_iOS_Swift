//
//  OnlineInsuranceViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/22.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import MBProgressHUD
import AFNetworking

class OnlineInsuranceViewController: UIViewController {
    ///显示是我方车牌号码还是对方车牌号码
    @IBOutlet weak var ascriptionLabel: UILabel!
    ///车牌号码
    @IBOutlet weak var carnoLabel: UILabel!
    ///接收车牌号码
    var carnoStr : String!
    ///车型
    @IBOutlet weak var carModelLabel: UILabel!
    ///接收车型
    var carmodelStr : String!
    ///接收是定损界面传入的
    var isWhatControllerPushIn : String?
    ///受损部位label
    @IBOutlet weak var partLabel: UILabel!
    ///显示车受损位置图片
    @IBOutlet weak var MainScrolleView: UIScrollView!
    ///显示图片个数
    @IBOutlet weak var pageView: UIPageControl!
    ///用于区分单车定损还是双车定损(oneCar/twoCar)
    var carType:String!
    ///点击进入下一步(需要区分双车和单车,双车显示下一步，进入对方车辆受损界面，单车直接提交数据)
    @IBOutlet weak var nextButton: UIButton!
    
    ///接收双车的车牌信息等
    var carDataArr : NSMutableArray!
    ///当事人信息(主要包含任务id和当事人id)
    var responsibilitydata:NSDictionary!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.leftBarButtonItem?.tintColor = MainColor
        self.navigationController?.navigationBar.tintColor = MainColor
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "在线定损"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFontOfSize(19.0),NSForegroundColorAttributeName:MainColor]
        
        setMainView()
        
            
        // Do any additional setup after loading the view.
    }
    private func setMainView() {
        self.partLabel.text = "左前"
        self.MainScrolleView.delegate = self
        if carType == "twoCar" && self.partDataArr.count < 1 {//判断是不是第一个我的车辆界面
            for dict in carDataArr {
                if ((dict as? NSDictionary) != nil)  {
                    if dict.objectForKey("partiesmark")?.integerValue == 0 {
                        self.carnoLabel.text = dict.objectForKey("partiescarno") as? String
                        self.carModelLabel.text = dict.objectForKey("vehiclename") as? String
                    }
                }
            }
//            self.carnoLabel.text = 
            self.nextButton.setTitle("下一步", forState: UIControlState.Normal)
        }else if carType == "twoCar" && self.partDataArr != NSNull() {//判断是不是对方车辆界面
            for dict in carDataArr {
                if ((dict as? NSDictionary) != nil)  {
                    if dict.objectForKey("partiesmark")?.integerValue == 1 {
                        self.carnoLabel.text = dict.objectForKey("partiescarno") as? String
                        self.carModelLabel.text = dict.objectForKey("vehiclename") as? String
                    }
                    if dict.objectForKey("partiesmark")?.integerValue == 0 {
                        self.carnoStr = dict.objectForKey("partiescarno") as? String
                    }
                }
            }
            ascriptionLabel.text = "对方车辆信息"
            self.nextButton.setTitle("定损", forState: UIControlState.Normal)
        }else if carType == "oneCar" {//单车定损，只有我的车辆
            self.nextButton.setTitle("定损", forState: UIControlState.Normal)
            self.carnoLabel.text = carnoStr
            self.carModelLabel.text = carmodelStr
        }
        
        self.MainScrolleView.contentSize = CGSize(width:  (SCRW - 40) * 6.0, height: (SCRW - 40) / 622.0 * 447.0)
        
        for var i = 0 ; i < 6; i++ {
            let view = NSBundle.mainBundle().loadNibNamed("CarPartsView", owner: nil, options: nil)[i] as! CarPartsView
            view.frame = CGRect(x:(SCRW - 40) * CGFloat(i), y: 0, width: (SCRW - 40), height: (SCRW - 40) / 622.0 * 447.0)
            view.onlineVC = self
            self.MainScrolleView.addSubview(view)
        }
    }
    ///定损按钮点击事件
    @IBAction func nextBtnClick(sender: AnyObject) {
        if self.partsArr.count == 0 {
//            if #available(iOS 8.0, *) {
                let alertV = UIAlertController.creatAlertWithTitle(title: nil, message: "至少选择一个部位", cancelActionTitle: "确定")
                self.presentViewController(alertV, animated: true, completion: nil)
//            } else {
//                // Fallback on earlier versions
//            }
            
            return
        }
        if carType == "oneCar" {
            print(self.partsArr)
            for dict in self.partsArr {
                if dict.objectForKey("partid") != nil {
                    dict.setValue(nil, forKey: "partid")
                }
            }
            print(self.partsArr)
            
            let userDefault = NSUserDefaults.standardUserDefaults()
            let personalData = userDefault.objectForKey("userInfoLoginData") as! NSDictionary
            let userInfoData = UserInfoData.mj_objectWithKeyValues(personalData)
            var partiesid = ""
            var taskid = ""
            if self.responsibilitydata == nil {
                print("responsibilitydata不可能是nil")
                taskid = String()
            }
            if isWhatControllerPushIn == "discoverVC" {
                partiesid = String()
            }else {
                taskid = self.responsibilitydata.objectForKey("taskid") as! String
                
                if let partiesidDict = self.responsibilitydata.objectForKey("responsibilitydata") as? NSDictionary {
                    partiesid = partiesidDict.objectForKey("partiesid") as! String
                }else if let partiesidArr = self.responsibilitydata.objectForKey("responsibilitydata") as? NSArray {
                    for dict in partiesidArr {
                        if let partiesidDict = dict as? NSDictionary {
                            partiesid = partiesidDict.objectForKey("partiesid") as! String
                        }
                    }
                }
            }
            
            let data : NSMutableDictionary = ["taskid":taskid,"flowcode":"200103","flowname":"在线定损","partiescarno":carnoStr,"partdata":[["parts":self.partsArr,"partiesid":partiesid]]]
            
            let paramet = ["requestcode":"003005","accessid":userInfoData.accessid,"accesskey":userInfoData.accesskey,"userid":userInfoData.userid,"data":data]
            
            self.hud.labelText = "定损中..."
            self.hud.show(true)
            print(data)
            
            KptRequestClient.sharedInstance.Kpt_post("/plugins/changhui/port/task/taskFee", paramet: paramet, viewController: self, success: { (data) -> Void in
                print(data)
                self.damageModelArr = DamageModel.mj_objectArrayWithKeyValuesArray(data)
                
                let damageVC = DamageResultsViewController()
                damageVC.damageDataArr = self.damageModelArr
                damageVC.isWhatControllerPushIn = self.isWhatControllerPushIn
                if self.isWhatControllerPushIn == "discoverVC" {
                    
                }else {
                    let taskid = self.responsibilitydata.objectForKey("taskid") as? String
                    damageVC.taskId = taskid
                }
                
                
                self.navigationController?.pushViewController(damageVC, animated: true)
                self.hud.hide(true)
                }) { (_) -> Void in
                    self.hud.hide(true)
            }

        }
        if carType == "twoCar" {
            print(self.partsArr)
            for dict in self.partsArr {
                if dict.objectForKey("partid") != nil {
                    dict.setValue(nil, forKey: "partid")
                }
            }
            print(self.partsArr)
            
            if self.nextButton.titleLabel?.text == "下一步" {
                let onlineVC = OnlineInsuranceViewController(nibName: "OnlineInsuranceViewController", bundle: nil)
                self.partDataArr.addObject(self.partsArr)
                onlineVC.responsibilitydata = self.responsibilitydata
                onlineVC.carDataArr = self.carDataArr
                let arr = self.responsibilitydata.objectForKey("responsibilitydata") as! NSMutableArray
                let dataDict = NSMutableDictionary()
                for dict in arr {
                    if let _ = dict as? NSMutableDictionary {
                        if dict.objectForKey("partiesmark")!.integerValue == 0 {
                            dataDict.setValue(dict.objectForKey("partiesid")!, forKey: "partiesid")
                                dataDict.setValue(self.partsArr, forKey: "parts")
                        }
                        
                    }
                    
                }
                onlineVC.partDataArr.addObject(dataDict)
                onlineVC.carType = "twoCar"
                self.navigationController?.pushViewController(onlineVC, animated: true)
                
            }else if self.nextButton.titleLabel?.text == "定损" {
                let userDefault = NSUserDefaults.standardUserDefaults()
                let personalData = userDefault.objectForKey("userInfoLoginData") as! NSDictionary
                let userInfoData = UserInfoData.mj_objectWithKeyValues(personalData)
                let arr = self.responsibilitydata.objectForKey("responsibilitydata") as! NSMutableArray
                let dataDict = NSMutableDictionary()
                for dict in arr {
                    if let _ = dict as? NSMutableDictionary {
                        if dict.objectForKey("partiesmark")!.integerValue == 1 {
                            dataDict.setValue(dict.objectForKey("partiesid")!, forKey: "partiesid")
                            dataDict.setValue(self.partsArr, forKey: "parts")
                        }
                        
                    }
                    
                }
                self.partDataArr.addObject(dataDict)
                
                let data : NSMutableDictionary = ["taskid":self.responsibilitydata.objectForKey("taskid") as! String,"flowcode":"200103","flowname":"在线定损","partiescarno":carnoStr,"partdata":self.partDataArr]
                
                let paramet = ["requestcode":"003005","accessid":userInfoData.accessid,"accesskey":userInfoData.accesskey,"userid":userInfoData.userid,"data":data]
                
                self.hud.labelText = "定损中..."
                self.hud.show(true)
                print(data)
                
                KptRequestClient.sharedInstance.Kpt_post("/plugins/changhui/port/task/taskFee", paramet: paramet, viewController: self, success: { (data) -> Void in
                    print(data)
                    self.damageModelArr = DamageModel.mj_objectArrayWithKeyValuesArray(data)
                    
                    let damageVC = DamageResultsViewController()
                    let taskid = self.responsibilitydata.objectForKey("taskid") as? String
                    damageVC.taskId = taskid
                    
                    damageVC.damageDataArr = self.damageModelArr
                    damageVC.isWhatControllerPushIn = self.isWhatControllerPushIn
                    self.navigationController?.pushViewController(damageVC, animated: true)
                    self.hud.hide(true)
                    }) { (_) -> Void in
                        self.hud.hide(true)
                }
            }else {
                print("出错了")
            }
        }
    }
    
    private lazy var hud : MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    private lazy var damageModelArr : NSMutableArray = NSMutableArray()
    private lazy var backImageStrArr : [String] = ["左前","左后","左侧","右后","右侧","右前"]
    
    ///用于保存选中的受损部位
    lazy var partsArr:NSMutableArray = NSMutableArray()
    ///用于保存车辆信息和受损部位信息
    lazy var partDataArr:NSMutableArray = NSMutableArray()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension OnlineInsuranceViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let i : Int = Int(scrollView.contentOffset.x / scrollView.frame.width)
        if i >= 0 && i < backImageStrArr.count {
            self.partLabel.text = self.backImageStrArr[i]
            
            self.pageView.currentPage = i
        }
       
    }
}
