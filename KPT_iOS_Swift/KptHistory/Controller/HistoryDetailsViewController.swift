//
//  HistoryDetailsViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/17.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import MJRefresh
import MBProgressHUD

class HistoryDetailsViewController: UIViewController {

    ///接收保存传入的任务id，用于请求数据的标示
    var taskId : String!
    ///模型
    private var detailModel : HistoryDetailModel?
    ///事故车辆
    var carnoLabelText:String!
    ///事故类型
    var accidentLabelText:String!
    ///事故地址
    var addressLabelStr:String!
    ///用于标记在线定责走到哪一步(AutographView：分了责任，无争议，但是没签名确认，SceneView:没有分责，跳到事故场景选择)
    private var dutydataType : String!
    
    ///定责成功则将责任分担保存下来
    private var progressBackViewPercent : Float = 0
    ///保存在线定责流程id
    private var flowidStr : String!
    ///保存在线定损流程id
    private var damageFlowid : String!
    ///保存拍照取证流程id
    private var photoFlowid : String!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let navigationBar = self.navigationController!.navigationBar
        navigationBar.barTintColor = UIColor.blackColor()
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        //一进入就开始下拉刷新(不需要放在viewwillapp方法中，因为这个节目是present的)
        self.tableView.mj_header.beginRefreshing()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "历史详情"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFontOfSize(19.0),NSForegroundColorAttributeName:MainColor]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "展开"), style: UIBarButtonItemStyle.Plain, target: self, action: "cancelBtnClick")
        self.navigationItem.leftBarButtonItem?.tintColor = MainColor
        //用于接收那个cell被点击，cell是属于那个流程
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "historyDetailsCellClick:", name: "KPT_HistoryDetailsCell", object: nil)
        //用于图片点击
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "detailsPhotoCellClick", name: "KPT_DetailsPhotoCell", object: nil)
        self.view = self.tableView
        ///不显示cell的分隔线
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        //添加下拉刷新
        header.setRefreshingTarget(self, refreshingAction: "headerRefresh")
        self.tableView.mj_header = header
        
        
        // Do any additional setup after loading the view.
    }
    func headerRefresh() {
        reloadHistoryDetailData()
    }
    func historyDetailsCellClick(noti : NSNotification) {
        print(noti.userInfo)
        
        if noti.userInfo?["一键报案"] != nil {
            if noti.userInfo?["一键报案"]?.integerValue == 0 {
                if noti.userInfo?["一键报案"] as? String == "继续处理" {
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
            }else {
                 self.navigationController?.pushViewController(ReportSuccessViewController(nibName:"ReportSuccessViewController",bundle: nil), animated: true)
            }
        }else if noti.userInfo?["在线定损"] != nil {
            if noti.userInfo?["在线定损"]?.integerValue == 0 {
                if noti.userInfo?["在线定损"] as? String == "继续处理" {
                    if accidentLabelText == "双车事故" {
                        let onlineVC = OnlineInsuranceViewController(nibName:"OnlineInsuranceViewController",bundle: nil)
                        
                        onlineVC.carType = "twoCar"
                        onlineVC.carDataArr = self.partiesdataArr
                        onlineVC.responsibilitydata = self.responsibilitydataDict
                        self.navigationController?.pushViewController(onlineVC, animated: true)
                    }else  {//单车事故
                        let onlineVC = OnlineInsuranceViewController(nibName:"OnlineInsuranceViewController",bundle: nil)
                        onlineVC.carDataArr = self.partiesdataArr
                        for dict in partiesdataArr {
                            if ((dict as? NSDictionary) != nil)  {
                                if dict.objectForKey("partiesmark")?.integerValue == 0 {
                                    onlineVC.carnoStr = dict.objectForKey("partiescarno") as? String
                                    onlineVC.carmodelStr = dict.objectForKey("vehiclename") as? String
                                    
                                }
                            }
                        }
                        onlineVC.carType = "oneCar"
                        onlineVC.responsibilitydata = self.responsibilitydataDict
                        
                        self.navigationController?.pushViewController(onlineVC, animated: true)
                    }
                   
                }
            }else {//定损完成
                
                self.hud.labelText = "加载中..."
                self.hud.show(true)
                
                let userDefault = NSUserDefaults.standardUserDefaults()
                let personalData = userDefault.objectForKey("userInfoLoginData") as! NSDictionary
                let userInfoData = UserInfoData.mj_objectWithKeyValues(personalData)
                
                KptRequestClient.sharedInstance.Kpt_Get("/plugins/changhui/port/history/lossDetail?requestcode=004005&accessid=\(userInfoData.accessid)&accesskey=\(userInfoData.accesskey)&userid=\(userInfoData.userid)&taskid=\(taskId)&flowid=\(damageFlowid)", paramet: nil, viewController: self, success: { (data) -> Void in
                    print(data)
                    self.hud.hide(true)
                    if data as? NSDictionary != nil{
                        let damageData : DamageModel = DamageModel.mj_objectWithKeyValues(data)
                        self.damageModelArr.addObject(damageData)
                    }else if data as? NSArray != nil {
                        self.damageModelArr = DamageModel.mj_objectArrayWithKeyValuesArray(data)
                    }
                    
                    let damageVC = DamageResultsViewController()
                    damageVC.damageDataArr = self.damageModelArr
                    let taskid = self.responsibilitydataDict.objectForKey("taskid") as? String
                    damageVC.taskId = taskid
                    
                    self.navigationController?.pushViewController(damageVC, animated: true)
                    
                    }, failure: { (_) -> Void in
                        self.hud.hide(true)
                })
                
            }
        }else if noti.userInfo?["在线定责"] != nil {
            if noti.userInfo?["在线定责"]?.integerValue == 0 {
                if noti.userInfo?["在线定责"] as? String == "继续处理" {
                    //在线定责的继续处理分两种（交警定责还是双方协定,又分责任完成但未同意和未完成)
                    if self.dutydataType == "SceneView" {
                        let sceneVC = SceneViewController(nibName:"SceneViewController",bundle: nil)
                        sceneVC.partiesdataArr = self.partiesdataArr
                        sceneVC.responsibilitydata = self.responsibilitydataDict
                        
                        self.navigationController?.pushViewController(sceneVC, animated: true)
                    }else if self.dutydataType == "PoliceResponsibleView" {
                        let userDefault = NSUserDefaults.standardUserDefaults()
                        let personalData = userDefault.objectForKey("userInfoLoginData") as! NSDictionary
                        let userInfoData = UserInfoData.mj_objectWithKeyValues(personalData)
                        
                        
                        let parame = ["requestcode":"003003","accessid":userInfoData.accessid,"accesskey":userInfoData.accesskey,"userid":userInfoData.userid,"taskid":taskId,"flowid":flowidStr]
                        
                        KptRequestClient.sharedInstance.Kpt_post("/plugins/changhui/port/task/trffPolicedutytask", paramet: parame, viewController: self, success: { (data) -> Void in
                            print(data)
                            self.navigationController?.pushViewController(PoliceResponsibleViewController(nibName:"PoliceResponsibleViewController",bundle: nil), animated: true)
                            
                            }, failure: { (_) -> Void in
                                
                        })
                    }else {
                        let flowid = responsibilitydataDict.objectForKey("flowid")
                        let responsibleVC = AutographViewController(nibName:"AutographViewController",bundle: nil)
                        responsibleVC.responsibilitydata = self.responsibilitydataDict
                        responsibleVC.partiesdataArr = self.partiesdataArr
                        responsibleVC.flowid = flowid as! String
                        responsibleVC.myPercentage = self.progressBackViewPercent
                        
                        self.navigationController?.pushViewController(responsibleVC, animated: true)
                    }
                }
            }else {//定责完成
                self.hud.labelText = "加载中..."
                self.hud.show(true)
                
                let userDefault = NSUserDefaults.standardUserDefaults()
                let personalData = userDefault.objectForKey("userInfoLoginData") as! NSDictionary
                let userInfoData = UserInfoData.mj_objectWithKeyValues(personalData)
                
                KptRequestClient.sharedInstance.Kpt_Get("/plugins/changhui/port/history/dutyDetail?requestcode=004004&accessid=\(userInfoData.accessid)&accesskey=\(userInfoData.accesskey)&userid=\(userInfoData.userid)&taskid=\(taskId)&flowid=\(flowidStr)", paramet: nil, viewController: self, success: { (data) -> Void in
                        print(data)
                    self.hud.hide(true)
                        let webVC = Kpt_WebViewController()
                        webVC.protocolsrc = data as? String
                    self.navigationController?.pushViewController(webVC, animated: true)
                    
                    }, failure: { (_) -> Void in
                        self.hud.hide(true)
                })
            }
        }
    }
    
    func detailsPhotoCellClick() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        let personalData = userDefault.objectForKey("userInfoLoginData") as! NSDictionary
        let userInfoData = UserInfoData.mj_objectWithKeyValues(personalData)
        
        KptRequestClient.sharedInstance.Kpt_Get("/plugins/changhui/port/history/photographDetail?requestcode=004003&accessid=\(userInfoData.accessid)&accesskey=\(userInfoData.accesskey)&userid=\(userInfoData.userid)&taskid=\(taskId)&flowid=\(photoFlowid)", paramet: nil, viewController: self, success: { (data) -> Void in
            if data as? NSMutableArray != nil {
                let detailsPhotoVC = DetailPhotoScrollViewController()
                detailsPhotoVC.photoArr = data as! NSMutableArray
                detailsPhotoVC.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                self.presentViewController(detailsPhotoVC, animated: true, completion: nil)
                }
            }) { (_) -> Void in
                
        }
    }
    private func reloadHistoryDetailData() {
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        //全部填写完成之后上传车辆信息
        let personalData = userDefault.objectForKey("userInfoLoginData") as! NSDictionary
        let userInfoData = UserInfoData.mj_objectWithKeyValues(personalData)
        self.hud.labelText = "加载数据中"
        self.hud.show(true)
        
        KptRequestClient.sharedInstance.Kpt_Get("/plugins/changhui/port/history/getTaskDetail?requestcode=004002&accessid=\(userInfoData.accessid)&accesskey=\(userInfoData.accesskey)&userid=\(userInfoData.userid)&taskid=\(taskId)", paramet: nil, viewController: self, success: { (data) -> Void in
            
            if let datadict = data as? NSDictionary {
                if self.accidentLabelText == "单车事故" {
                    self.bicycleAccidentData(datadict)
                }else {//双车事故
                   self.doubleCarAccidentData(datadict)
                }
                self.detailsDataAndPhotos(datadict)
            }
            self.dataOrderSorting()
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()//刷新界面
            self.hud.hide(true)
            }) { (_) -> Void in
                self.tableView.mj_header.endRefreshing()
                self.hud.hide(true)
                
        }
    }
    //单车事故需要的数据提取
    private func bicycleAccidentData(datadict:NSDictionary) {
        print("单车事故，没有在线定责")
        //维修费用(在线定损)
        let lossdata = datadict.objectForKey("lossdata")
        if let dict = lossdata as? NSDictionary {
            let data = lossdataModel.mj_objectWithKeyValues(dict)
            self.modelDict.setValue(data, forKey: "lossdata")
//            damageFlowid
            //在线定损流程id
            let flowid = dict.objectForKey("flowid")
            if flowid != nil {
                if let flowidStr = flowid as? String {
                    self.damageFlowid = flowidStr
                }
            }
        }else {//定损未完成
            self.modelDict.setValue("lossdata", forKey: "lossdata")
        }
        //一键报案
        let reportdata = datadict.objectForKey("reportdata")
        if let dict = reportdata as? NSDictionary {
            let data = reportdataModel.mj_objectWithKeyValues(dict)
            self.modelDict.setValue(data, forKey: "reportdata")
        }else {
            //一键报案未完成
            
            self.modelDict.setValue("reportdata", forKey: "reportdata")
        }

    }
    //双车事故需要的数据提取
    private func doubleCarAccidentData(datadict:NSDictionary){
        print("双车事故，有在线定责")
        let dutyData = datadict.objectForKey("dutydata")
        if let dict = dutyData as? NSDictionary {
            let data = dutydataModel.mj_objectWithKeyValues(dict)
            self.modelDict.setValue(data, forKey: "dutydata")
            //在线定责流程id
            let flowid = dict.objectForKey("flowid")
            if flowid != nil {
                if let flowidStr = flowid as? String {
                    self.flowidStr = flowidStr
                }
            }
            if data.dutydetail?.count > 0 /*大于0表示定责完成*/{
                for dutydetailDict in data.dutydetail! {
                    if let dutydeDic = dutydetailDict as? NSDictionary {
                        if dutydeDic.objectForKey("partiesmark")?.integerValue == 0 {
                            self.progressBackViewPercent = (dutydeDic.objectForKey("dutyratio")?.floatValue)! / 100
                            
                        }else if dutydeDic.objectForKey("partiesmark")?.integerValue == 1 {
                            self.progressBackViewPercent = 1 - (dutydeDic.objectForKey("dutyratio")?.floatValue)! / 100
                        }
                    }
                }
                if data.fixduty == "1" {//双方协定
                    if data.dutystatus == "0" {//有争议
                        self.dutydataType = "AutographView"
                        self.modelDict.setValue("dutydata", forKey: "dutydata")
                        
                    }else {//无争议
                        //维修费用(在线定损)
                        let lossdata = datadict.objectForKey("lossdata")
                        if lossdata != nil {
                            if let dict = lossdata as? NSDictionary {
                                //在线定损流程id
                                let flowid = dict.objectForKey("flowid")
                                if flowid != nil {
                                    if let flowidStr = flowid as? String {
                                        self.damageFlowid = flowidStr
                                    }
                                }
                                let data = lossdataModel.mj_objectWithKeyValues(dict)
                                self.modelDict.setValue(data, forKey: "lossdata")
                            }else {
                                self.modelDict.setValue("lossdata", forKey: "lossdata")
                            }
                        }else {
                            self.modelDict.setValue("lossdata", forKey: "lossdata")
                        }
                        
                        //一键报案
                        let reportdata = datadict.objectForKey("reportdata")
                        if reportdata != nil {
                            if let dict = reportdata as? NSDictionary {
                                let data = reportdataModel.mj_objectWithKeyValues(dict)
                                
                                self.modelDict.setValue(data, forKey: "reportdata")
                            }else {
                                self.modelDict.setValue("reportdata", forKey: "reportdata")
                            }
                        }else {
                            self.modelDict.setValue("reportdata", forKey: "reportdata")
                        }
                    }
                }else if data.fixduty == "2" {//交警定责
                    if data.dutystatus == "0" {//有争议
                        self.dutydataType = "PoliceResponsibleView"
                        self.modelDict.setValue("dutydata", forKey: "dutydata")
                        
                    }else {//无争议
                        //维修费用(在线定损)
                        let lossdata = datadict.objectForKey("lossdata")
                        if lossdata != nil {
                            if let dict = lossdata as? NSDictionary {
                                //在线定损流程id
                                let flowid = dict.objectForKey("flowid")
                                if flowid != nil {
                                    if let flowidStr = flowid as? String {
                                        self.damageFlowid = flowidStr
                                    }
                                }
                                let data = lossdataModel.mj_objectWithKeyValues(dict)
                                self.modelDict.setValue(data, forKey: "lossdata")
                            }else {
                                self.modelDict.setValue("lossdata", forKey: "lossdata")
                            }
                        }else {
                            self.modelDict.setValue("lossdata", forKey: "lossdata")
                        }
                        
                        //一键报案
                        let reportdata = datadict.objectForKey("reportdata")
                        if reportdata != nil {
                            if let dict = reportdata as? NSDictionary {
                                let data = reportdataModel.mj_objectWithKeyValues(dict)
                                
                                self.modelDict.setValue(data, forKey: "reportdata")
                            }else {
                                self.modelDict.setValue("reportdata", forKey: "reportdata")
                            }
                        }else {
                            self.modelDict.setValue("reportdata", forKey: "reportdata")
                        }
                    }

                }
            }else {
                if data.fixduty == "2" {
                    self.dutydataType = "PoliceResponsibleView"
                    
                }
                self.modelDict.setValue("dutydata", forKey: "dutydata")
            }
        }else {//则表示在线定责未完成
            self.dutydataType = "SceneView"
            self.modelDict.setValue("dutydata", forKey: "dutydata")
        }
        

    }
    //车辆信息和照片信息数据提取
    private func detailsDataAndPhotos(datadict:NSDictionary) {
        //事故车辆详情
        let partiesdata = datadict.objectForKey("partiesdata")
        if partiesdata != nil {
            if let arr = partiesdata as? NSArray {
                self.partiesdataArr = arr.mutableCopy() as! NSMutableArray
            }
        }else {
            print("数据请求失败，请退出重试")
        }
        
        //事故拍照取证(拍照取证)
        let photodata = datadict.objectForKey("photodata")
        if photodata != nil {
            if let dict = photodata as? NSDictionary {
                self.responsibilitydataDict = dict.mutableCopy() as! NSMutableDictionary
                //任务id
                let taskid = datadict.objectForKey("taskid")
                if taskid != nil {
                    if let taskidStr = taskid as? String {
                        self.taskId = taskidStr
                        self.responsibilitydataDict.setValue(taskidStr, forKey: "taskid")
                    }
                }
                //拍照取证流程id
                let flowid = dict.objectForKey("flowid")
                if flowid != nil {
                    if let flowidStr = flowid as? String {
                        self.photoFlowid = flowidStr
                    }
                }
                let data = photodataModel.mj_objectWithKeyValues(dict)
                self.modelDict.setValue(data, forKey: "photodata")
            }
        }

    }
    //整理数据顺序，方便列表使用
    private func dataOrderSorting() {
        ///要按顺序添加进去
        ///数据数组
        let modelMiddleArr:NSMutableArray = ["false","false","false","false"]
        for key in self.modelDict.allKeys {
            if key as? String == "reportdata" {//一键报案
                modelMiddleArr[0] = self.modelDict.objectForKey(key)!
            }
            if key as? String == "lossdata" {//在线定损
                modelMiddleArr[1] = self.modelDict.objectForKey(key)!
            }
            if key as? String == "dutydata" {//在线定责
                modelMiddleArr[2] = self.modelDict.objectForKey(key)!
            }
            if key as? String == "photodata" {//拍照取证
                modelMiddleArr[3] = self.modelDict.objectForKey(key)!
            }
        }
        for object in modelMiddleArr {//将没有的删除
            if object as? String == "false" {
                modelMiddleArr.removeObject(object)
                break
            }
        }
        self.modelArr = modelMiddleArr
        print(self.responsibilitydataDict)
        print(self.modelArr)

    }
    func cancelBtnClick() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    private lazy var tableView :UITableView = {
        let tableview = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        tableview.delegate = self
        tableview.dataSource = self
        return tableview
    }()
    ///事故信息详情
    private lazy var partiesdataArr : NSMutableArray = NSMutableArray()
    ///当事人信息(主要包含任务id和当事人id)
    private lazy var responsibilitydataDict:NSMutableDictionary = NSMutableDictionary()
    //保存车辆受损情况
    private lazy var damageModelArr : NSMutableArray = NSMutableArray()
    ///数据数组
    private lazy var modelArr:NSMutableArray = NSMutableArray()
    private lazy var modelDict:NSMutableDictionary = NSMutableDictionary()
    
    private lazy var header:MJRefreshNormalHeader = MJRefreshNormalHeader()
    
    private lazy var hud : MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension HistoryDetailsViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 110
    }
    //设置头视图，显示车牌和事故类型，事故地址信息
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 110))
        view.backgroundColor = UIColor.whiteColor()
        ///车牌号码
        let carnoLabel = UILabel(frame: CGRect(x: 15, y: 10, width:UIScreen.mainScreen().bounds.width, height: 20))
        carnoLabel.text = "车牌号：\(carnoLabelText)"
        view.addSubview(carnoLabel)
        ///事故类型Label
        let accidentLabel = UILabel(frame: CGRect(x: 15, y: carnoLabel.frame.origin.y + carnoLabel.frame.height + 10, width:UIScreen.mainScreen().bounds.width, height: 20))
        accidentLabel.text = "事故类型：\(accidentLabelText)"
        accidentLabel.font = UIFont.systemFontOfSize(15)
        view.addSubview(accidentLabel)
        ///事故地址Label
        let addressLabelText = UILabel(frame: CGRect(x: 15, y:  accidentLabel.frame.origin.y + accidentLabel.frame.height + 10, width:UIScreen.mainScreen().bounds.width, height: 20))
        addressLabelText.text = "事故地址："
        addressLabelText.font = UIFont.systemFontOfSize(15)
        view.addSubview(addressLabelText)
        
        let addressLabel = UILabel(frame: CGRect(x: 90, y:  accidentLabel.frame.origin.y + accidentLabel.frame.height + 5, width:UIScreen.mainScreen().bounds.width - 95, height: 40))
        addressLabel.font = UIFont.systemFontOfSize(15)
        addressLabel.numberOfLines = 0
        addressLabel.text = addressLabelStr
        view.addSubview(addressLabel)
        ///底部划线
        let image = UIImageView(frame: CGRect(x: 0, y: view.frame.height - 1, width: UIScreen.mainScreen().bounds.width, height: 1))
        image
            .backgroundColor = UIColor.lightGrayColor()
        view.addSubview(image)
        
        return view
    }
    //设置cell的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.modelArr[0].isKindOfClass(reportdataModel.classForCoder()) && indexPath.row == 0 {
            return 75//如果一键报案存在，将一键报案所在的cell的高度降低
        }else if indexPath.row == self.modelArr.count - 1 {//如果是最后一个cell，即是图片显示的cell
            if let photo = modelArr.lastObject as? photodataModel {//根据图片的数量返回高度
                let phtotRow = (photo.photodata?.count)! / 2
                let photoSection = ((photo.photodata?.count)! % 2)
               return CGFloat(phtotRow + photoSection) * CGFloat(SCRW * 0.3 + 40) + (10 * CGFloat(phtotRow)) + 40
            }else {
                return 115
            }
        }else {
            return 115
        }
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.modelDict.allKeys)
        return self.modelDict.allKeys.count > 0 ? self.modelDict.allKeys.count : 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "cellIdentifier"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? HistoryDetailsCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("HistoryDetailsCell", owner: nil, options: nil).last as? HistoryDetailsCell
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
        }
        cell?.data = self.modelArr[indexPath.row]
        cell?.indexPathRow = indexPath.row
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? HistoryDetailsCell
        NSNotificationCenter.defaultCenter().postNotificationName("KPT_HistoryDetailsCell", object: nil, userInfo: [(cell?.accidentTypeName.text)!:cell!.accessoryType == UITableViewCellAccessoryType.DisclosureIndicator])
    }
}