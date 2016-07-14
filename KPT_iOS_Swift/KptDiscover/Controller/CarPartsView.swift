//
//  CarPartsView.swift
//  ScrollerDemo
//
//  Created by jacks on 16/6/23.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class CarPartsView: UIView {
    
    ///部位图片数组(根据tag区分)
    @IBOutlet var image: [UIImageView]!
    
    //用于标记动画播放次数
    private var count:Int = 0
    //用于保存住vc，用于控制当前view
    var onlineVC : OnlineInsuranceViewController!
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func CarParstsButtonClick(sender: AnyObject) {
        
        (sender as! UIButton).selected = !(sender as! UIButton).selected
        
        if (sender as! UIButton).selected == true {
            
//            if #available(iOS 8.0, *) {
                let alertS = UIAlertController(title: "选择受损程度", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
                let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (cancelAction) -> Void in
                    (sender as! UIButton).selected = !(sender as! UIButton).selected
                })
                alertS.addAction(cancelAction)
                
                let lightAction = UIAlertAction(title: "轻度受损(维修方式:喷漆)默认", style: UIAlertActionStyle.Default) { (lightAction) -> Void in
                    self.count = 0
                    let dict : NSMutableDictionary = ["partid":"\(sender.tag)","partname":((sender as! UIButton).titleLabel?.text)!,"damagedlevelcode":"1","damagedlevel":"轻度受损"]
                    self.onlineVC.partsArr.addObject(dict)
                    (sender as! UIButton).setTitleColor(MainColor, forState: UIControlState.Normal)
                    (sender as! UIButton).setImage(UIImage(named: "round_y"), forState: UIControlState.Normal)
                    self.animationAlphaA(sender.tag)
                }
                alertS.addAction(lightAction)
                
                let moderateAction = UIAlertAction(title: "中度受损(维修方式:钣金+喷漆)", style: UIAlertActionStyle.Default) { (moderateAction) -> Void in
                    self.count = 0
                    let dict : NSMutableDictionary = ["partid":"\(sender.tag)","partname":((sender as! UIButton).titleLabel?.text)!,"damagedlevelcode":"2","damagedlevel":"中度受损"]
                    self.onlineVC.partsArr.addObject(dict)
                    (sender as! UIButton).setTitleColor(MainColor, forState: UIControlState.Normal)
                    (sender as! UIButton).setImage(UIImage(named: "round_y"), forState: UIControlState.Normal)
                    self.animationAlphaA(sender.tag)
                }
                alertS.addAction(moderateAction)
                
                let severeAction = UIAlertAction(title: "重度受损(维修方式:更换配件)", style: UIAlertActionStyle.Default) { (severeAction) -> Void in
                    self.count = 0
                    let dict : NSMutableDictionary = ["partid":"\(sender.tag)","partname":((sender as! UIButton).titleLabel?.text)!,"damagedlevelcode":"3","damagedlevel":"重度受损"]
                    self.onlineVC.partsArr.addObject(dict)
                    (sender as! UIButton).setTitleColor(MainColor, forState: UIControlState.Normal)
                    (sender as! UIButton).setImage(UIImage(named: "round_y"), forState: UIControlState.Normal)
                    self.animationAlphaA(sender.tag)
                }
                alertS.addAction(severeAction)
                
                self.onlineVC.presentViewController(alertS, animated: true, completion: nil)
//            } else {
//                // Fallback on earlier versions
//            }
            
        }else {
            (sender as! UIButton).setTitleColor(UIColor(red: 170/255.0, green: 170/255.0, blue: 170/255.0, alpha: 1.0), forState: UIControlState.Normal)
            (sender as! UIButton).setImage(UIImage(named: "round_w"), forState: UIControlState.Normal)
            
            for icon in image {
                if icon.tag == sender.tag + 1 {
                    icon.alpha = 0
                }
            }
            for dict in (self.getCurrentVC() as! OnlineInsuranceViewController).partsArr {
                let dic = dict as? NSMutableDictionary
                if (dic?.objectForKey("partid"))! as! String == "\(sender.tag)" {
                    self.onlineVC.partsArr.removeObject(dict)
                }
            }
            
        }
    }
    
    //pragma mark - 动画
    func animationAlphaA(tag:Int)
    {
    
        var animaImg = UIImageView()
        for icon in image {
            if tag + 1 == icon.tag {
                animaImg = icon
            }
        }
        self.count++;
        animaImg.alpha = 0;
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            animaImg.alpha = 0.6
            }) { (_) -> Void in
                if self.count > 3 {
                    return
                }
                self.animationAlphaB(animaImg)
        }
    }
   
    func animationAlphaB(animaImg:UIImageView)
    {
        self.count++;
        animaImg.alpha = 0.6;
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            animaImg.alpha = 0
            }) { (_) -> Void in
                self.animationAlphaA(animaImg.tag - 1)
        }
    }
    
    func getPersentedViewController() -> UIViewController {
        let appRootVC = UIApplication.sharedApplication().keyWindow?.rootViewController
        var topVC = appRootVC
        if topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        return topVC!
    }
    
    //获取当前屏幕显示的viewcontroller
    func getCurrentVC() ->UIViewController
    {
        var result = UIViewController()
        var window = UIApplication.sharedApplication().keyWindow
            
        if window?.windowLevel != UIWindowLevelNormal {
            let windows = UIApplication.sharedApplication().windows
            for tmpWin in windows {
                if tmpWin.windowLevel == UIWindowLevelNormal {
                    window = tmpWin;
                    break;
                }
            }
        }
        let frontView = window?.subviews.first
        let nextResponder = frontView?.nextResponder()
        
        if ((nextResponder?.isKindOfClass(UIViewController.classForCoder())) != nil) {
            result = nextResponder as! UIViewController
        }else{
            result = window!.rootViewController!
        }
        return result;
    }
    
}
