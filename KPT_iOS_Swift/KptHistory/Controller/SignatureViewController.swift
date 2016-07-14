//
//  SignatureViewController.swift
//  KPT_iOS_Swift
//
//  Created by jacks on 16/6/29.
//  Copyright © 2016年 yunqiao. All rights reserved.
//

import UIKit


typealias returnSignImage = (image :UIImage) -> Void

class SignatureViewController: UIViewController {

    
    private var signImage : returnSignImage!
    var mySignImage : Kpt_SignView!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = MainColor
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.title = "签名"
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        mySignImage = Kpt_SignView(frame:CGRect(x:8, y: 74, width: SCRW - 16, height: SCRH - 174))
        
        mySignImage.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(mySignImage)
        
        // Do any additional setup after loading the view.
    }

    @IBAction func revivedBtnClick(sender: AnyObject) {
        mySignImage.clearSignature()
        
    }
    @IBAction func finishBtnClick(sender: AnyObject) {
        let image = mySignImage.getSignature()
        
        print("截屏\(image)")
        if self.signImage != nil {
            self.signImage(image:image)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func returnSignResult(image:returnSignImage) {
        self.signImage = image
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
