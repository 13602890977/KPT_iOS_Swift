//
//  PhotoEvidenceViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/15.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import Qiniu
import MBProgressHUD

class PhotoEvidenceViewController: UIViewController {

   
    @IBOutlet weak var mainCollection: UICollectionView!
    
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var lockBtn: UIButton!
    
    ///接收记录选择双车还是单车事故的
    var accidentType : String!
    ///用于接收事故车辆数据
    var photoPartiesdataArr : NSMutableArray!
    //用于标记闪光灯是否打开
    private var flashBtnBool = false
    //用于记录点击的cell
    private var cellIndexRow : Int!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = MainColor
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "拍照取证"
        self.mainCollection.backgroundColor = UIColor.whiteColor()
            
        mainCollection.registerNib(UINib(nibName: "PhotoEvidenceCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: "completeBtnClick")
        self.navigationItem.rightBarButtonItem?.tintColor = MainColor
        print(self.lockBtn)
    }
    //提交拍照
    func completeBtnClick() {
        
        if self.evidencedata.count >= CarPhotoStrArr.count {
            //调用拍照取证接口，上传数据
            photoGraph()
        }else {
//            if #available(iOS 8.0, *) {
                let alertV = UIAlertController.creatAlertWithTitle(title: nil, message: "请补全事故现场照片，\(CarPhotoStrArr.count)张必拍", cancelActionTitle: "确定")
                self.presentViewController(alertV, animated: true, completion: nil)
//            } else {
//                // Fallback on earlier versions
//            }
            
            return
        }
        
    }
    //拍照上传
    private func photoGraph() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        let personalData = userDefault.objectForKey("userInfoLoginData") as! NSDictionary
        let userInfoData = UserInfoData.mj_objectWithKeyValues(personalData)
        
        let address = userDefault.objectForKey("Kpt_address")
        let latlang = userDefault.objectForKey("kpt_latlng")
        //data
        let data = NSMutableDictionary()
        data.setValue(address, forKey: "accidentaddress")
        data.setValue(latlang, forKey: "latlng")
        data.setValue(accidentType == "twoCar" ? "2" : "1", forKey: "accidenttype")
        data.setValue(accidentType == "twoCar" ? "双车事故" : "单车事故", forKey: "accidenttypename")
        data.setValue(self.evidencedata, forKey: "evidencedata")
        data.setValue("200101", forKey: "flowcode")
        data.setValue("拍照取证", forKey: "flowname")
        data.setValue(self.photoPartiesdataArr, forKey: "partiesdata")
        self.hud.labelText = "上传数据中..."
        self.hud.show(true)
        let parmats = ["requestcode":"003001","accessid":userInfoData.accessid,"accesskey":userInfoData.accesskey,"userid":userInfoData.userid,"data":data]
        print(parmats)
        KptRequestClient.sharedInstance.Kpt_post("/plugins/changhui/port/task/photograph", paramet: parmats, viewController: self, success: { (data) -> Void in
            print(data)
            if let dict = data as? NSDictionary {
                let moveCarVC = MoveCarViewController(nibName:"MoveCarViewController",bundle: nil)
                moveCarVC.carType = self.accidentType
                moveCarVC.remindStr = dict.objectForKey("remark") as? String
                moveCarVC.moveCarPartiesdataArr = self.photoPartiesdataArr
                moveCarVC.taskId = dict.objectForKey("taskid") as? String
                moveCarVC.responsibilitydata = dict
                
                self.navigationController?.pushViewController(moveCarVC, animated: true)
            }
            self.hud.hide(true)
            }) { (_) -> Void in
                self.hud.hide(true)
        }
        
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        cellIndexRow = indexPath.row
        if evidencedata.count < CarPhotoStrArr.count  && indexPath.row == CarPhotoArr.count - 1{
//            if #available(iOS 8.0, *) {
                let alertC = UIAlertController.creatAlertWithTitle(title: "温馨提醒", message: "请您先拍摄前面\(CarPhotoStrArr.count)张主要的事故照片", cancelActionTitle: "确定")
                self.presentViewController(alertC, animated: true, completion: nil)
//            } else {
//                // Fallback on earlier versions
//            }
            return
        }
        if indexPath.row == CarPhotoArr.count - 1 {
            CarPhotoArr.addObject("矢量智能对象")
            self.mainCollection.reloadData()
        }
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.imagePicker.allowsEditing = false
            self.imagePicker.delegate = self
            ///隐藏导航栏
            self.imagePicker.showsCameraControls = false
            self.imagePicker.navigationBarHidden = true
//            self.imagePicker.
            self.imagePicker.cameraOverlayView?.frame = self.view.bounds
            self.overlayView.frame = (self.imagePicker.cameraOverlayView?.frame)!
            self.overlayView.delegate = self
            if indexPath.row < self.CarPhotoStrArr.count {
                self.overlayView.nameLabel.text = self.CarPhotoStrArr[indexPath.row]
                self.overlayView.shadowImage.image = UIImage(named: shadowImageName[indexPath.row])
                
            }else {
                self.overlayView.shadowImage.hidden = true
                self.overlayView.nameLabel.text = "其它"
            }
            
            //调整相机界面大小，但是会放大和拉伸
            self.imagePicker.cameraViewTransform = CGAffineTransformMakeScale(1.0, 1.2)
            
            self.imagePicker.cameraOverlayView = self.overlayView
            
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }else {
//            if #available(iOS 8.0, *) {
                let alertV = UIAlertController.creatAlertWithTitle(title: nil, message: "该设备不支持相机或者未同意使用相机功能,请确认同意打开相机", cancelActionTitle: "确认")
                self.presentViewController(alertV, animated: true, completion: nil)
//            } else {
//                // Fallback on earlier versions
//            }
        }
        
    }
    private lazy var imagePicker :UIImagePickerController = UIImagePickerController()
    
    private lazy var overlayView :MyPhotoEvidenceView = {
       let view = NSBundle.mainBundle().loadNibNamed("MyPhotoEvidenceView", owner: nil, options: nil).last as! MyPhotoEvidenceView
        view.backgroundColor = UIColor.clearColor()
        
        return view
    }()
    private lazy var shadowImageName : [String] = {
       var arr = [String]()
        if self.accidentType == "twoCar" {
            arr = ["shadowPositive45","shadowBehind45","collisionFeature","Apanorama","Bpanorama"]
        }else {
            arr = ["icon_single_front","icon_single_back1","icon_single_break"]
        }
        return arr
    }()
    private lazy var CarPhotoArr : NSMutableArray = {
        var arr = NSMutableArray()
        if self.accidentType == "twoCar" {
            arr = ["前45","后45","特写","A全景","B全景","矢量智能对象"]
        }else {
            arr = ["侧前","侧后","单车特写","矢量智能对象"]
        }
        return arr
    }()
    private lazy var CarPhotoStrArr : [String] = {
        var arr = [String]()
        if self.accidentType == "twoCar" {
            arr = ["现场正面45度全景照","现场背面45度全景照","碰撞部位特写","我方车辆全景","对方车辆全景"]
        }else {
            arr = ["侧前方全景","侧后方全景","碰撞部位特写"]
        }
        return arr
        }()
    ///用于保存上传的照片
    private lazy var evidencedata:NSMutableArray = NSMutableArray()
    
    private lazy var hud : MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view.superview, animated: true)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //查看照片示例
    @IBAction func lockBtnClick(sender: AnyObject) {
        let webView = Kpt_WebViewController()
        webView.protocolsrc = "http://hb.qq.com/zt/2013/whjj2013/lipei1021.htm"
        webView.protocolTitle = "照片示范"
        self.navigationController?.pushViewController(webView, animated: true)
    }
    

}

