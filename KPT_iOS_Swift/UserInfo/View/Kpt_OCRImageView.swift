//
//  Kpt_OCRImageView.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/27.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class Kpt_OCRImageView: UIView {
    class func creatTouchImage(frame:CGRect,documentType:String?) ->Kpt_OCRImageView {
        let image = Kpt_OCRImageView(frame: frame)
        image.userInteractionEnabled = true
        image.label.text = "拍照识别您的\(documentType!)信息"
        image.label.font = UIFont.systemFontOfSize(14)
        image.addSubview(image.label)
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
    func touchImageClick() {
        print("点击图片，弹出选择框")
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
