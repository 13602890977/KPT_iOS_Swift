//
//  GlobalConstant.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/18.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import Qiniu

///屏幕宽
let SCRW = UIScreen.mainScreen().bounds.size.width
///屏幕高
let SCRH = UIScreen.mainScreen().bounds.size.height

///屏幕最高多高
let SCREEN_MAX_LENGTH = max(SCRW, SCRH)

///高德地图APIKey
let APIKEY = "b7882ff4e542e01d5e6f718caf6706f0"
///App主色调
let MainColor = UIColor(red: 242/255.0, green: 170/255.0, blue: 3/255.0, alpha: 1)

let OCR_URL = "http://netocr.com/api/recog.do"
let OCR_KEY = "Jwm1mLCPBxmYiz8Aw8iZ8Y"
let OCR_SECRET = "1159b1c725f94b458f97352008d94add"

let ACCESS_KEY = "hRqWEMoCtEhE_9YRSA5_iHNhV9JIf4QWFAboYIki"
let SECRET_KEY = "xjsYd-lcKbqzX1LxOb_NBGtELN5HseTt-WWPDIQs"
let BUCKET = "kuaipeitong"
let TAG = "QiniuUtils"
let QinniuUrl = "http://7xttl7.com2.z0.glb.qiniucdn.com/"

let QiniuToken = NSObject.makeToken(ACCESS_KEY, secretKey: SECRET_KEY)
extension String {
    
    var md5: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.destroy()
        
        return String(format: hash as String)
    }
    
     func isPhotoNumber() -> Bool {
        var regex:NSRegularExpression
        do {
           regex = try NSRegularExpression(pattern: "^[1][3578][0-9]{9}$", options: NSRegularExpressionOptions.CaseInsensitive)
            let matches = regex.matchesInString(self, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0,self.characters.count))
            if matches.count < 1 {
                return false
            }
            return true
        }catch {
            print("使用电话号码正则表达式判断失败 - error\(error)")
        }
        return false
    }
    
}


extension NSObject {
    func IS_IPHONE()->Bool {
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Phone
    }
    //设备(根据屏幕最大高度判读)
    func IS_IPHONE_4_OR_LESS() -> Bool {
        return IS_IPHONE() && SCREEN_MAX_LENGTH < 568.0
    }
    func IS_IPHONE_5() -> Bool {
        return IS_IPHONE() && SCREEN_MAX_LENGTH == 568.0
    }
    func IS_IPHONE_6() ->Bool {
        return IS_IPHONE() && SCREEN_MAX_LENGTH == 667.0
    }
    func IS_IPHONE_6P() ->Bool {
        return IS_IPHONE() && SCREEN_MAX_LENGTH == 736.0
    }
    
    //代码创建model类
    class func createModelWithDictionary(dict:NSDictionary ,modelName:String)
    {
        print("\nclass \(modelName as NSString) : NSObject{\n")
        for key in dict.allKeys {
            var type = dict.objectForKey(key as! String)!.isKindOfClass(NSNumber.classForCoder()) ? "NSNumber" : "String"
            
            if dict.objectForKey(key as! String)!.isKindOfClass(NSNumber.classForCoder()) {
                type = "NSNumber"
            }else if dict.objectForKey(key as! String)!.isKindOfClass(NSArray.classForCoder()) {
                type = "NSArray"
            }else if dict.objectForKey(key as! String)!.isKindOfClass(NSDictionary.classForCoder()) {
                type = "NSDictionary"
            }else {
                type = "String"
            }
            
            print("var \(key): \(type)!\n")
            
    }
        print("}\n")
    
    }
    ///获取手机设备型号
    func getPhoneModel() ->String? {
        let name = UnsafeMutablePointer<utsname>.alloc(1)
        uname(name)
        let machine = withUnsafePointer(&name.memory.machine, { (ptr) -> String? in
            
            let int8Ptr = unsafeBitCast(ptr, UnsafePointer<CChar>.self)
            return String.fromCString(int8Ptr)
        })
        name.dealloc(1)
        if let deviceString = machine {
            switch deviceString {
                //iPhone
            case "iPhone1,1":                return "iPhone 1G"
            case "iPhone1,2":                return "iPhone 3G"
            case "iPhone2,1":                return "iPhone 3GS"
            case "iPhone3,1", "iPhone3,2":   return "iPhone 4"
            case "iPhone4,1":                return "iPhone 4S"
            case "iPhone5,1", "iPhone5,2":   return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":   return "iPhone 5C"
            case "iPhone6,1", "iPhone6,2":   return "iPhone 5S"
            case "iPhone7,1":                return "iPhone 6 Plus"
            case "iPhone7,2":                return "iPhone 6"
            case "iPhone8,1":                return "iPhone 6s"
            case "iPhone8,2":                return "iPhone 6s Plus"
            default:
                return deviceString
            }
        } else {
            return nil
        }
    }
    
