//
//  Kpt_OCRImageView.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/27.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import MBProgressHUD

class Kpt_OCRImageView: UIView {
    ///保存创建点击图片的controller
    private var superController:UIViewController!
    
    ///相机，相册
    private var imagePickerController:UIImagePickerController!
    class func creatTouchImage(frame:CGRect,documentType:String?,controller:UIViewController?) ->Kpt_OCRImageView {
        let image = Kpt_OCRImageView(frame: frame)
        image.userInteractionEnabled = true
        image.label.text = "拍照识别您的\(documentType!)信息"
        image.label.font = UIFont.systemFontOfSize(14)
        image.addSubview(image.label)
        image.superController = controller
        return image
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.imageView)
        imageView.frame = CGRect(x: 35, y: 10, width: SCRW - 70, height: self.frame.size.height - 40)
        print(imageView)
        imageView.backgroundColor = UIColor.orangeColor()
        
    }

    private lazy var imageView:UIImageView = {
       let imageV = UIImageView()
        imageV.userInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: "touchImageClick")
        imageV.addGestureRecognizer(tap)
        return imageV
    }()
    ///加载时的提示语
    private lazy var hud : MBProgressHUD = MBProgressHUD()
    
    func touchImageClick() {
        print("点击图片，弹出选择框")
        if true {
            let alertV = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            // 判断是否支持相机
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
                
                weak var weakSelf = self
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
        let imageData = UIImageJPEGRepresentation(image, 1)
        // 拍摄的照片存到系统相册
        if picker.sourceType == UIImagePickerControllerSourceType.Camera {
            UIImageWriteToSavedPhotosAlbum(image, self, "", nil)
            
        }
        
        
    }
}