//
//  Kpt_LoginViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/24.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class Kpt_LoginViewController: UIViewController {
    @IBOutlet weak var loginTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let navigationBar = self.navigationController!.navigationBar;
        // white.png图片自己下载个纯白色的色块，或者自己ps做一个
        navigationBar.setBackgroundImage(UIImage(named: "whiteNav"), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        navigationBar.shadowImage = UIImage()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Done, target: self, action: "cancelBtnClick:")
        UINavigationBar.appearance().tintColor = MainColor
        
        //设置push后界面的返回键样式
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        
        // Do any additional setup after loading the view.
    }

    func cancelBtnClick(sender:AnyObject?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func loginBtnClick(sender: AnyObject) {
        let parameters : NSMutableDictionary = NSMutableDictionary()
        parameters.setValue("001002", forKey: "requestcode")
        parameters.setValue(self.loginTextField.text, forKey: "mobile")
        parameters.setValue(self.passwordTextField.text, forKey: "password")
        KptRequestClient.sharedInstance.POST("/plugins/changhui/port/login", parameters: parameters, progress: nil, success: { (_, JSON) -> Void in
                let message = JSON?.objectForKey("errormessage")
            print(JSON!)
                if (message != nil) {
                    let alertV = UIAlertController(title: "温馨提醒", message: message as? String, preferredStyle: UIAlertControllerStyle.Alert)
                    let action = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
                    alertV.addAction(action)
                    self.presentViewController(alertV, animated: true, completion: nil)
                
                }else {
                    print("登陆成功")
                }
            }) { (_, error) -> Void in
                print(error)
        }
    }
    
    @IBAction func forgetPasswordBtnClick(sender: AnyObject) {
    }
    
    @IBAction func registerBtnClick(sender: AnyObject) {
        self.navigationController?.pushViewController(Kpt_RegisterViewController(nibName: "Kpt_RegisterViewController", bundle: nil), animated: true)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        FoldUpTheKeyboard()
    }
    //将键盘收起
    private func FoldUpTheKeyboard() {
        self.loginTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        FoldUpTheKeyboard()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
