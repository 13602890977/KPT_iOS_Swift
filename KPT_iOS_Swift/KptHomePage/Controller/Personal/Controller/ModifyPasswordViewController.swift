//
//  ModifyPasswordViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/7/12.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit
import MBProgressHUD

class ModifyPasswordViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var beforePassword: UITextField!
    @IBOutlet weak var afterPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改密码"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Plain, target: self, action: "backOnAnInterface")
        // Do any additional setup after loading the view.
    }
    func backOnAnInterface() {
        
        if self.beforePassword.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
            let alertC = UIAlertController.creatAlertWithTitle(title: nil, message: "请输入原密码\n", cancelActionTitle: "确定")
            self.presentViewController(alertC, animated: true, completion: nil)
            return
        }else if self.afterPassword.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 {
            let alertC = UIAlertController.creatAlertWithTitle(title: nil, message: "请输入新密码\n", cancelActionTitle: "确定")
            self.presentViewController(alertC, animated: true, completion: nil)
            return
        }
        self.beforePassword.resignFirstResponder()
        self.afterPassword.resignFirstResponder()
        
        self.hud.labelText = "更改中..."
        self.hud.show(true)
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        let personalData = userDefault.objectForKey("userInfoLoginData") as! NSDictionary
        let userInfoData = UserInfoData.mj_objectWithKeyValues(personalData)
        
        let parame = ["requestcode":"001004","accessid":userInfoData.accessid,"accesskey":userInfoData.accesskey,"userid":userInfoData.userid,"password":self.beforePassword.text,"newpassword":self.afterPassword.text]
        KptRequestClient.sharedInstance.Kpt_post("/plugins/changhui/port/resetPassword", paramet: parame, viewController: self, success: { (data) -> Void in
            print(data)
            self.hud.labelText = "登陆中..."
            self.loginBtnClick(userInfoData)
            
            }) { (_) -> Void in
         self.hud.hide(true)
        }
    }
    private func loginBtnClick(userInfo:UserInfoData) {
        let parameters : NSMutableDictionary = NSMutableDictionary()
        parameters.setValue("001002", forKey: "requestcode")
        parameters.setValue(userInfo.mobile, forKey: "mobile")
        parameters.setValue(self.afterPassword.text, forKey: "password")
        KptRequestClient.sharedInstance.Kpt_post("/plugins/changhui/port/login", paramet: parameters, viewController: self, success: { (data) -> Void in
            self.hud.labelText = "登陆成功"
            self.hud.hide(true,afterDelay: 2.0)
            print(data)
            let userDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            userDefault.setObject(data, forKey: "userInfoLoginData")
            userDefault.synchronize()
            
            self.navigationController?.popViewControllerAnimated(true)
            }) { (_) -> Void in
                self.hud.hide(true)
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "userInfoLoginData")
        }
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.beforePassword.resignFirstResponder()
        self.afterPassword.resignFirstResponder()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.returnKeyType == UIReturnKeyType.Next {
            self.afterPassword.becomeFirstResponder()
        }else {
            backOnAnInterface()
        }
        return true
    }
    private lazy var hud : MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