    ///获取当前时间的秒数
    func currentTimestamp() -> String{
        let sTime = "\(NSDate().timeIntervalSince1970 * 1000)"
        print(sTime);
        return (sTime as NSString).substringToIndex(13)
    }
    ///通过第一个字节判断:文件类型
    func typeForImageData(data:NSData)->String? {
        var c : Int!
        data.getBytes(&c, length: 1)
        switch (c) {
        case 0xFF:
            return "jpeg"
        case 0x89:
            return "png"
        case 0x47:
            return "gif"
        case 0x49:
            return "tiff"
        case 0x4D:
            return "tiff"
        default:
            return nil
        }
        
    }
    
    ///判断保险公司列表存在,如果不存在，就从服务器请求下来并存储
    func storageAndReadingListOfInsuranceCompanies() {
        let insuranceArr = NSArray(contentsOfFile: NSHomeDirectory() + "/Documents/insurance.plist")
        if insuranceArr == nil {
            let userDefault = NSUserDefaults.standardUserDefaults()
            let personalData = userDefault.objectForKey("userInfoLoginData") as! NSDictionary
            let userInfoData = UserInfoData.mj_objectWithKeyValues(personalData)
            
            let paramet = ["requestcode":"003005","accessid":userInfoData.accessid,"accesskey":userInfoData.accesskey,"userid":userInfoData.userid,"type":"insurance"]
            
            KptRequestClient.sharedInstance.Kpt_post("/plugins/changhui/port/getDict", paramet: paramet, viewController: nil, success: { (data) -> Void in
                let filePath:String = NSHomeDirectory() + "/Documents/insurance.plist"
                (data as! NSArray).writeToFile(filePath, atomically: true)
                }, failure: { (_) -> Void in
                    
            })
        }
    }
    
    ///判断驾驶证是否存在，如果不存在，就从服务器请求下来并存储
    func storageUserdefaultDriving() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        let personalData = userDefault.objectForKey("userInfoLoginData") as! NSDictionary
        let userInfoData = UserInfoData.mj_objectWithKeyValues(personalData)
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "Kpt_Licenseno")
        //获取驾驶证
        let getDrivingParamet = ["requestcode":"001010","accessid":userInfoData.accessid,"accesskey":userInfoData.accesskey,"userid":userInfoData.userid]
        
        KptRequestClient.sharedInstance.Kpt_post("/plugins/changhui/port/user/getDrivingLicenseInfo", paramet: getDrivingParamet, viewController: nil, success: { (data) -> Void in
            if let dict = data as? NSDictionary {
                let model = DrivingLicenseModel.mj_objectWithKeyValues(dict)
                NSUserDefaults.standardUserDefaults().setValue(model.drivinglicenseno, forKey: "Kpt_Licenseno")
                NSUserDefaults.standardUserDefaults().synchronize()
                
            }
            }, failure: { (_) -> Void in
                
        })
    }
    
    /**七牛图片上传
     *  image:需要上传到七牛的照片(传入之后会被压缩0.1，可设置)
     *  success:返回七牛返回的照片urlStr(不包含请求头，需要自己添加七牛的路径)
     */
    func QiniuPhotoUpdateReturnImageUrlStr(image:UIImage,success:(String ->Void)?) {
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        
        let upManager = QNUploadManager()
        let QiniuToken = NSObject.makeToken(ACCESS_KEY, secretKey: SECRET_KEY)
        
        upManager.putData(imageData, key: nil, token: QiniuToken, complete: { (info, key, resp) -> Void in
            let Appkey = resp["key"]
            let str = "\(Appkey!)"
            success!(str)
            }, option: nil)
    }
    
}

extension UIImage {
    func sizeThatFits(size:CGSize) ->CGSize {
        var imageSize = CGSizeMake(self.size.width / self.scale, self.size.height / self.scale)
        let widthRatio = imageSize.width / size.width
        let heightRatio = imageSize.height / size.height
        if widthRatio > heightRatio {
            imageSize = CGSizeMake(imageSize.width / widthRatio, imageSize.height / heightRatio)
        }else {
            imageSize = CGSizeMake(imageSize.width / heightRatio, imageSize.height / heightRatio)
        }
        return imageSize
    }
}
extension UIImageView {
    func contentSize() ->CGSize {
        return (self.image?.sizeThatFits(self.bounds.size))!
    }
}