extension PhotoEvidenceViewController :UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CarPhotoArr.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let collectionIdentifier = "cell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionIdentifier, forIndexPath: indexPath) as! PhotoEvidenceCell
        
        cell.photoName = CarPhotoArr[indexPath.row] as! String
        
        if indexPath.row < CarPhotoStrArr.count {
            cell.photoLabel.text = CarPhotoStrArr[indexPath.row]
        }else {
            cell.photoLabel.text = "其它照片"
        }
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

extension PhotoEvidenceViewController : MyPhotoEvidenceViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func backBtnClick() {
        self.imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    func photoButtonClick() {
        print("拍照")
        self.imagePicker.takePicture()
    }
    func flashButtonClick() {
        print("调整闪光灯模式")
        if flashBtnBool {
            flashBtnBool = !flashBtnBool
            self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashMode.On
        }else {
            flashBtnBool = !flashBtnBool
            self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashMode.Off
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        print(info)
         let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let sizeImage = reSizeImage(image, toSize: CGSize(width: 480, height: 800))
        var viewImage = UIImage()
        if cellIndexRow < CarPhotoStrArr.count {
            viewImage = addViewImage(CarPhotoStrArr[cellIndexRow])
        }else {
            viewImage = addViewImage("其他")
        }
        let changeImage = addImage(viewImage, backImage: sizeImage, rect: CGRect(x: 0, y: sizeImage.size.height - 160 , width: SCRW, height: 160))
        
        weak var weakSelf = self
        //七牛图片上传
        
        image.QiniuPhotoUpdateReturnImageUrlStr(changeImage) { (appkey) -> Void in
            let url = QinniuUrl.stringByAppendingString("\(appkey)")
            weakSelf!.CarPhotoArr[weakSelf!.cellIndexRow] = url
            ///将需要上传到服务器的图片保存起来
            let dict = NSMutableDictionary()
            dict.setValue("\(appkey)", forKey: "photosrc")
            if weakSelf?.cellIndexRow < weakSelf?.CarPhotoStrArr.count {
                dict.setValue(weakSelf?.CarPhotoStrArr[(weakSelf?.cellIndexRow)!], forKey: "photoname")
            }else {
                dict.setValue("其他", forKey: "photoname")
            }

            weakSelf?.evidencedata.addObject(dict)
            
            weakSelf?.mainCollection.reloadData()
        }
        
        self.imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //自定图片长宽
    private func reSizeImage(image:UIImage,toSize:CGSize) ->UIImage
    {
        UIGraphicsBeginImageContext(CGSizeMake(toSize.width, toSize.height))
        image.drawInRect(CGRect(x: 0, y: 0, width: toSize.width, height: toSize.height))
        let reSizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        return reSizeImage
    }
    //把UIView做成一个UIImage,text:照片拍摄的部位
    func addViewImage(text:String?) -> UIImage{
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCRW, height: 160))
        //照片类型
        let label = UILabel(frame: CGRect(x: 15, y: 5, width: SCRW - 30, height: 25))
        label.textColor = UIColor.redColor()
        label.text = text
        label.font = UIFont.systemFontOfSize(20)
        view.addSubview(label)
        //地点Label
        let addressLabel = UILabel(frame: CGRect(x: 15, y: label.frame.origin.y + label.frame.height + 5, width: SCRW - 20, height: 45))
        //自动折行
        addressLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        addressLabel.numberOfLines = 0
        addressLabel.text = NSUserDefaults.standardUserDefaults().objectForKey("Kpt_address") as? String
        addressLabel.textColor = UIColor.redColor()
        addressLabel.font = UIFont.systemFontOfSize(20)
        view.addSubview(addressLabel)
        //时间label
        let date = NSDate()
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = dateformatter.stringFromDate(date)
        let dateLabel = UILabel(frame: CGRect(x: 15, y: addressLabel.frame.origin.y + addressLabel.frame.height + 5, width: SCRW - 30, height: 25))
        dateLabel.text = dateStr
        dateLabel.textColor = UIColor.redColor()
        dateLabel.font = UIFont.systemFontOfSize(20)
        view.addSubview(dateLabel)
        
        view.backgroundColor = UIColor.clearColor()
        
        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()
        return viewImage
    }
    
    //图片合成
    func addImage(LabelImage:UIImage,backImage:UIImage,rect:CGRect) ->UIImage
    {
    UIGraphicsBeginImageContext(backImage.size)
    //Draw image2
    backImage.drawInRect(CGRect(x: 0, y: 0, width: backImage.size.width, height: backImage.size.height))
    //Draw image1
    LabelImage.drawInRect(CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height))
    let resultImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return resultImage
    }
}

