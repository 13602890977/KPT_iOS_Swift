//
//  Kpt_RegisterViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/5/25.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit

class Kpt_RegisterViewController: UIViewController {

    @IBOutlet weak var photoTextField: UITextField!
    @IBOutlet weak var reCaptchaButton: UIButton!
    @IBOutlet weak var reCaptchaTextField: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        reCaptchaButton.layer.cornerRadius = 5
    }

    @IBAction func reCaptchaBtnClick(sender: AnyObject) {
        //先判读电话号码无误
        let bl = photoTextField.text?.isPhotoNumber()
        print("\(bl!) 正规电话号码")
        //调用后台验证码接口，获取验证码，比对用户输入的验证码
        
        //开始倒计时
        //1.设定计时时长
        var timeout:Int = 60//结束时间
        //2.开启子线程
        let queue:dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        //3.创建计时器
        let timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        //4.设置计时器时长(1秒 1 * NSEC_PER_SEC）
        dispatch_source_set_timer(timer, dispatch_walltime(nil, 0), 1 * NSEC_PER_SEC, 0)
        weak var weakSelf = self//解决闭包循环引用 方法一
        //5.设置计时器的执行方法的内容
        dispatch_source_set_event_handler(timer) {/*[weak self]解决闭包循环引用 方法二*/ () -> Void in
            if timeout == 0 {
                dispatch_source_cancel(timer)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    weakSelf?.reCaptchaButton.setTitle("获取验证码", forState: UIControlState.Normal)
                    weakSelf?.reCaptchaButton.userInteractionEnabled = true
                })
            }else {
                let seconds = timeout
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    weakSelf?.reCaptchaButton.setTitle("\(seconds) 秒", forState: UIControlState.Normal)
                    weakSelf?.reCaptchaButton.userInteractionEnabled = false
                })
            }
            timeout--
        }
        //6.启动计时器
        dispatch_resume(timer);
        
    }
    @IBAction func registerButtonClick(sender: AnyObject) {
        //判断所填写的信息无误
        
        //弹出提示框，是否完善个人信息
        
        //跳转到指定界面
        navigationController?.pushViewController(UserInfoViewController(), animated: true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        FoldUpTheKeyboard()
    }
    //将键盘收起
    private func FoldUpTheKeyboard() {
        self.photoTextField.resignFirstResponder()
        self.reCaptchaTextField.resignFirstResponder()
        self.passwordText.resignFirstResponder()
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
