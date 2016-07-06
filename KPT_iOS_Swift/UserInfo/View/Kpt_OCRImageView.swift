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
import Qiniu

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
    func returnOCRDataAndImage(image:UIImage?,QNImageUrl:String,data:AnyObject)
}
class Kpt_OCRImageView: UIView {
    ///保存创建点击图片的controller
    private var superController:UIViewController!
    ///影像识别的证件类型
    private var ocrImageType:ocr_type!
    ///相机，相册
    private var imagePickerController:UIImagePickerController!
    ///保存七牛图片返回的图片url
    private var potosUrl:String! {
        didSet {
            self.ocrDataDict.setObject(potosUrl, forKey: "QNImageUrl")
        }
    }
    
    var ocrDelegate:Kpt_OCRImageViewDelegate?
    
    class func creatTouchImage(frame:CGRect,documentType:String?,controller:UIViewController?) ->Kpt_OCRImageView {
        let image = Kpt_OCRImageView(frame: frame)
        image.userInteractionEnabled = true
        image.label.text = "拍照识别您的\(documentType!)信息"
        image.label.font = UIFont.systemFontOfSize(14)
        image.addSubview(image.label)
        image.addSubview(image.topLabel)
        
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
        touchImageView.frame = CGRect(x: 60, y: 35, width: SCRW - 120, height: (SCRW - 120) / 400 * 250)
        touchImageView.layer.borderWidth = 1.0
        displayImageView.frame = CGRect(x: 20, y: 10, width: touchImageView.frame.size.width - 40, height: (touchImageView.frame.size.width - 40) / 400 * 250)
        touchImageView.addSubview(displayImageView)
        
    }

    lazy var touchImageView:UIImageView = {
       let imageV = UIImageView()
        imageV.userInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: "touchImageClick")
        imageV.addGestureRecognizer(tap)
        
        return imageV
    }()
    lazy var displayImageView:UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage(named: "矢量智能对象")
        imageV.contentMode = UIViewContentMode.Center
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
        let imageLabel = UILabel(frame: CGRect(x: 30, y: self.touchImageView.frame.height + self.touchImageView.frame.origin.y  + 5 , width: SCRW - 60, height: 20))
        imageLabel.textAlignment = NSTextAlignment.Center
        return imageLabel
    }()
    private lazy var topLabel:UILabel = {
        let imageLabel = UILabel(frame: CGRect(x: 30, y: 15 , width: SCRW - 60, height: 20))
        imageLabel.textAlignment = NSTextAlignment.Center
        imageLabel.text = "拍照识别"
        return imageLabel
    }()
    ///保存ocr识别的数据
    private lazy var ocrDataDict : NSMutableDictionary = NSMutableDictionary()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension Kpt_OCRImageView :UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        //TODO:选择照片或者照相完成以后的处理
        print(info)
        let image:UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.displayImageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.displayImageView.image = image
        
        let imageData = UIImageJPEGRepresentation(image, 0.1)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let dateStr = formatter.stringFromDate(NSDate())
        let fileName = "\(dateStr).png"
        
        weak var weakSelf = self
        //七牛图片上传
        image.QiniuPhotoUpdateReturnImageUrlStr(image) { (appkey) -> Void in
            weakSelf!.potosUrl = QinniuUrl.stringByAppendingString("\(appkey)")
        }
        
        
        postPatternRecognitionWithType(imageData!,imageName:fileName,suc: { (ocrData) -> Void in
            //数据使用代理返回
            if weakSelf!.ocrDelegate != nil {
                weakSelf!.ocrDelegate?.returnOCRDataAndImage(image,QNImageUrl: weakSelf!.potosUrl, data: ocrData!)
            }
        })
        
        
        weakSelf!.imagePickerController.dismissViewControllerAnimated(true, completion: nil)
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
            print(formData)
            formData.appendPartWithFileData(imageData, name: "file", fileName: imageName, mimeType: "image/jpeg")
            
            }, success: { (_, JSON) -> Void in
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
                self.hud.labelText = "识别信息成功，请确认是否正确"
                 self.hud.hide(true, afterDelay: 0.5)
            }) { (_, error) -> Void in
                print(error)
                self.hud.hide(true)
        }
    }

}