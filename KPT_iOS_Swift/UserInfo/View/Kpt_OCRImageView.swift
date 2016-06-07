//
//  Kpt_OCRImageView.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/27.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import MBProgressHUD
import AFNetworking
///ocr识别的影像类型
enum ocr_type :Int{
    ///身份证 2
    case IdCard = 2
    ///驾驶证 5
    case DrivingLicense = 5
    ///行驶证 6
    case DrivingPermit = 6
}
typealias success = (ocrData:AnyObject?) ->Void

protocol Kpt_OCRImageViewDelegate {
//    optional
    func returnOCRDataAndImage(data:AnyObject)
}
class Kpt_OCRImageView: UIView {
    ///保存创建点击图片的controller
    private var superController:UIViewController!
    ///影像识别的证件类型
    private var ocrImageType:ocr_type!
    ///相机，相册
    private var imagePickerController:UIImagePickerController!
    
    var ocrDelegate:Kpt_OCRImageViewDelegate?
    
    class func creatTouchImage(frame:CGRect,documentType:String?,controller:UIViewController?) ->Kpt_OCRImageView {
        let image = Kpt_OCRImageView(frame: frame)
        image.userInteractionEnabled = true
        image.label.text = "拍照识别您的\(documentType!)信息"
        image.label.font = UIFont.systemFontOfSize(14)
        image.addSubview(image.label)
        image.superController = controller
        if documentType == "身份证" {
            image.ocrImageType = ocr_type.IdCard
        }else if documentType == "驾驶证" {
            image.ocrImageType = ocr_type.DrivingLicense
        }else {
            image.ocrImageType = ocr_type.DrivingPermit
        }
        
        return image
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.touchImageView)
        touchImageView.frame = CGRect(x: 35, y: 10, width: SCRW - 70, height: self.frame.size.height - 40)
        print(touchImageView)
        touchImageView.backgroundColor = UIColor.orangeColor()
        
    }

    lazy var touchImageView:UIImageView = {
       let imageV = UIImageView()
        imageV.userInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: "touchImageClick")
        imageV.addGestureRecognizer(tap)
        return imageV
    }()
    ///加载时的提示语
    private lazy var hud : MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.superController.view, animated: true)
    
    func touchImageClick() {
        print("点击图片，弹出选择框")
        if true {
            let alertV = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            // 判断是否支持相机
            weak var weakSelf = self
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
                
                let cameraAlert = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default, handler: { (cameraAlert) -> Void in
                    weakSelf!.imagePickerController = UIImagePickerController()
                    weakSelf!.imagePickerController.allowsEditing = true
                    weakSelf!.imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
                    weakSelf!.superController.presentViewController(weakSelf!.imagePickerController, animated: true, completion: { () -> Void in
                        weakSelf!.imagePickerController.delegate = weakSelf!
                    })
                })
                alertV.addAction(cameraAlert)
            }
            let albumAlert = UIAlertAction(title: "从相片中选择", style: UIAlertActionStyle.Default, handler: { (albumAlert) -> Void in
                weakSelf!.imagePickerController = UIImagePickerController()
                weakSelf!.imagePickerController.allowsEditing = true
                weakSelf!.imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                weakSelf!.superController.presentViewController(weakSelf!.imagePickerController, animated: true, completion: { () -> Void in
                    weakSelf!.imagePickerController.delegate = weakSelf!
                })

            })

            let cancelAlert = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler:nil)
            alertV.addAction(cancelAlert)
            
            alertV.addAction(albumAlert)
            
            superController.presentViewController(alertV, animated: true, completion: nil)
        }
        
    }
    private lazy var label:UILabel = {
        let imageLabel = UILabel(frame: CGRect(x: 30, y: self.frame.size.height - 25 , width: SCRW - 60, height: 20))
        imageLabel.textAlignment = NSTextAlignment.Center
        return imageLabel
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension Kpt_OCRImageView :UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        //TODO:选择照片或者照相完成以后的处理
        print(info)
        let image:UIImage = info [UIImagePickerControllerEditedImage] as! UIImage
        
        self.touchImageView.image = image
        
        let imageData = UIImageJPEGRepresentation(image, 0.1)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let dateStr = formatter.stringFromDate(NSDate())
        let fileName = "\(dateStr).png"
        
        weak var weakSelf = self
//        postPatternRecognitionWithType(imageData!,imageName:fileName,suc: { (ocrData) -> Void in

//        })
//        
        if self.ocrDelegate != nil {
            self.ocrDelegate?.returnOCRDataAndImage("str")
        }
        self.imagePickerController.dismissViewControllerAnimated(true, completion: nil)
    }
    ///翔云图像识别
    func postPatternRecognitionWithType(imageData:NSData,imageName:String,suc:success) {
    
        print(self.ocrImageType.rawValue)
        let parms:[String:AnyObject] = ["key":OCR_KEY,
            "secret":OCR_SECRET,
            "typeId":self.ocrImageType.rawValue,
            "format":"json"
        ]
        
        self.hud.labelText = "信息识别中，请稍等..."
        self.hud.show(true)
        let manager = AFHTTPSessionManager()
        manager.POST("http://netocr.com/api/recog.do", parameters: parms, constructingBodyWithBlock: { (formData) -> Void in
            formData.appendPartWithFileData(imageData, name: "file", fileName:imageName, mimeType: "image/jpeg")
            
            }, progress: nil, success: { (_, JSON) -> Void in
                print(JSON)
                
                let dictMessage = (JSON as? NSDictionary)?.objectForKey("message")!
                if dictMessage?.objectForKey("status") as! Int > 0 {
                    let dictCardsinfo = (JSON as? NSDictionary)?.objectForKey("cardsinfo")!
                    suc(ocrData: dictCardsinfo?.firstObject!?.objectForKey("items"))
                }else {
                    let alertV = UIAlertController(title: "温馨提醒", message: dictMessage!.objectForKey("value") as? String, preferredStyle: UIAlertControllerStyle.Alert)
                    let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
                    alertV.addAction(action)
                    self.superController.presentViewController(alertV, animated: true, completion: nil)
                }
                 self.hud.hide(true)
            }) { (_, error) -> Void in
                print(error)
                 self.hud.hide(true)
        }
        
    }

}