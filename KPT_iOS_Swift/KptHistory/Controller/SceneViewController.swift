//
//  SceneViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/27.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class SceneViewController: UIViewController {

    @IBOutlet weak var mainCollection: UICollectionView!
    ///用于接收车辆信息(拍照取证上传成功后)
    var partiesdataArr : NSMutableArray!
    ///当事人信息(主要包含任务id和当事人id)
    var responsibilitydata:NSDictionary!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = MainColor
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "事故场景"
        
        self.mainCollection.backgroundColor = UIColor.whiteColor()
        self.mainCollection.backgroundColor = UIColor.whiteColor()
        
        mainCollection.registerNib(UINib(nibName: "PhotoEvidenceCell", bundle: nil), forCellWithReuseIdentifier: "collectionIdentifier")
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        let alertSheet = UIAlertController(title: "选择我方责任", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let alertActionTitleArr = ["全责","主责","次责","共同责任","无责","责任不明确"]
        
        for var i = 0; i < 6;i++ {
            let alertA = UIAlertAction(title: alertActionTitleArr[i], style: UIAlertActionStyle.Default, handler: { (alertA) -> Void in
                let responsibleVC = ResponsibleResultsViewController(nibName:"ResponsibleResultsViewController",bundle: nil)
                switch (alertA.title)!  {
                    case "全责","主责","次责","共同责任","无责" :
                        responsibleVC.responsibilityStr = (alertA.title)!
                        responsibleVC.partiesdataArr = self.partiesdataArr
                        responsibleVC.responsibilitydata = self.responsibilitydata
                        responsibleVC.accidentType = self.photoName[indexPath.row]
                        
                        self.navigationController?.pushViewController(responsibleVC, animated: true)
                    break
                    
                    default:
                        let alertC = UIAlertController(title: nil, message: "双方存在争议，是否提交由交警在线定责？", preferredStyle: UIAlertControllerStyle.Alert)
                        let cancelA =  UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
                        alertC.addAction(cancelA)
                        let alertA = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (alertA) -> Void in
                            print("提交交警")
                            let userDefault = NSUserDefaults.standardUserDefaults()
                            let personalData = userDefault.objectForKey("userInfoLoginData") as! NSDictionary
                            let userInfoData = UserInfoData.mj_objectWithKeyValues(personalData)
                            
                            let arr = self.responsibilitydata.objectForKey("responsibilitydata") as! NSMutableArray
                            let dataDict = NSMutableDictionary()
                            let dataArr = NSMutableArray()
                            for dict in arr {
                                if let _ = dict as? NSMutableDictionary {
                                    dataDict.setValue("责任不明确", forKey: "dutyname")
                                    dataDict.setValue(dict.objectForKey("partiesid")!, forKey: "partiesid")
                                    dataDict.setValue(dict.objectForKey("partiesmark")!, forKey: "partiesmark")
                                    dataArr.addObject(dataDict)
                                }
                                
                            }
                            print(dataArr)
                            
                            let data : NSDictionary = ["taskid":self.responsibilitydata.objectForKey("taskid")!,"flowcode":"200102","flowname":"责任认定","accidentscene":self.photoName[indexPath.row],"fixduty":"2","isconfirm":"0","responsibilitydata":dataArr]
                            let parame = ["requestcode":"003002","accessid":userInfoData.accessid,"accesskey":userInfoData.accesskey,"userid":userInfoData.userid,"data":data]
                            
                            KptRequestClient.sharedInstance.Kpt_post("/plugins/changhui/port/task/dutytask", paramet: parame, viewController: self, success: { (data) -> Void in
                                print(data)
                                }, failure: { (_) -> Void in
                                    
                            })
                        })
                        alertA.setValue(MainColor, forKey: "titleTextColor")
                        alertC.addAction(alertA)
                        self.presentViewController(alertC, animated: true, completion: nil)
                    break
                }
                
            })
            alertSheet.addAction(alertA)
        }
        let cancelA = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        alertSheet.addAction(cancelA)
        self.presentViewController(alertSheet, animated: true, completion: nil)
    }
    
    private lazy var photoNameStr : [String] = ["逆向行驶","变革车道或超车","掉头、倒车或溜车","追尾","转弯未避让直行","违反信号灯指示","违反箭头指示","违反让行标志标线","开关车门"]
    private lazy var photoName : [String] = ["逆行","变道","掉头","追尾","转弯","信号灯","剪头","让行","开门"]
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
extension SceneViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoNameStr.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let collectionIdentifier = "collectionIdentifier"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionIdentifier, forIndexPath: indexPath) as! PhotoEvidenceCell
        cell.photoImage.image = UIImage(named: self.photoName[indexPath.row])
        cell.photoLabel.text = self.photoNameStr[indexPath.row]
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: SCRW * 0.3 , height: SCRW * 0.3 + 40)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoEvidenceCell
        cell.backgroundColor = MainColor
        
    }
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoEvidenceCell
        cell.backgroundColor = UIColor.whiteColor()
    }
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}

