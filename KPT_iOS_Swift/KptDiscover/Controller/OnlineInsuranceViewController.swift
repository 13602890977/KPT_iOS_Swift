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
    ///车牌号码
    @IBOutlet weak var carnoLabel: UILabel!
    ///接收车牌号码
    var carnoStr : String!
    ///车型
    @IBOutlet weak var carModelLabel: UILabel!
    ///接收车型
    var carmodelStr : String!
    ///接收车型id
    var carmodelId : String!
    ///受损部位label
    @IBOutlet weak var partLabel: UILabel!
    ///显示车受损位置图片
    @IBOutlet weak var MainScrolleView: UIScrollView!
    ///显示图片个数
    @IBOutlet weak var pageView: UIPageControl!
    ///点击进入下一步(需要区分双车和单车,双车显示下一步，进入对方车辆受损界面，单车直接提交数据)
    @IBOutlet weak var nextButton: UIButton!
    
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
        self.carnoLabel.text = carnoStr
        self.carModelLabel.text = carmodelStr
        self.partLabel.text = "左前"
        self.MainScrolleView.delegate = self
        self.nextButton.setTitle("定损", forState: UIControlState.Normal)
        
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
        
        let data : NSMutableDictionary = ["flowcode":"200103","flowname":"在线定损","partiescarno":carnoStr,"partdata":[["parts":self.partsArr,"partiesid":NSNull()]]]
        
        let paramet = ["requestcode":"003005","accessid":userInfoData.accessid,"accesskey":userInfoData.accesskey,"userid":userInfoData.userid,"data":data]
        
        self.hud.labelText = "定损中..."
        self.hud.show(true)
        print(data)
        
        KptRequestClient.sharedInstance.Kpt_post("/plugins/changhui/port/task/taskFee", paramet: paramet, viewController: self, success: { (data) -> Void in
            print(data)
            self.damageModelArr = DamageModel.mj_objectArrayWithKeyValuesArray(data)
            
            let damageVC = DamageResultsViewController()
            damageVC.damageDataArr = self.damageModelArr
            
            self.navigationController?.pushViewController(damageVC, animated: true)
            self.hud.hide(true)
            }) { (_) -> Void in
                self.hud.hide(true)
        }
    }
    
    private lazy var hud : MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    private lazy var damageModelArr : NSMutableArray = NSMutableArray()
    private lazy var backImageStrArr : [String] = ["左前","左后","左侧","右后","右侧","右前"]
    
    ///用于保存选中的受损部位
    lazy var partsArr:NSMutableArray = NSMutableArray()
    
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
